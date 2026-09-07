"""UTF-8 route probes — calls PowerShell Resolve-TaskRoute (single scorer). Exit 1 on miss."""
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

HUB = Path(__file__).resolve().parents[1]
RESOLVER = HUB / "lib" / "task-router" / "Resolve-TaskRoute.ps1"

EXPECT = {
    "сделай лендинг с нуля": {"from-scratch"},
    "согласовать план большой задачи": {"clarify-first"},
    "сделай новый проект с нуля": {"from-scratch"},
    "напиши глоссарий CONTEXT.md для клиента": {"project-context"},
    "grill me before we start": {"clarify-first"},
}


def top_ids(prompt: str) -> list[str]:
    ps = f"""
$ErrorActionPreference='Stop'
. '{RESOLVER.as_posix()}'
$r = Resolve-TaskRoute -Prompt @'
{prompt}
'@ -HubRoot '{HUB.as_posix()}' -Source 'utf8' -SkipCache -NoLog
@($r.Matches | ForEach-Object {{ $_.Id }}) | ConvertTo-Json -Compress
"""
    raw = subprocess.check_output(
        ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", ps],
        text=True,
        encoding="utf-8",
        errors="replace",
    ).strip()
    if not raw or raw == "null":
        return []
    data = json.loads(raw)
    if isinstance(data, str):
        return [data]
    if isinstance(data, list):
        return [str(x) for x in data]
    return []


def main() -> int:
    fail = 0
    print("=== UTF-8 route probes ===")
    for prompt, need in EXPECT.items():
        got = set(top_ids(prompt))
        ok = need.issubset(got) if len(need) > 1 else bool(need & got)
        status = "ok" if ok else "FAIL"
        if not ok:
            fail += 1
        print(f"{status}: {prompt} -> {', '.join(sorted(got)) or '(none)'} expected {sorted(need)}")
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main())
