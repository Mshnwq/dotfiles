#!/usr/bin/env python3
"""Generate claude-desktop-bin.jsonc from the current pywal palette.

The claude-desktop package used here is the patrickjaja build, which themes via
a config file at ~/.config/Claude/claude-desktop-bin.jsonc: an `activeTheme`
name plus a `themes` map whose entries hold `light`/`dark` blocks of Claude's
internal CSS variables (bare "H S% L%" HSL triplets, e.g. --bg-000, --text-000,
--accent-brand). This reads ~/.cache/wal/colors.json and emits a "pywal" theme.

pywal is a single palette (no separate light/dark), so the same derived values
fill both blocks: whichever mode Claude is in, it shows the pywal colors.

Any other top-level keys already in the file (e.g. growthbookOverrides) are
preserved when the existing file is valid JSON; a file that fails to parse
(hand-written JSONC with comments) is regenerated from scratch.

Usage: gen-theme.py <colors.json> <output.jsonc>
"""

import json
import sys


def hex_to_hsl(hex_color):
    """"#rrggbb" -> "h s% l%" (Claude stores colors as bare HSL triplets)."""
    h = hex_color.lstrip("#")
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
    mx, mn = max(r, g, b), min(r, g, b)
    d = mx - mn
    lum = (mx + mn) / 2
    if d == 0:
        hue = sat = 0.0
    else:
        sat = d / (1 - abs(2 * lum - 1))
        if mx == r:
            hue = ((g - b) / d) % 6
        elif mx == g:
            hue = (b - r) / d + 2
        else:
            hue = (r - g) / d + 4
        hue *= 60
        if hue < 0:
            hue += 360
    return f"{round(hue, 1)} {round(sat * 100, 1)}% {round(lum * 100, 1)}%"


def mix(a, b, t):
    """Linear blend of two "#rrggbb" colors, t in [0, 1] (0 = a, 1 = b)."""
    a, b = a.lstrip("#"), b.lstrip("#")
    out = "#"
    for i in (0, 2, 4):
        av, bv = int(a[i:i + 2], 16), int(b[i:i + 2], 16)
        out += f"{round(av + (bv - av) * t):02x}"
    return out


def contrast(hex_color):
    """Bare HSL for black or white, whichever reads better on hex_color."""
    h = hex_color.lstrip("#")
    r, g, b = (int(h[i:i + 2], 16) for i in (0, 2, 4))
    luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return "0 0% 100%" if luma < 140 else "0 0% 0%"


def build_vars(palette):
    bg = palette["special"]["background"]
    fg = palette["special"]["foreground"]
    c = palette["colors"]
    brand = c.get("color4") or c["color1"]   # primary accent (usually blue)
    pro = c.get("color5") or c["color2"]      # secondary accent (magenta)
    danger = c.get("color1", "#e06c75")
    warning = c.get("color3", "#e5c07b")
    success = c.get("color2", "#98c379")
    t = hex_to_hsl

    def family(base):
        # 000 lighter/muted -> 200 saturated base -> 900 deep, for a token set.
        return {
            "000": t(mix(base, bg, 0.55)),
            "100": t(mix(base, bg, 0.3)),
            "200": t(base),
            "900": t(mix(base, fg, 0.2)),
        }

    accent = family(brand)
    accent_pro = family(pro)
    brand_fam = family(brand)
    danger_fam = family(danger)
    warning_fam = family(warning)
    success_fam = family(success)

    return {
        # Background ramp: bg -> fg.
        "--bg-000": t(bg),
        "--bg-100": t(mix(bg, fg, 0.04)),
        "--bg-200": t(mix(bg, fg, 0.08)),
        "--bg-300": t(mix(bg, fg, 0.14)),
        "--bg-400": t(mix(bg, fg, 0.22)),
        "--bg-500": t(mix(bg, fg, 0.32)),
        # Text ramp: fg -> bg.
        "--text-000": t(fg),
        "--text-100": t(mix(fg, bg, 0.1)),
        "--text-200": t(mix(fg, bg, 0.25)),
        "--text-300": t(mix(fg, bg, 0.4)),
        "--text-400": t(mix(fg, bg, 0.55)),
        "--text-500": t(mix(fg, bg, 0.7)),
        # Borders.
        "--border-100": t(mix(bg, fg, 0.12)),
        "--border-200": t(mix(bg, fg, 0.2)),
        "--border-300": t(mix(bg, fg, 0.3)),
        "--border-400": t(mix(bg, fg, 0.4)),
        # Accent / brand families.
        "--accent-brand": t(brand),
        "--accent-000": accent["000"],
        "--accent-100": accent["100"],
        "--accent-200": accent["200"],
        "--accent-900": accent["900"],
        "--accent-pro-000": accent_pro["000"],
        "--accent-pro-100": accent_pro["100"],
        "--accent-pro-200": accent_pro["200"],
        "--accent-pro-900": accent_pro["900"],
        "--brand-000": brand_fam["000"],
        "--brand-100": brand_fam["100"],
        "--brand-200": brand_fam["200"],
        "--brand-900": brand_fam["900"],
        # Status colors.
        "--danger-000": danger_fam["000"],
        "--danger-100": danger_fam["100"],
        "--danger-200": danger_fam["200"],
        "--danger-900": danger_fam["900"],
        "--warning-000": warning_fam["000"],
        "--warning-100": warning_fam["100"],
        "--warning-200": warning_fam["200"],
        "--warning-900": warning_fam["900"],
        "--success-000": success_fam["000"],
        "--success-100": success_fam["100"],
        "--success-200": success_fam["200"],
        "--success-900": success_fam["900"],
        # Foreground drawn on top of accent fills.
        "--oncolor-100": contrast(brand),
        "--oncolor-200": contrast(brand),
        "--oncolor-300": contrast(brand),
        # Pictograms / icons.
        "--pictogram-100": t(fg),
        "--pictogram-200": t(mix(fg, bg, 0.25)),
        "--pictogram-300": t(mix(fg, bg, 0.55)),
        "--pictogram-400": t(mix(bg, fg, 0.32)),
    }


def main():
    if len(sys.argv) != 3:
        sys.exit("usage: gen-theme.py <colors.json> <output.jsonc>")
    colors_path, out_path = sys.argv[1], sys.argv[2]

    with open(colors_path, encoding="utf-8") as f:
        palette = json.load(f)

    variables = build_vars(palette)
    theme = {"light": variables, "dark": variables}

    # Preserve an existing valid-JSON config (keeps e.g. growthbookOverrides).
    config = {}
    try:
        with open(out_path, encoding="utf-8") as f:
            existing = json.load(f)
        if isinstance(existing, dict):
            config = existing
    except (FileNotFoundError, json.JSONDecodeError):
        config = {}

    config["_generated"] = "home-manager pywal — theme 'pywal' regenerated on switch"
    config["activeTheme"] = "pywal"
    config.setdefault("themes", {})["pywal"] = theme

    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    main()
