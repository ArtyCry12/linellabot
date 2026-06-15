# Project Squad — team roster

Universal team for **any** Cursor workspace (Next.js, static, monorepo). Boss orchestrates; specialists run via **Task** tool.

| ID | Role | Task `subagent_type` | Model (see model-map) | Primary skills / MCP |
|----|------|----------------------|------------------------|----------------------|
| **boss** | Orchestrator | *(parent agent)* | Standard | `SYSTEM-REGISTRY.md`, `rules/auto-orchestrator.mdc`, `graphify`, `markitdown` |
| **scout** | Audit / inventory | `explore` | Scout | `graphify`, `markitdown`, `user-gitnexus` (if indexed) |
| **design** | UI/UX / motion plan | `generalPurpose` | Standard | `huashu-design`, `ui-ux-pro-max`, `21st-design`, `remotion`, `plugin-figma-figma` |
| **build** | Implementation | `generalPurpose` | Heavy | `mattpocock-skills`, Vercel `nextjs`, `shadcn` plugin skills |
| **qa** | Tests + browser | `shell` + `generalPurpose` | Fast / Heavy | Playwright skill (`~/.codex/skills/playwright`), `cursor-ide-browser` |
| **review** | Code quality | `code-reviewer` or `bugbot` | Standard | `thermo-nuclear-code-quality-review` (Task), plugin review skills |
| **growth** | SEO / GEO / perf | `generalPurpose` + `performance-optimizer` | Standard | `seo-geo` (+ `seo-geo-alert-manager` sub-skill), Vercel perf |
| **ship** | Deploy / env | `deployment-expert` | Standard | `plugin-vercel-vercel`, `deployments-cicd` skill |
| **memory** | PKM + session facts | *(Boss inline)* | Fast | `obsidian` MCP, `user-memory`, `agents-memory-updater` pattern via Obsidian |

## Parallelism

| Safe parallel | Never parallel |
|---------------|----------------|
| scout + design (after scout brief) | build + review on same diff |
| growth SEO audit + qa playwright (different surfaces) | two build agents same module |
| ship env check + qa smoke | cleanup delete + build |

## Missing skills (substitutes)

| Requested | Status | Substitute |
|-----------|--------|------------|
| `humanizer-main` | not in hub | Manual tone pass; or add skill later |
| `agents-memory-updater` | plugin Task agent | Obsidian autonomous + `user-memory` crumbs |
| `/thermo-nuclear-code-quality-review` | Task subagent | Launch via Task description exactly |
| `/performance-optimizer` | Vercel subagent | Task `performance-optimizer` |

Full workflow phases: [workflow-phases.md](workflow-phases.md)
