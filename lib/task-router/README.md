# Task Router Max

Fast semantic preflight: plain-language intent → required skill / MCP /
Always On system / ephemeral agent / architecture stage.

## Flow

```
User prompt (+ optional *.plan.md path in text)
  → hooks/task-router.ps1 (UserPromptSubmit)
    → Resolve-TaskRoute.ps1 (compatibility + cache/log)
    → router-core.mjs (clauses/spans → action/object/context)
    → capabilities.generated.json
    → injects [TASK ROUTE] + [TASK PREFLIGHT]
    → agent MUST execute REQUIRED actions or report blocker

Task/Subagent prompt
  → hooks/task-router-task.ps1
    → same Resolve + ephemeral agent report contract
```

## Meaning layers

1. Exact tag/path/rare technical keyword.
2. Phrases and simple utterance examples.
3. Small clause spans scored as action/object/context inside the larger clause.
4. Anti-examples, negation, conflict margin and confidence.
5. Mandatory route-advisor for substantive low-confidence input.

Local budget: p95 ≤250 ms. Current golden corpus: 85 Russian/plain-language
cases. Social/no-task messages stay silent.

## Capability index

- Source routes: `routes.json`
- Simple-language overlays and Always On gates: `capability-overrides.json`
- Preflight state machine: `preflight-policy.json`
- Generator: `build-capability-index.mjs`
- Generated SoT for runtime: `capabilities.generated.json`

Archive and unrouted quarantine entries are excluded. Every generated skill path
is checked; drift fails the build check.

## Advisor

For every substantive unmatched/ambiguous request, parent **must** run
`agents/route-advisor.md` once with `composer-2.5-fast`. Never inherit or loop.
The advisor returns route, stage, confidence and required actions.

## Maintain

| Action | How |
|--------|-----|
| Add route | Edit `routes.json`, then rebuild index |
| Add plain language | Edit `capability-overrides.json` |
| Build/check index | `node lib/task-router/build-capability-index.mjs [--check]` |
| Semantic quality | `node commands/task-router-eval.mjs` |
| Contracts/privacy | `node commands/task-router-contract-test.mjs` |
| Hook integration | `powershell -File commands/task-router-hook-test.ps1` |
| Legacy/UTF-8 regression | `powershell -File commands/task-router-test.ps1` |
| Debug one prompt | `commands/task-router-test.ps1 -Prompt "..."` |
| Health/receipts | `commands/task-router-health.ps1` |
| Promote confirmed spans | `node commands/task-router-promote-candidates.mjs` (dry run) |

Candidate phrases live in `.cache/task-router/candidates.jsonl`; receipts live
in `.cache/task-router/receipts.jsonl`. Both are gitignored and redacted.

## Version

DEC-057 · semantic preflight 2026-09-07
