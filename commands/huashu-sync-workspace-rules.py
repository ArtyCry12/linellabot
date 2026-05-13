"""Sync all project rules (.mdc) from this repo into every Cursor-known workspace root."""
from __future__ import annotations

import json
import os
import shutil
from pathlib import Path
from urllib.parse import unquote, urlparse

RULES_DIR = Path(r"C:\Users\Asus\.cursor\rules")
_APPDATA = Path(os.environ.get("APPDATA", ""))
STORAGE = _APPDATA / "Cursor/User/globalStorage/storage.json"
WS_ROOT = _APPDATA / "Cursor/User/workspaceStorage"


def uri_to_path(uri: str) -> Path | None:
    if not uri.startswith("file://"):
        return None
    p = urlparse(uri)
    raw = unquote(p.path)
    if len(raw) >= 3 and raw[0] == "/" and raw[2] == ":":
        raw = raw[1:]
    return Path(raw)


def collect_uris() -> set[str]:
    out: set[str] = set()
    if STORAGE.is_file():
        data = json.loads(STORAGE.read_text(encoding="utf-8"))
        prof = (data.get("profileAssociations") or {}).get("workspaces") or {}
        out.update(k for k in prof if k.startswith("file://"))
        for ent in (data.get("backupWorkspaces") or {}).get("folders") or []:
            u = ent.get("folderUri")
            if u:
                out.add(u)
    if WS_ROOT.is_dir():
        for sub in WS_ROOT.iterdir():
            wj = sub / "workspace.json"
            if not wj.is_file():
                continue
            try:
                d = json.loads(wj.read_text(encoding="utf-8"))
                u = d.get("folder")
                if u:
                    out.add(u)
            except (json.JSONDecodeError, OSError):
                pass
    return out


def main() -> None:
    files = sorted(RULES_DIR.glob("*.mdc"))
    if not files:
        print("No .mdc files in", RULES_DIR)
        return
    done = 0
    skipped = 0
    copied = 0
    for uri in sorted(collect_uris()):
        base = uri_to_path(uri)
        if not base or not base.is_dir():
            skipped += 1
            continue
        dest_dir = base / ".cursor" / "rules"
        dest_dir.mkdir(parents=True, exist_ok=True)
        for src in files:
            shutil.copy2(src, dest_dir / src.name)
            copied += 1
        done += 1
    print(
        f"Copied {len(files)} rule file(s) to {done} workspace roots "
        f"({copied} total copies; {skipped} roots missing/skipped)"
    )


if __name__ == "__main__":
    main()
