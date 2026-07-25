# Human Action Required

**Status:** Blocking all Cloudflare work. The repository audit (build, spelling, links, HTML) can proceed without this.

**Date:** 2026-07-25

---

## 1. What is needed

A **scoped Cloudflare API token**, saved to a file at `~/.cf_token`.

## 2. Why it is needed

There are currently no Cloudflare credentials on this machine: `~/.config/.wrangler` contains only an
empty `logs/` directory, and no `CLOUDFLARE_API_TOKEN` is set in the environment.

Wrangler alone is **not sufficient**, and `wrangler login` will not fix this. Wrangler manages Workers
and Pages *projects*. It cannot read or change any of the following, all of which this audit needs:

| Needed for | Managed by |
|---|---|
| SSL/TLS mode, Always Use HTTPS, TLS 1.3, HSTS | Zone Settings API |
| Brotli, HTTP/3, Early Hints, **Rocket Loader** | Zone Settings API |
| WAF managed rules, Browser Integrity Check, Bot Fight Mode | Zone WAF / Zone Settings API |
| Cache rules, redirect rules, response-header transform rules | Rulesets API |
| Web Analytics (RUM) site configuration | Account-level Web Analytics API |
| Confirming which Pages project serves which custom domain | Pages API |

So a REST API token is required regardless. Requesting it once, scoped correctly, avoids a second
interruption later.

**Do not create a Global API Key.** It is unscoped, grants full account control, and is explicitly
out of scope for this work.

## 3. Least-privilege permissions

Two zones are involved — `virginorpigeon.org` and `virginorpigeon.net` — plus one account.

Grant **exactly** these and nothing more. Permission names below are verbatim from Cloudflare's
current [API token permissions reference](https://developers.cloudflare.com/fundamentals/api/reference/permissions/)
and the [Cache Rules API docs](https://developers.cloudflare.com/cache/how-to/cache-rules/create-api/).

### Zone permissions — apply to **both** zones

| Permission | Why |
|---|---|
| `Zone` → `Zone` → `Read` | Identify zone IDs, plan level, status |
| `Zone` → `Zone Settings` → `Read` | Record the "before" configuration snapshot |
| `Zone` → `Zone Settings` → `Edit` | SSL mode, Always Use HTTPS, TLS 1.3, Brotli, HTTP/3, Rocket Loader |
| `Zone` → `DNS` → `Read` | Confirm proxy status. **Read only — I will not modify DNS.** |
| `Zone` → `Cache Rules` → `Edit` | Static-asset cache rules |
| `Zone` → `Single Redirect` → `Edit` | The `.org → .net` canonical 301 (dashboard: Rules → Redirect Rules). **This is the permission that was missing from the first token** — the UI label is "Single Redirect", not "Dynamic Redirect". |
| `Zone` → `Zone WAF` → `Edit` | Free managed WAF ruleset |
| `Zone` → `Analytics` → `Read` | Compare edge analytics against RUM analytics |

### Account permissions

| Permission | Why |
|---|---|
| `Account` → `Account Rulesets` → `Edit` | Required alongside Cache Rules per Cloudflare docs |
| `Account` → `Account Filter Lists` → `Edit` | Required alongside Cache Rules per Cloudflare docs |
| `Account` → `Cloudflare Pages` → `Edit` | Fix the soft-404: the Pages project returns HTTP 200 (the homepage) for every unknown URL, which keeps dead URLs indexed. Correcting `not_found_handling` needs Edit, not just Read. Also confirms the project, build config, and custom domains. |

### Deliberately NOT requested

- `DNS Edit` — I will not touch DNS records or nameservers.
- Billing, Membership, Zero Trust, SSL/Certificates Edit, Workers Scripts Edit — out of scope.

### One item I could not verify

The public permissions reference does not list a **Web Analytics / RUM** permission name. Once the
token exists I will call `GET /user/tokens/permission_groups` to get the exact current name and tell
you precisely what to add. Until then, Web Analytics may need to be enabled with one click in the
dashboard instead:
**Cloudflare dashboard → Analytics & Logs → Web Analytics → Add a site**.

## 4. Exact steps for you

1. Go to https://dash.cloudflare.com/profile/api-tokens
2. **Create Token** → **Custom token** → **Get started**
3. Name it something like `site-audit-2026-07`
4. Add the **Permissions** rows exactly as tabled above.
5. Under **Zone Resources**, add two entries:
   - `Include` → `Specific zone` → `virginorpigeon.org`
   - `Include` → `Specific zone` → `virginorpigeon.net`
6. Under **Account Resources**: `Include` → your account.
7. **TTL**: set an end date roughly a week out. This work does not need a permanent token.
8. Optionally restrict by **Client IP Address** to this machine's public IP.
9. **Continue to summary** → **Create Token**
10. Copy the token. Cloudflare shows it exactly once.

## 5. How to hand it to me

Do **not** paste the token into the chat and do **not** type it as part of a command — it would
land in your shell history and in the transcript.

Save it to a file instead. In your browser or editor, write the token as the only line of:

```
/home/carll/.cf_token
```

Then run this one command to lock down its permissions:

```
chmod 600 ~/.cf_token
```

That path is in your home directory, outside this repository, so it can never be committed.

Tell me when it is in place and I will read it from there.

## 6. How I will verify it

I will run these and report only the redacted result — never the token itself:

```
curl -sS https://api.cloudflare.com/client/v4/user/tokens/verify \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN"
```

Expected: `"status": "active"`.

Then I will confirm the token can read both zones and cannot do anything unintended, and save a
redacted "before" snapshot of both zones' settings to `cloudflare-before.json` prior to changing
anything.

## 7. Security precautions I will follow

- The token is read from the environment, never written into a tracked file, script, or commit.
- No token, account ID, or zone ID is echoed to the terminal, logs, reports, or GitHub.
- Full unredacted API responses are never committed.
- I will not enable any paid product, trial, or usage-based feature.
- I will not change nameservers, delete DNS records, migrate hosting, or enable HSTS preload
  without asking you first.

## 8. Revoking it afterwards

When this work is finished:

1. https://dash.cloudflare.com/profile/api-tokens → the token's **…** menu → **Delete**
2. `rm ~/.cf_token`
