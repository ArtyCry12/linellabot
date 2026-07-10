---
name: mattpocock-skills
description: >-
  Routes to Matt Pocock's composable engineering skills (TDD, diagnose, triage,
  grill-me, architecture, PRD/issues). Use for @mattpocock-skills, @top-coding,
  /tdd, /diagnose, /grill-me, /triage, /to-prd, /to-issues, /prototype,
  /zoom-out, /handoff, /caveman, or "skills for real engineers".
disable-model-invocation: true
---

# Matt Pocock Skills (Top Coding)

Small, composable engineering workflows from [mattpocock/skills](https://github.com/mattpocock/skills). Bundle path:

`~/.cursor/skills/skills-main-top-coding/skills-main/`

## First-time setup (per repo)

Before engineering skills that touch issues or domain docs, run **`setup-matt-pocock-skills`** once in the target repo. It scaffolds `docs/agents/` (issue tracker, triage labels, domain layout).

## Route to the right skill

Read the matching skill's `SKILL.md` under `~/.cursor/skills/<name>/` (junctions into the bundle). Do not improvise the workflow.

| User intent | Skill | Slash |
|-------------|-------|-------|
| Align on a plan before coding (general) | `grill-me` | `/grill-me` |
| Align + update `CONTEXT.md` / ADRs | `grill-with-docs` | `/grill-with-docs` |
| Red-green-refactor, test-first feature/bugfix | `tdd` | `/tdd` |
| Hard bug or perf regression | `diagnose` | `/diagnose` |
| Incoming issue → triage state machine | `triage` | `/triage` |
| Conversation → GitHub PRD issue | `to-prd` | `/to-prd` |
| Plan/PRD → vertical-slice issues | `to-issues` | `/to-issues` |
| Rescue muddy architecture | `improve-codebase-architecture` | `/improve-codebase-architecture` |
| Explain unfamiliar code in system context | `zoom-out` | `/zoom-out` |
| Throwaway prototype (CLI or UI variants) | `prototype` | `/prototype` |
| Shorter replies, same accuracy | `caveman` | `/caveman` |
| Handoff doc for another agent | `handoff` | `/handoff` |
| Author a new skill | `write-a-skill` | `/write-a-skill` |
| Branch review (standards + spec) | `review` | `/review` |
| Pre-commit hooks (Husky, lint-staged) | `setup-pre-commit` | `/setup-pre-commit` |
| Per-repo config for engineering skills | `setup-matt-pocock-skills` | `/setup-matt-pocock-skills` |

**In progress** (experimental): `teach`, `writing-shape`, `writing-fragments`, `writing-beats`.

**Personal / misc**: `obsidian-vault`, `edit-article`, `migrate-to-shoehorn`, `scaffold-exercises`, `git-guardrails-claude-code`.

**Deprecated** — do not use: `design-an-interface`, `qa`, `request-refactor-plan`, `ubiquitous-language`.

## Operating rules

1. **One skill at a time** — load only the skill for the current task.
2. **Respect repo config** — if `docs/agents/` is missing, run `setup-matt-pocock-skills` before `triage`, `to-issues`, `to-prd`, `diagnose`, `tdd`, `improve-codebase-architecture`, or `zoom-out`.
3. **Use domain language** — when `CONTEXT.md` exists, read it before changing code in that area.
4. **Feedback loops** — prefer types, tests, and reproducible checks over speculative fixes.

## Install / refresh junctions (Windows)

From any shell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.cursor\skills\mattpocock-skills\scripts\link-skills.ps1"
```

Or update via skills.sh:

```bash
npx skills@latest add mattpocock/skills
```

## More detail

- Full catalog and philosophy: [README.md](../skills-main-top-coding/skills-main/README.md)
- Official plugin skill list: [.claude-plugin/plugin.json](../skills-main-top-coding/skills-main/.claude-plugin/plugin.json)
