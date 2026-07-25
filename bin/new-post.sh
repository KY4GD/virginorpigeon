#!/usr/bin/env bash
#
# Scaffold a new blog post with the correct front matter.
#
#   bin/new-post.sh "My Post Title"
#
# Creates _posts/YYYY-MM-DD-<slug>.md, ready to write in. Fill in categories,
# tags, and the excerpt (used as the meta description and social preview text),
# then commit + push and Cloudflare Pages deploys it automatically.

set -euo pipefail

if [ $# -lt 1 ] || [ -z "${1:-}" ]; then
  echo "Usage: bin/new-post.sh \"My Post Title\"" >&2
  exit 1
fi

title="$*"
date="$(date +%Y-%m-%d)"

# slug: lowercase, spaces/punctuation -> hyphens, trim
slug="$(printf '%s' "$title" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
file="$repo_root/_posts/${date}-${slug}.md"

if [ -e "$file" ]; then
  echo "Already exists: $file" >&2
  exit 1
fi

cat > "$file" <<EOF
---
layout: post
title: "${title//\"/\\\"}"
date: ${date}
slug: ${slug}
categories: []
tags: []
excerpt: ""
---

Write your post here.
EOF

echo "Created: $file"
echo
echo "Next:"
echo "  1. Edit the file (fill in categories, tags, excerpt, and the body)."
echo "  2. Preview locally:  bundle exec jekyll serve   ->  http://localhost:4000"
echo "  3. Publish:          git add -A && git commit -m \"post: ${title}\" && git push"
