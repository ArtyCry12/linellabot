# Task Router Max — baseline and contracts

Date: 2026-09-07
Plan: `plans/router-max-orchestration_f9a33491.plan.md` (not edited)

## Baseline before Router Max

- Resolver: PowerShell substring/word-boundary scoring.
- Plain-language probe: 6 of 7 ordinary Russian requests produced neither a
  route nor advisor; only the request containing an explicit question signal
  raised advisor.
- Existing golden fixtures: 3 hand-written prompts with route-specific wording.
- Real hit-rate was not measurable: `task-router-log.jsonl` was dominated by
  `smoke`, `test-fp` and `test-fx` sources.
- GitNexus index was four commits stale and did not expose PowerShell functions
  as symbols. Impact therefore returned `UNKNOWN`; direct consumers are both
  router hooks and router tests. Working risk classification: MEDIUM.
- `llm-council` pointed into `_quarantine`; `architecture-plan` referenced an
  unavailable `plugin-architect`; Project Squad route still pointed at archive.

## Router Max contracts

- `lib/task-router/route-decision.schema.json` — semantic result.
- `lib/task-router/preflight-policy.json` — required stage/action policy.
- `lib/task-router/agent-report.schema.json` — ephemeral agent report.
- `commands/task-router-receipt.ps1` — sanitized evidence receipt.
- `lib/task-router/capability-overrides.json` — simple-language intent cards and
  Always On gates.
- `lib/task-router/capabilities.generated.json` — deterministic generated index.

## Current quality gate

`node commands/task-router-eval.mjs`

- Cases: 93 (including social-prefix tasks, `без`, multi-intent and privacy attacks)
- Top-1: 100%
- Top-2: 100%
- False positives on social negatives: 0%
- Stage: 100%
- Advisor policy: 100%
- Local semantic p95: below 50 ms on the golden corpus; 12-run long ExtraText
  p95 is below 100 ms against a 250 ms contract.

These numbers are corpus evidence, not a claim about all future phrasing.
Unmatched substantive requests must still use route-advisor.
