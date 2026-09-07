"""Send raw UTF-8 JSON to the real UserPromptSubmit hook."""
from __future__ import annotations

import json
import random
import subprocess
import sys
from pathlib import Path

HUB = Path(__file__).resolve().parents[1]
HOOK = HUB / "hooks" / "task-router.ps1"


def main() -> int:
    prompt = f"Продумай структуру системы и связи между частями probe-{random.random()}"
    payload = json.dumps({"prompt": prompt}, ensure_ascii=False)
    process = subprocess.run(
        [
            "powershell",
            "-NoProfile",
            "-ExecutionPolicy",
            "Bypass",
            "-File",
            str(HOOK),
        ],
        input=payload,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="strict",
        cwd=HUB,
        check=False,
    )
    if process.returncode != 0 or not process.stdout.strip():
        print("FAIL: UTF-8 hook returned no context", file=sys.stderr)
        return 1
    output = json.loads(process.stdout)
    context = output["hookSpecificOutput"]["additionalContext"]
    if "P:architecture-plan" not in context or "stage=systemic" not in context:
        print(f"FAIL: unexpected UTF-8 hook context: {context}", file=sys.stderr)
        return 1
    print("task-router raw UTF-8 hook: ok")
    return 0


if __name__ == "__main__":
    sys.exit(main())
