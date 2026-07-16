# Project Squad — workflow phases v2

## Phase 0 — Gate (Boss, Opus 4.7)

1. Parse goal; if empty → one AskQuestion (goal type).
2. Confirm: path, forbidden zones, commit/deploy policy.
3. Emit **Squad Brief**: agents, models, gates.

## Phase 1 — Scout (`squad-scout`, Composer)

- Repo layout, stack, junk candidates (list only).
- `graphify` / `markitdown` for heavy docs.

## Phase 2 — Architect (`squad-architect`, Sonnet)

- Technical plan from scout; GitNexus impact list.
- Boss approval before build if large scope.

## Phase 3 — Design (`squad-design`, Sonnet)

Only if UI/UX/motion in scope.

## Phase 4 — Build (`squad-build`, Codex High)

- Minimal diff; `mattpocock-skills`.

## Phase 5 — Review (`squad-review`, GPT-5.5)

- Fix critical before QA.

## Phase 6 — QA (`squad-qa`, Sonnet)

- lint, typecheck, build, Playwright.

## Phase 7 — Growth (optional, `squad-growth`)

- `/seo-geo`, performance-optimizer.
- **CrewAI marketing crew:** `commands/crew-plan.ps1 -Crew marketing -Topic "<topic>"` then sequential squad-growth steps (research → strategy → copy → audit). See `skills/project-squad/reference/crew-ai-bridge.md`.

## Phase 8 — Cleanup (`squad-cleanup`, Composer)

- Safe cache purge; hub refresh via `cursor-system-refresh.cmd`.

## Phase 9 — Ship (gated, `squad-ship`)

- No commit/deploy without explicit user OK.

## Phase 10 — Memory (`squad-memory`, Haiku)

1. `user-memory` crumbs
2. Update `AGENTS.md` if high-signal
3. `ai-tracking/` one-liner

## Hub refresh (when workspace is `.cursor` hub)

`commands/cursor-system-refresh.cmd` or `-Quick`.

## Final deliverable

Evidence-backed summary: agents spawned, checks, risks, next steps.
