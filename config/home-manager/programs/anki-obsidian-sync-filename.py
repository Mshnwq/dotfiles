#!/usr/bin/env python3
"""Patch anki_obsidian_sync so [sound:...] refs stay out of note filenames.

determine_note_filename() strips HTML tags with re.sub('<[^>]+>', ...), but
Anki's media references are not HTML -- they look like [sound:foo.mp3]. A note
whose first field carries audio therefore ends up mirrored as

    Ajutor[sound_ajutor-39c2e4...mp3]_1787537668335.md

instead of Ajutor_1787537668335.md, which makes the file unlinkable by hand.

Idempotent: run it as often as you like.
"""
import pathlib
import sys

ANCHOR = "    cleaned_text = re.sub('<[^>]+>', ' ', filename_base).strip()"

INSERT = """    # Anki media refs are not HTML tags, so the strip below misses them and
    # [sound:x.mp3] / [anki:play:...] leak into the filename.
    filename_base = re.sub(r'\\[sound:[^\\]]*\\]', ' ', filename_base,
                           flags=re.IGNORECASE)
    filename_base = re.sub(r'\\[anki:play:[^\\]]*\\]', ' ', filename_base,
                           flags=re.IGNORECASE)
"""


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: anki-obsidian-sync-filename.py <state_builder.py>")
    path = pathlib.Path(sys.argv[1])
    if not path.is_file():
        sys.exit(f"not found: {path}")

    src = path.read_text(encoding="utf8")
    if "[sound:" in src.split("def determine_note_filename", 1)[-1][:1500]:
        print("already patched")
        return
    if ANCHOR not in src:
        sys.exit("anchor line not found -- addon changed upstream, patch me")

    path.write_text(src.replace(ANCHOR, INSERT + ANCHOR, 1), encoding="utf8")
    print(f"patched {path}")


if __name__ == "__main__":
    main()
