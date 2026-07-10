# DEC-057 — Task Router (auto intent recognition)

**Status:** Accepted  
**Date:** 2026-07-10

## Context

User wants automatic routing from natural-language requests to skills, subagents, MCP, and plugins without explicit `@tags` or tool names. Existing `auto-orchestrator.mdc` is on-demand only; agents may not load it every turn.

## Decision

Implement a **hook-backed Task Router**:

1. `lib/task-router/routes.json` — scored manifest (RU+EN keywords, phrases, tags)
2. `hooks/task-router.ps1` — `UserPromptSubmit` injects `[TASK ROUTE]` context
3. `rules/task-router.mdc` — **always-on** compact rule to honor injected bundle
4. `commands/task-router-test.ps1` — regression samples

Runs alongside `autopilot.ps1` (rights vs routing).

## Consequences

- Every prompt gets lightweight classification when score >= 6
- Agent loads minimal skill/MCP set per task
- Extend routes.json when adding hub capabilities; no hook code change
- Reload Window required after first install of hooks.json change

## Not in scope

- ML classifier / embedding model (keyword scoring only)
- Blocking prompts (inject-only, fail-open)
