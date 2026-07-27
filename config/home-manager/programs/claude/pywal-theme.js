// programs/claude/pywal-theme.js
//
// Injected into claude-desktop's Electron main process (`.vite/build/index.pre.js`)
// by the overrideAttrs in ./default.nix. It reads the current pywal palette from
// ~/.cache/wal/colors.json and maps it onto Claude's internal CSS variables
// (bare "H S% L%" HSL triplets, e.g. --bg-000, --text-000, --accent-brand),
// injecting the result into every WebContents via webContents.insertCSS().
//
// It re-reads and re-applies live when pywal rewrites colors.json (fs.watch),
// so a `wal` run re-themes open windows without restarting the app. Everything
// is wrapped in try/catch: theming must never be able to break Claude.
(function () {
  try {
    var electron = require("electron");
    var app = electron.app;
    var fs = require("fs");
    var os = require("os");
    var path = require("path");

    var walJson = path.join(
      process.env.XDG_CACHE_HOME || path.join(os.homedir(), ".cache"),
      "wal",
      "colors.json"
    );

    // "#rrggbb" -> "h s% l%" (Claude stores colors as bare HSL triplets).
    function hexToHslTriplet(hex) {
      var m = /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(String(hex).trim());
      if (!m) return null;
      var r = parseInt(m[1], 16) / 255;
      var g = parseInt(m[2], 16) / 255;
      var b = parseInt(m[3], 16) / 255;
      var max = Math.max(r, g, b);
      var min = Math.min(r, g, b);
      var d = max - min;
      var h = 0;
      var s = 0;
      var l = (max + min) / 2;
      if (d !== 0) {
        s = d / (1 - Math.abs(2 * l - 1));
        if (max === r) h = ((g - b) / d) % 6;
        else if (max === g) h = (b - r) / d + 2;
        else h = (r - g) / d + 4;
        h *= 60;
        if (h < 0) h += 360;
      }
      var round = function (n) { return Math.round(n * 10) / 10; };
      return round(h) + " " + round(s * 100) + "% " + round(l * 100) + "%";
    }

    // Linear blend of two "#rrggbb" colors, t in [0,1] (0 = a, 1 = b).
    function mix(a, b, t) {
      var pa = String(a).replace("#", "");
      var pb = String(b).replace("#", "");
      var out = "#";
      for (var i = 0; i < 6; i += 2) {
        var av = parseInt(pa.substr(i, 2), 16);
        var bv = parseInt(pb.substr(i, 2), 16);
        var cv = Math.round(av + (bv - av) * t);
        out += ("0" + cv.toString(16)).slice(-2);
      }
      return out;
    }

    function buildCss() {
      var raw = JSON.parse(fs.readFileSync(walJson, "utf8"));
      var bg = raw.special.background;
      var fg = raw.special.foreground;
      var c = raw.colors;
      var accent = c.color4 || c.color1;
      var accent2 = c.color5 || c.color2;
      var t = hexToHslTriplet;

      // Background ramp goes bg -> fg; text ramp goes fg -> bg. Accent/brand
      // families are tinted toward bg (lighter/muted) and fg (deeper).
      var vars = {
        "--bg-000": t(bg),
        "--bg-100": t(mix(bg, fg, 0.04)),
        "--bg-200": t(mix(bg, fg, 0.08)),
        "--bg-300": t(mix(bg, fg, 0.14)),
        "--bg-400": t(mix(bg, fg, 0.22)),
        "--bg-500": t(mix(bg, fg, 0.32)),

        "--text-000": t(fg),
        "--text-100": t(mix(fg, bg, 0.1)),
        "--text-200": t(mix(fg, bg, 0.25)),
        "--text-300": t(mix(fg, bg, 0.4)),
        "--text-400": t(mix(fg, bg, 0.55)),
        "--text-500": t(mix(fg, bg, 0.7)),

        "--border-100": t(mix(bg, fg, 0.12)),
        "--border-200": t(mix(bg, fg, 0.2)),
        "--border-300": t(mix(bg, fg, 0.3)),
        "--border-400": t(mix(bg, fg, 0.4)),

        "--accent-brand": t(accent),
        "--accent-000": t(mix(accent, bg, 0.6)),
        "--accent-100": t(mix(accent, bg, 0.35)),
        "--accent-200": t(accent),
        "--accent-900": t(mix(accent, fg, 0.2)),

        "--accent-pro-000": t(mix(accent2, bg, 0.6)),
        "--accent-pro-100": t(mix(accent2, bg, 0.35)),
        "--accent-pro-200": t(accent2),
        "--accent-pro-900": t(mix(accent2, fg, 0.2)),

        "--brand-000": t(mix(accent, bg, 0.6)),
        "--brand-100": t(mix(accent, bg, 0.35)),
        "--brand-200": t(accent),
        "--brand-900": t(mix(accent, fg, 0.2))
      };

      var decls = "";
      Object.keys(vars).forEach(function (k) {
        if (vars[k]) decls += k + ":" + vars[k] + " !important;";
      });

      // pywal is a single palette, so apply it to every mode scope: whichever
      // mode Claude is in, our variables win.
      return ":root,[data-mode=light],[data-mode=dark],.dark,.darkTheme{" + decls + "}";
    }

    var css = "";
    function rebuild() {
      try {
        css = buildCss();
        return true;
      } catch (e) {
        return false; // keep last good css
      }
    }
    rebuild();

    // Track live WebContents and the CSS key we inserted into each, so a pywal
    // change can swap the stylesheet rather than stacking duplicates.
    var live = new Set();

    function applyTo(wc) {
      if (!css || wc.isDestroyed()) return;
      var prev = wc.__pywalCssKey;
      var doInsert = function () {
        wc.insertCSS(css)
          .then(function (key) { wc.__pywalCssKey = key; })
          .catch(function () {});
      };
      if (prev) {
        wc.removeInsertedCSS(prev)
          .then(function () { wc.__pywalCssKey = null; doInsert(); })
          .catch(doInsert);
      } else {
        doInsert();
      }
    }

    app.on("web-contents-created", function (_e, wc) {
      live.add(wc);
      wc.on("destroyed", function () { live.delete(wc); });
      wc.on("dom-ready", function () { applyTo(wc); });
    });

    try {
      fs.watch(walJson, { persistent: false }, function () {
        // Debounce: editors/pywal rewrite the file in bursts.
        clearTimeout(app.__pywalTimer);
        app.__pywalTimer = setTimeout(function () {
          if (rebuild()) live.forEach(applyTo);
        }, 120);
      });
    } catch (e) {}
  } catch (e) {
    // Theming failed to initialise; leave the app untouched.
  }
})();
