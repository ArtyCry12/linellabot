"""Idempotent: write Huashu Design rule into every known Cursor workspace folder."""
from __future__ import annotations

import json
import os
from pathlib import Path
from urllib.parse import unquote, urlparse

SOURCE = Path(r"C:\Users\Asus\.cursor\rules\huashu-design.mdc")
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
    text = SOURCE.read_text(encoding="utf-8")
    done = 0
    skipped = 0
    for uri in sorted(collect_uris()):
        base = uri_to_path(uri)
        if not base or not base.is_dir():
            skipped += 1
            continue
        dest_dir = base / ".cursor" / "rules"
        dest_dir.mkdir(parents=True, exist_ok=True)
        dest = dest_dir / "huashu-design.mdc"
        dest.write_text(text, encoding="utf-8")
        done += 1
    print(f"huashu-design.mdc written to {done} workspace roots ({skipped} missing/skipped)")


if __name__ == "__main__":
    main()
