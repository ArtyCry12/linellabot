# Project Squad — team roster v2 (10 specialists + Boss)

Boss orchestrates; **10 custom subagents** in `~/.cursor/agents/squad-*.md`.

| ID | Role | Custom agent | Task fallback | Model | Primary skills / MCP |
|----|------|--------------|---------------|-------|----------------------|
| **boss** | Orchestrator | — | — | Opus 4.7 | `project-squad`, `SYSTEM-REGISTRY.md`, `auto-orchestrator` |
| **scout** | Audit / inventory | `squad-scout` | `explore` | Composer | `graphify`, `markitdown`, `user-gitnexus` |
| **architect** | Tech plan, modules | `squad-architect` | `generalPurpose` | Sonnet | GitNexus impact, `auto-orchestrator` |
| **design** | UI/UX / motion | `squad-design` | `generalPurpose` | Sonnet | `huashu-design`, `ui-ux-pro-max`, `21st-design`, `remotion`, `plugin-figma-figma` |
| **build** | Implementation | `squad-build` | `generalPurpose` | Codex High | `mattpocock-skills`, Vercel `nextjs`, `shadcn` |
| **qa** | Tests + browser | `squad-qa` | `shell` | Sonnet | Playwright skill, `cursor-ide-browser`, `verification` |
| **review** | Code quality | `squad-review` | `code-reviewer` / `bugbot` | GPT-5.5 | `thermo-nuclear-code-quality-review` |
| **growth** | SEO / GEO / perf | `squad-growth` | `performance-optimizer` | Sonnet | `seo-geo`, alert-manager sub-skill |
| **ship** | Deploy / env | `squad-ship` | `deployment-expert` | Sonnet | `plugin-vercel-vercel`, `deployments-cicd` |
| **memory** | Session + project facts | `squad-memory` | — | Haiku | **`user-memory`**, `AGENTS.md`, `ai-tracking/`; Obsidian **optional** |
| **cleanup** | Cache / hub refresh | `squad-cleanup` | `shell` | Composer | `cursor-system-refresh.cmd` |

## Memory stack (Obsidian demoted)

| Priority | Tool | Use |
|----------|------|-----|
| 1 | `user-memory` MCP | Short session facts |
| 2 | `AGENTS.md` / project README | Durable team context |
| 3 | `ai-tracking/` | Hub audit one-liners |
| 4 | Obsidian vault | **Optional** PKM when online + user asks; `skills/obsidian-mcp` on-demand |

## Parallelism

| Safe parallel | Never parallel |
|---------------|----------------|
| scout + design (after brief) | build + review same diff |
| growth + qa (different surfaces) | two build agents same module |
| memory + cleanup (post-work) | cleanup delete + build |
| architect + scout (read-only) | ship + cleanup |

## Spawn template (Boss)

```
Use the squad-<role> subagent to <task>.
Workspace: <absolute path>
Model: <from model-map.md>
Constraints: <no commit, forbidden paths>
```

Full phases: [workflow-phases.md](workflow-phases.md)
