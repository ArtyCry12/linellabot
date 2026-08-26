"""DEPRECATED shim — use cursor-sync-workspace-rules.py

Kept so old refresh/docs that still call this filename do not break.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

_CANON = Path(__file__).resolve().parent / "cursor-sync-workspace-rules.py"
print(
    "DEPRECATED: huashu-sync-workspace-rules.py → cursor-sync-workspace-rules.py",
    file=sys.stderr,
)
raise SystemExit(subprocess.call([sys.executable, str(_CANON), *sys.argv[1:]]))
