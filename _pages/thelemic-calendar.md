---
layout: page
title: "Thelemic Calendar"
permalink: /thelemic-calendar/
image: "/assets/images/uploads/magickreak1.jpeg"
---

<div class="tc-panel">
  <div class="tc-inner">
    <p class="tc-motto">Do what thou wilt shall be the whole of the Law.</p>

    <div class="tc-header" id="tc-header">
      <span id="tc-sol">&#9737;</span><br>
      <span id="tc-luna">&#9789;</span><br>
      <span id="tc-dies"></span>
      <span class="tc-anno" id="tc-anno"></span>
    </div>

    <div class="tc-time" id="tc-time"></div>

    <div class="tc-feast">
      <h3>Next Feast</h3>
      <p class="tc-feast-name" id="tc-feast-name">&nbsp;</p>
      <p class="tc-feast-date" id="tc-feast-date"></p>
      <p class="tc-feast-countdown" id="tc-feast-countdown"></p>
      <p class="tc-feast-desc" id="tc-feast-desc"></p>
    </div>

    <p class="tc-motto tc-motto-end">Love is the law, love under will.</p>
  </div>
</div>

<p class="tc-nav">
  <a href="/">Home</a>
  <a href="/an-homage-to-no-reason/">About</a>
  <a href="/on-technoshamanism-and-magick/">Blog</a>
</p>

<details class="tc-about">
  <summary>On this reckoning</summary>
  <p>The date is given in the manner Aleister Crowley used to head his letters
  and diaries: the place of the Sun (&#9737;) and Moon (&#9789;) in the zodiac,
  the day of the week in Latin, and the year of the New &AElig;on.</p>
  <p>Years are counted from the Equinox of the Gods &mdash; the vernal equinox of
  1904, when the &AElig;on of Horus began &mdash; and written in
  <em>docosades</em>, cycles of twenty&#8209;two years. The first Roman numeral is
  the number of completed docosades; the second, the year within the current one.
  The Thelemic year turns each spring, when the Sun enters Aries.</p>
  <p>Sun and Moon positions are computed in your browser from your device clock,
  so they follow your local time. The heavens are calculated to within a degree;
  for ritual timing, consult an ephemeris.</p>
</details>

<style>
/* This page only: drop the divider under the (now globally centered) title,
   so it sits cleanly above the gold panel. */
.single-page .page-header{border-bottom:none;margin-bottom:1.1rem;}
.tc-panel{max-width:640px;margin:2rem auto;padding:2px;
  background:linear-gradient(135deg,#8a6508,#d4a017 40%,#b8860b 60%,#7a5807);
  border-radius:10px;box-shadow:0 10px 44px rgba(0,0,0,.55);}
.tc-inner{background:radial-gradient(circle at 50% -10%,#20201d,#111112 72%);
  border-radius:9px;padding:2.4rem 1.8rem 2rem;color:#e8e0cf;
  font-family:Georgia,"Times New Roman",serif;text-align:center;}
.tc-motto{font-style:italic;color:#b9ad8f;font-size:.98rem;margin:.2rem 0 1.5rem;}
.tc-motto-end{margin:1.7rem 0 0;}
.tc-header{font-size:1.18rem;line-height:2;color:#f0e9d6;margin:1rem 0 .3rem;}
.tc-header .glyph{color:#d4a017;font-size:1.35rem;vertical-align:-1px;}
.tc-header .deg{color:#d4a017;}
.tc-anno{display:block;font-size:1.4rem;color:#d4a017;letter-spacing:.06em;
  margin-top:.5rem;font-variant:small-caps;}
.tc-time{font-variant-numeric:tabular-nums;color:#c8c0aa;font-size:1rem;
  margin:.2rem 0 1.3rem;letter-spacing:.02em;}
.tc-feast{border-top:1px solid rgba(212,160,23,.35);
  border-bottom:1px solid rgba(212,160,23,.35);padding:1.15rem .5rem;margin:1.2rem 0 .4rem;}
.tc-feast h3{margin:0 0 .55rem;color:#b8860b;font-size:.82rem;letter-spacing:.2em;
  text-transform:uppercase;font-weight:400;}
.tc-feast-name{font-size:1.28rem;color:#f0e9d6;margin:.2rem 0;line-height:1.35;}
.tc-feast-date{color:#b9ad8f;margin:.25rem 0;}
.tc-feast-countdown{color:#d4a017;font-size:1.05rem;margin:.45rem 0;}
.tc-feast-desc{color:#a89f88;font-size:.92rem;font-style:italic;line-height:1.55;
  margin:.6rem auto 0;max-width:34em;}
.tc-nav{text-align:center;margin:1.5rem 0;}
.tc-nav a{color:#d4a017;margin:0 14px;text-decoration:none;}
.tc-nav a:hover{text-decoration:underline;}
.tc-about{max-width:620px;margin:1.2rem auto 2rem;color:#8a8272;font-size:.86rem;
  font-family:Georgia,serif;}
.tc-about summary{cursor:pointer;color:#b8860b;letter-spacing:.04em;}
.tc-about p{line-height:1.65;margin:.7rem 0;}
@media(max-width:480px){.tc-header{font-size:1.02rem}
  .tc-feast-name{font-size:1.12rem}}
</style>

<script>
(function () {
  var rad = Math.PI / 180;
  function norm360(x) { x = x % 360; return x < 0 ? x + 360 : x; }
  function toRoman(num) {
    if (num <= 0) return "0";
    var map = [[1000,"M"],[900,"CM"],[500,"D"],[400,"CD"],[100,"C"],[90,"XC"],
      [50,"L"],[40,"XL"],[10,"X"],[9,"IX"],[5,"V"],[4,"IV"],[1,"I"]], r = "";
    for (var i = 0; i < map.length; i++) { while (num >= map[i][0]) { r += map[i][1]; num -= map[i][0]; } }
    return r;
  }

  var signs = ["Aries","Taurus","Gemini","Cancer","Leo","Virgo","Libra",
    "Scorpio","Sagittarius","Capricornus","Aquarius","Pisces"];
  var glyphs = ["♈","♉","♊","♋","♌","♍","♎",
    "♏","♐","♑","♒","♓"];
  var dies = ["dies Solis","dies Lunae","dies Martis","dies Mercurii",
    "dies Jovis","dies Veneris","dies Saturni"];

  function zodiac(lon) {
    var i = (Math.floor(lon / 30) % 12 + 12) % 12, within = lon - i * 30;
    var d = Math.floor(within), m = Math.floor((within - d) * 60);
    return { sign: signs[i], glyph: glyphs[i], d: d, m: m };
  }

  // Feast days of Thelema (month is 1-12). Seasonal points on conventional dates.
  var feasts = [
    { mo:3,  dy:20, name:"The Equinox of the Gods",
      desc:"Thelemic New Year and the Feast of the Supreme Ritual — the invocation of Horus at the vernal equinox of 1904, when the Æon turned." },
    { mo:4,  dy:8,  name:"The Writing of the Book of the Law — First Day",
      desc:"The first of the three days on which Liber AL vel Legis was dictated to the Prophet in Cairo, 1904." },
    { mo:4,  dy:9,  name:"The Writing of the Book of the Law — Second Day",
      desc:"The second day of the writing of the Book of the Law." },
    { mo:4,  dy:10, name:"The Writing of the Book of the Law — Third Day",
      desc:"The third and final day of the writing of the Book of the Law." },
    { mo:6,  dy:21, name:"The Feast for the Summer Solstice",
      desc:"The Sun at its zenith — the height of power and the manifestation of Will." },
    { mo:8,  dy:12, name:"The First Night of the Prophet and His Bride",
      desc:"Commemorating the marriage of Aleister Crowley and Rose Edith Kelly, 1903, through whom the Aeon was announced." },
    { mo:9,  dy:22, name:"The Feast for the Autumnal Equinox",
      desc:"Balance of light and dark as the year descends toward the dark half." },
    { mo:10, dy:12, name:"The Birth of the Prophet",
      desc:"The nativity of Aleister Crowley, born 12 October 1875 at Leamington Spa." },
    { mo:12, dy:1,  name:"The Greater Feast of the Prophet",
      desc:"The Greater Feast for Death — the passing of Aleister Crowley, 1 December 1947." },
    { mo:12, dy:21, name:"The Feast for the Winter Solstice",
      desc:"The longest night, and the rekindling of the light." }
  ];

  function render() {
    var now = new Date();

    // Julian centuries from J2000.0 (UTC-based; adequate to <1 minute for display)
    var jd = now.getTime() / 86400000 + 2440587.5;
    var T = (jd - 2451545.0) / 36525.0;

    // Sun ecliptic longitude (Meeus, ~0.01 deg)
    var L0 = norm360(280.46646 + 36000.76983 * T + 0.0003032 * T * T);
    var M  = norm360(357.52911 + 35999.05029 * T - 0.0001537 * T * T);
    var Mr = M * rad;
    var C = (1.914602 - 0.004817 * T - 0.000014 * T * T) * Math.sin(Mr)
          + (0.019993 - 0.000101 * T) * Math.sin(2 * Mr)
          + 0.000289 * Math.sin(3 * Mr);
    var sunLon = norm360(L0 + C);

    // Moon ecliptic longitude (Meeus principal terms, ~0.3 deg)
    var Lp = norm360(218.3164477 + 481267.88123421 * T);
    var D  = norm360(297.8501921 + 445267.1114034 * T);
    var Mm = norm360(134.9633964 + 477198.8675055 * T);
    var F  = norm360(93.2720950  + 483202.0175233 * T);
    var moonLon = norm360(Lp
      + 6.288774 * Math.sin(Mm * rad)
      + 1.274027 * Math.sin((2 * D - Mm) * rad)
      + 0.658314 * Math.sin(2 * D * rad)
      + 0.213618 * Math.sin(2 * Mm * rad)
      - 0.185116 * Math.sin(M * rad)
      - 0.114332 * Math.sin(2 * F * rad)
      + 0.058793 * Math.sin((2 * D - 2 * Mm) * rad)
      + 0.057066 * Math.sin((2 * D - M - Mm) * rad)
      + 0.053322 * Math.sin((2 * D + Mm) * rad)
      + 0.045758 * Math.sin((2 * D - M) * rad));

    var sol = zodiac(sunLon), luna = zodiac(moonLon);
    document.getElementById("tc-sol").innerHTML =
      '<span class="glyph">☉</span> in <span class="deg">' + sol.d + "° " + sol.m + "′</span> " + sol.sign;
    document.getElementById("tc-luna").innerHTML =
      '<span class="glyph">☽</span> in <span class="deg">' + luna.d + "° " + luna.m + "′</span> " + luna.sign;
    document.getElementById("tc-dies").textContent = dies[now.getDay()];

    // Thelemic year: from the vernal equinox (~Mar 20). Before it, the prior year.
    var n = now.getFullYear() - 1904;
    if (now < new Date(now.getFullYear(), 2, 20)) n -= 1;
    var doc = Math.floor(n / 22), yr = n - doc * 22;
    document.getElementById("tc-anno").textContent =
      "Anno " + toRoman(doc) + ":" + toRoman(yr).toLowerCase();

    // Current time
    document.getElementById("tc-time").textContent =
      now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", second: "2-digit" });

    // Next feast
    var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    var best = null, bestDate = null;
    for (var i = 0; i < feasts.length; i++) {
      var f = feasts[i];
      var d = new Date(now.getFullYear(), f.mo - 1, f.dy);
      if (d < today) d = new Date(now.getFullYear() + 1, f.mo - 1, f.dy);
      if (bestDate === null || d < bestDate) { bestDate = d; best = f; }
    }
    var days = Math.round((bestDate - today) / 86400000);
    document.getElementById("tc-feast-name").textContent = best.name;
    document.getElementById("tc-feast-date").textContent =
      bestDate.toLocaleDateString([], { month: "long", day: "numeric" });
    document.getElementById("tc-feast-countdown").textContent =
      days === 0 ? "Today — Blessed Feast!" : (days === 1 ? "Tomorrow" : "In " + days + " days");
    document.getElementById("tc-feast-desc").textContent = best.desc;
  }

  render();
  setInterval(render, 1000);
})();
</script>
