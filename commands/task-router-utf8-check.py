"""UTF-8 route probes. Called from task-router-test.ps1. Exit 1 on miss."""
from __future__ import annotations

import json
import sys
from pathlib import Path

HUB = Path(__file__).resolve().parents[1]
cfg = json.loads((HUB / "lib/task-router/routes.json").read_text(encoding="utf-8"))
min_s = int(cfg["minScore"])
skip = int(cfg["skipIfShorterThan"])

EXPECT = {
    "сделай лендинг с нуля": {"clarify-first", "from-scratch"},
    "согласовать план большой задачи": {"clarify-first"},
    "сделай новый проект с нуля": {"from-scratch"},
    "напиши глоссарий CONTEXT.md для клиента": {"project-context"},
    "grill me before we start": {"clarify-first"},
}


def score_prompt(prompt: str) -> list[str]:
    low = prompt.lower()
    if len(prompt) < skip:
        return []
    ranked: list[tuple[int, str]] = []
    for r in cfg["routes"]:
        if r.get("id") == "autopilot":
            continue
        score = 0
        for tag in r.get("tags") or []:
            if str(tag).lower() in low:
                score += 15
        for ph in r.get("phrases") or []:
            if str(ph).lower() in low:
                score += 10
        for kw in r.get("keywords") or []:
            if str(kw).lower() in low:
                score += 3
        if score >= min_s:
            ranked.append((score, r["id"]))
    ranked.sort(key=lambda x: -x[0])
    return [i for _, i in ranked[: int(cfg["maxRoutes"])]]


def main() -> int:
    fail = 0
    for prompt, need in EXPECT.items():
        got = set(score_prompt(prompt))
        ok = bool(need & got) if len(need) == 1 else need.issubset(got) or bool(need & got)
        # dual-route case: require all listed ids present in top-2
        if len(need) > 1:
            ok = need.issubset(got)
        else:
            ok = need.issubset(got)
        status = "ok" if ok else "FAIL"
        if not ok:
            fail += 1
        print(f"{status}: {prompt} -> {', '.join(score_prompt(prompt)) or '(none)'} expected {sorted(need)}")
    return 1 if fail else 0


if __name__ == "__main__":
    sys.exit(main())
