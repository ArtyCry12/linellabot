"""Sync hub rules (*.mdc) into every Cursor-known workspace root.

Canon name (2026-08-26). Legacy entrypoint: huashu-sync-workspace-rules.py (shim).
"""
from __future__ import annotations

import json
import os
import shutil
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse

# Hub root = parent of commands/; never hardcode another Windows user.
HUB_ROOT = Path(__file__).resolve().parent.parent
RULES_DIR = HUB_ROOT / "rules"
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


def refresh_block_rule_mirrors() -> int:
    """Keep hub rules/ mirrors of blocks/*/rules/*.mdc fresh for sync."""
    blocks = HUB_ROOT / "blocks"
    if not blocks.is_dir():
        return 0
    n = 0
    for mdc in blocks.glob("*/rules/*.mdc"):
        # Only top-level block rules (not agency personas under rules/agency/)
        if mdc.parent.name != "rules":
            continue
        shutil.copy2(mdc, RULES_DIR / mdc.name)
        n += 1
    return n


def main() -> int:
    if not RULES_DIR.is_dir():
        print("No rules dir:", RULES_DIR, file=sys.stderr)
        return 1
    mirrored = refresh_block_rule_mirrors()
    files = sorted(RULES_DIR.glob("*.mdc"))
    if not files:
        print("No .mdc files in", RULES_DIR)
        return 1
    done = 0
    skipped = 0
    copied = 0
    for uri in sorted(collect_uris()):
        base = uri_to_path(uri)
        if not base or not base.is_dir():
            skipped += 1
            continue
        # Do not flatten hub always-on stubs under .cursor/rules/ by copying canon onto itself.
        if base.resolve() == HUB_ROOT.resolve():
            skipped += 1
            continue
        dest_dir = base / ".cursor" / "rules"
        dest_dir.mkdir(parents=True, exist_ok=True)
        for src in files:
            shutil.copy2(src, dest_dir / src.name)
            copied += 1
        done += 1
    print(
        f"Mirrored {mirrored} block rules -> {RULES_DIR}; "
        f"copied {len(files)} rule file(s) to {done} workspace roots "
        f"({copied} total copies; {skipped} roots missing/skipped)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
