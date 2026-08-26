#!/usr/bin/env python3
"""Turn a gtt translation into an Obsidian word note, then an Anki card.

Called by .gtt.sh --obsidian. Deliberately mirrors what
_templates/templater/new-word.md produces, so a word captured from gtt and a
word captured from inside Obsidian are indistinguishable afterwards:

  - filed under the English meaning, term kept in name/aliases
  - audio lives in the vault; AnkiConnect copies it into Anki's media folder
  - deck / note type / field mapping all come from the language note
  - today's daily note gets its per-language counters bumped

If Anki is unreachable the note is still written and flagged
anki_synced: false, which the anki-push template picks up later.
"""
import argparse
import datetime as dt
import json
import os
import pathlib
import re
import html
import shutil
import subprocess
import sys
import urllib.parse
import urllib.error
import urllib.request

import yaml

ANKI_URL = os.environ.get("GTT_ANKI_URL", "http://127.0.0.1:8765")
# Same endpoint gtt's Google engine uses. gtt itself gets 429'd there because
# Google fingerprints Go's HTTP client, but plain urllib is served normally --
# so we can still enrich the note with part of speech even while gtt runs on
# Bing. Purely best-effort: any failure just means no POS section.
POS_URL = ("https://translate.googleapis.com/translate_a/single"
           "?client=gtx&dt=t&dt=bd&dt=md&dt=ex&sl=%s&tl=%s&q=%s")
MAX_EQUIVALENTS = 8
FM_RE = re.compile(r"\A---\n(.*?)\n---\n", re.S)
# What Obsidian refuses in a filename; the script itself stays intact.
UNSAFE = re.compile(r'[\\/:*?"<>|#^\[\]]')


def die(msg, code=1):
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(code)


def frontmatter(path):
    m = FM_RE.match(path.read_text(encoding="utf8"))
    if not m:
        return {}
    try:
        return yaml.safe_load(m.group(1)) or {}
    except yaml.YAMLError:
        return {}


def slug(s):
    return re.sub(r"^_|_$", "", re.sub(r"[^a-z0-9]+", "_", str(s).lower()))


def safe_name(s):
    return UNSAFE.sub("", s).strip()


def anki(action, **params):
    payload = json.dumps({"action": action, "version": 6, "params": params}).encode()
    req = urllib.request.Request(
        ANKI_URL, payload, {"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=15) as fh:
        data = json.load(fh)
    if data.get("error"):
        raise RuntimeError(data["error"])
    return data["result"]


# --- mirror filenames -------------------------------------------------------
# anki_obsidian_sync names each exported note "<first field>_<note id>.md".
# Replicating that here lets the vault note link straight to the mirror.
_INVALID_FILENAME = r'[<>:"/\\|?*\x00-\x1f]|(?<!^)\.$|\s$'


def _sanitize_filename(name):
    s = re.sub(_INVALID_FILENAME, "_", name or "Untitled Anki Note")
    s = re.sub(r"_+", "_", s).strip("_")
    if len(s) > 100:
        s = s[:100].strip().rstrip("_")
    return s or "anki_note"


def mirror_basename(note_id):
    """Ask Anki what the note's title field holds, then mirror the addon's
    filename rules. Returns "" if anything is unavailable."""
    if not note_id:
        return ""
    try:
        info = anki("notesInfo", notes=[int(note_id)])
    except Exception:
        return ""
    if not info or not info[0]:
        return ""
    note = info[0]
    fields = note.get("fields") or {}
    ordered = sorted(fields.items(), key=lambda kv: kv[1].get("order", 0))
    if not ordered:
        return ""

    # The addon special-cases Basic-like note types to the Front field and
    # otherwise takes the first non-empty field.
    base = ""
    if "basic" in str(note.get("modelName", "")).lower() and "Front" in fields:
        base = fields["Front"].get("value", "")
    if not base.strip():
        base = next((v.get("value", "") for _, v in ordered
                     if v.get("value", "").strip()), "")

    base = re.sub(r"\[sound:[^\]]*\]", " ", base, flags=re.IGNORECASE)
    base = re.sub(r"\[anki:play:[^\]]*\]", " ", base, flags=re.IGNORECASE)
    base = html.unescape(re.sub(r"<[^>]+>", " ", base).strip())
    if len(base) > 70:
        base = base[:70] + "..."
    base = re.sub(r"\s+", " ", base).strip()
    return f"{_sanitize_filename(base)}_{note_id}"


def lookup_pos(src_code, dst_code, text):
    """Return (labels, markdown_lines) describing the source word's parts of
    speech, mirroring what gtt shows in its "Part of speech" pane."""
    if not (src_code and dst_code and text):
        return [], []
    # Fetched with curl rather than urllib on purpose. Google fingerprints
    # HTTP clients on this endpoint -- it already 429s Go (which is why gtt
    # runs on Bing) and has started 429ing urllib too, while curl is still
    # served. Best-effort either way.
    url = POS_URL % (src_code, dst_code, urllib.parse.quote(text))
    try:
        proc = subprocess.run(
            ["curl", "-sS", "--fail", "-m", "12", url],
            capture_output=True, timeout=15)
        if proc.returncode != 0:
            raise RuntimeError(
                proc.stderr.decode("utf8", "replace").strip() or
                f"curl exit {proc.returncode}")
        data = json.loads(proc.stdout)
    except Exception as exc:
        print(f"warning: part-of-speech lookup failed: {exc}", file=sys.stderr)
        return [], []

    labels, lines = [], []
    if len(data) > 1 and data[1]:
        for group in data[1]:
            try:
                label = str(group[0])
                equivalents = group[2] or []
            except (IndexError, TypeError):
                continue
            labels.append(label)
            lines.append(f"**{label}**")
            lines.append("")
            for words in equivalents[:MAX_EQUIVALENTS]:
                dst_word = words[0]
                backs = ", ".join(str(w) for w in (words[1] or []))
                lines.append(f"- {dst_word}" + (f" — {backs}" if backs else ""))
            extra = len(equivalents) - MAX_EQUIVALENTS
            if extra > 0:
                lines.append(f"- *… and {extra} more*")
            lines.append("")
    return labels, lines


def find_language(vault, wanted):
    """Locate the language note by `name`, alias, or filename."""
    for path in (vault / "4_Projects/Personal/Languages").glob("*.md"):
        fm = frontmatter(path)
        tags = fm.get("tags") or []
        if isinstance(tags, str):
            tags = [tags]
        if "language" not in tags:
            continue
        names = {str(fm.get("name", "")), path.stem, *(fm.get("aliases") or [])}
        if wanted in names:
            return path, fm
    return None, None


def bump_daily(vault, keys):
    """Increment counters in today's daily note by editing text, not by
    round-tripping the YAML -- that would reformat the user's own quoting."""
    stamp = dt.date.today().strftime("%Y-%m-%d-%a")
    path = vault / "1_Notes/Daily" / f"{stamp}.md"
    if not path.exists():
        return None
    text = path.read_text(encoding="utf8")
    m = FM_RE.match(text)
    if not m:
        return None
    block = m.group(1)
    for key in keys:
        krx = re.compile(rf"^{re.escape(key)}:\s*(\d+)\s*$", re.M)
        hit = krx.search(block)
        if hit:
            block = krx.sub(f"{key}: {int(hit.group(1)) + 1}", block, count=1)
        else:
            block = block.rstrip("\n") + f"\n{key}: 1"
    path.write_text(text[: m.start(1)] + block + text[m.end(1) :], encoding="utf8")
    return path.name


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--vault", required=True)
    ap.add_argument("--language", required=True, help="e.g. Romanian")
    ap.add_argument("--term", required=True, help="the foreign word")
    ap.add_argument("--translation", required=True, help="the English meaning")
    ap.add_argument("--audio", default="", help="path to a recorded clip")
    ap.add_argument("--src-code", default="", help="e.g. en")
    ap.add_argument("--dst-code", default="", help="e.g. ro")
    ap.add_argument("--source", default="gtt")
    args = ap.parse_args()

    vault = pathlib.Path(args.vault).expanduser()
    if not vault.is_dir():
        die(f"vault not found: {vault}")

    term = args.term.strip()
    translation = args.translation.strip()
    if not term:
        die("empty term")

    lang_path, lang_fm = find_language(vault, args.language)
    if lang_path is None:
        die(
            f"no language note named {args.language!r} in "
            f"{vault}/4_Projects/Personal/Languages -- run the new-language template first"
        )

    # Part of speech describes the word you looked up, i.e. the English side,
    # exactly as gtt's pane does.
    pos_labels, pos_lines = lookup_pos(args.src_code, args.dst_code,
                                       translation or term)
    pos_value = ", ".join(pos_labels)
    pos_section = ("\n".join(pos_lines).strip() or
                   "<!-- no part-of-speech data returned -->")

    lang_name = lang_fm.get("name") or lang_path.stem
    lang_id = slug(lang_fm.get("id") or lang_path.stem)

    # --- audio into the vault, which stays the source of truth --------------
    audio_link = ""
    audio_vault_path = None
    if args.audio:
        src = pathlib.Path(args.audio)
        if not src.is_file() or src.stat().st_size == 0:
            print(f"warning: no usable audio at {src}", file=sys.stderr)
        else:
            dest_dir = vault / "_attachments/Anki"
            dest_dir.mkdir(parents=True, exist_ok=True)
            audio_vault_path = dest_dir / f"{safe_name(term) or 'clip'}.mp3"
            shutil.copyfile(src, audio_vault_path)
            audio_link = f"[[{audio_vault_path.name}]]"

    # --- push to Anki using the language note's mapping ---------------------
    deck = lang_fm.get("anki_deck") or f"{lang_name} Obsidian"
    model = lang_fm.get("anki_model") or "Basic"
    f_term = lang_fm.get("anki_field_term") or "Front"
    f_tran = lang_fm.get("anki_field_translation") or "Back"
    f_read = lang_fm.get("anki_field_reading") or ""
    f_note = lang_fm.get("anki_field_notes") or ""
    f_audio = lang_fm.get("anki_field_audio") or ""

    fields = {f_term: term, f_tran: translation}
    if f_read:
        fields[f_read] = ""
    if f_note:
        fields[f_note] = ""

    note = {
        "deckName": deck,
        "modelName": model,
        "fields": fields,
        "tags": ["obsidian", "gtt", lang_id],
        "options": {"allowDuplicate": False, "duplicateScope": "deck"},
    }
    if audio_vault_path:
        note["audio"] = [
            {
                "path": str(audio_vault_path.resolve()),
                "filename": audio_vault_path.name,
                "fields": [f_audio or f_term],
            }
        ]

    note_id, synced, err = "", False, ""
    try:
        anki("createDeck", deck=deck)
        note_id = anki("addNote", note=note)
        synced = True
    except (urllib.error.URLError, RuntimeError, OSError) as exc:
        err = str(getattr(exc, "reason", exc))

    mirror = mirror_basename(note_id) if synced else ""
    mirror_line = f"- [[{mirror}]]" if mirror else "-"

    # --- write the note, filed under the meaning ----------------------------
    folder = vault / "1_Notes/Vocabulary" / lang_name
    folder.mkdir(parents=True, exist_ok=True)
    base = safe_name(translation or term) or "untitled"
    target = folder / f"{base}.md"
    n = 1
    while target.exists():
        n += 1
        target = folder / f"{base}-{n}.md"

    now = dt.datetime.now()
    day = now.strftime("%Y-%m-%d-%a")
    stamp = f"{day} {now.strftime('%I:%M %p').lower()}"
    link = f"[[{lang_path.stem}|{lang_name}]]"
    esc = lambda s: str(s).replace('"', "'")

    audio_block = f"\n!{audio_link}\n" if audio_link else ""

    banner = (
        f"> [!NOTE] In Anki\n"
        f"> Deck **{deck}**, note type **{model}**"
        f"{', audio attached' if audio_vault_path else ''}. "
        f"Find it with `nid:{note_id}` in the Anki browser."
        if synced
        else f"> [!WARNING] Not in Anki yet\n"
        f"> {err or 'Anki was unreachable.'} "
        f"Run the `anki-push` template to retry."
    )

    target.write_text(
        f"""---
created_on: "[[{day}|{stamp}]]"
updated_on: "{stamp}"
tags:
  - vocab
related:
  - "{link}"
id: "{target.stem.lower().replace(' ', '-')}"
name: {term}
aliases:
  - {term}
language:
  - "{link}"
term: "{esc(term)}"
reading: ""
translation: "{esc(translation)}"
pos: "{esc(pos_value)}"
audio: "{audio_link}"
level: ""
register: ""
learned_on: {now.strftime('%Y-%m-%d')}
anki_synced: {'true' if synced else 'false'}
anki_note_id: {note_id if note_id else '""'}
anki_error: "{esc(err)}"
source: "{esc(args.source)}"
description: ""
---

# {term}

**{term}** — {translation}
{audio_block}
{banner}

## Part of Speech

{pos_section}

## Usage

<!-- Anki drills recall. This is for what a card cannot hold: the trap, the -->
<!-- register, the false friend, why the obvious translation is wrong. -->

-

## Examples

-

## Notes

{mirror_line}
""",
        encoding="utf8",
    )

    daily = bump_daily(vault, [f"lang_{lang_id}_words", "lang_words"])

    print(f"note   : {target.relative_to(vault)}")
    if audio_vault_path:
        print(f"audio  : {audio_vault_path.relative_to(vault)}")
    print(f"pos    : {pos_value or '(none)'}")
    print(f"mirror : {mirror or '(none)'}")
    print(f"anki   : {'nid ' + str(note_id) if synced else 'FAILED - ' + err}")
    print(f"daily  : {daily or 'not found (skipped)'}")
    # Non-zero only if Anki failed; the note itself is always written.
    sys.exit(0 if synced else 3)


if __name__ == "__main__":
    main()
