# Orchestration patterns (reference only)

Do **not** add LangChain or Auto-GPT as hub runtime dependencies. Steal the *shape* of agent loops:

## Useful patterns

1. **Planner → tools → critic** — classify tier, run CLI, FP-filter / triage (like Anthropic security-review false-positive stage).
2. **Diff-scoped tools** — only scan changed paths for secrets/SAST on PR (reduces tokens + noise).
3. **Sandbox first** — DAST/recon against lab (Juice Shop Phase 2) before staging; never production without explicit ask.
4. **Artifact handoff** — every scan writes under `.cache/security-hub/` so the next skill reads files, not chat paste.

## Anti-patterns

- Autonomous “keep going until root” agents on live networks (Auto-GPT style).
- Loading all 754 cybersecurity skills into one turn.
- Emitting Metasploit/sqlmap modules without Phase 2 + written authorization.

## Mapping to hub

| Pattern | Hub piece |
|---------|-----------|
| Tool router | `tool-matrix.json` + task-router |
| Critic / FP filter | `prompts/false-positive-filter.md` |
| Memory of auth | auth-gate + session note |
| CI parallel | `templates/security-ci/*.yml` |
