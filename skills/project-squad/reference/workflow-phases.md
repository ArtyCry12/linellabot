# Project Squad — workflow phases

## Phase 0 — Gate (Boss, no code)

1. Parse user goal; if ambiguous → **one** AskQuestion block (max 2 questions).
2. Confirm: target path, forbidden zones (`.env`, contracts, etc.), commit/deploy policy.
3. Emit **Squad Brief** (markdown): goal, constraints, agent map, success criteria.

## Phase 1 — Scout (`explore`, Scout model)

- Repo layout, stack, scripts, env samples (never print secrets).
- Use `graphify` / `markitdown` for heavy docs.
- Output: `scout-report.md` structure in chat (paths, risks, unknowns).

## Phase 2 — Design (`generalPurpose`, Standard)

Only if UI/UX/motion in scope:

- `/ui-ux-pro-max` + `/huashu-design` for direction.
- `/21st-design` + `@21st-dev/magic` for components.
- `/remotion` + `/figma` for motion/assets.
- Output: design decisions list (no mass writes without Boss approval).

## Phase 3 — Plan (Boss)

- Structured fix/build plan from scout + design.
- GitNexus **impact** before symbol edits (indexed repos).
- User approval before Phase 4 if changes are large.

## Phase 4 — Build (`generalPurpose`, Heavy)

- `/mattpocock-skills` conventions.
- Minimal diff; match existing code style.
- `uv` for Python; `npx.cmd` on Windows.

## Phase 5 — Review (`code-reviewer` / `bugbot`, Standard)

- `/thermo-nuclear-code-quality-review` Task for maintainability.
- Fix critical findings before QA.

## Phase 6 — QA (`shell` + Playwright + browser MCP)

- lint, typecheck, build, tests (project scripts).
- Playwright smoke on critical flows.
- `cursor-ide-browser` for live UI if dev server running.

## Phase 7 — Growth (optional)

- `/seo-geo` + alert-manager sub-skill if SEO requested.
- `performance-optimizer` Task if perf requested.

## Phase 8 — Cleanup (Fast shell)

- List cache/temp candidates; delete only obvious junk.
- Never delete `.env`, migrations, lockfiles without approval.

## Phase 9 — Ship (gated)

- **No commit** unless user said so or master prompt allows after green checks.
- **No deploy** without explicit user approval.
- `deployment-expert` + `plugin-vercel-vercel` when approved.

## Phase 10 — Memory + refresh

- Obsidian: update project note (autonomous per `obsidian-mcp.mdc`).
- Hub refresh: `commands/cursor-system-refresh.cmd` when working in `.cursor` hub.

## Final deliverable

Boss outputs: changes summary, checks run, open risks, next steps. No "done" without evidence.
