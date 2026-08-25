# Cursor Agent Hub — System Registry

Canonical map of `C:\Users\artyo\.cursor`. Update when adding rules, skills, or MCP servers.

**Нагрузка / навигация (2026-08-15):** [`SYSTEM-VISIBILITY-MAP.md`](SYSTEM-VISIBILITY-MAP.md) · баги: [`ai-tracking/hub-load-audit.md`](ai-tracking/hub-load-audit.md) · сырой скан: [`ai-tracking/hub-load-inventory.json`](ai-tracking/hub-load-inventory.json) · бэкап MCP (фаза 1): [`ai-tracking/mcp-backup-index.json`](ai-tracking/mcp-backup-index.json) · индекс скиллов: `skills/_INDEX.md` (hub-only, 112) · плагины UI: [`ai-tracking/plugin-disable-checklist.md`](ai-tracking/plugin-disable-checklist.md) · `.cursorignore` (фаза 3)

## Layers (priority order)

1. **User Rules** (Cursor Settings) — highest priority
2. **Always-on local rules** — `00-agent-orchestrator.mdc` (compact only)
3. **On-demand rules** — domain triggers (`mcp-routing`, `clone-website`, `system-taxonomy`, `karpathy-guidelines`, …)
4. **Skills** — `skills/`, `skills-cursor/`, plugin cache skills
5. **MCP tools** — read one descriptor JSON before first call
6. **Subagents** (Task tool) — parallel only when independent
7. **GitNexus** — symbol edits in indexed repos only

## Taxonomy & knowledge base (DEC-010)

| Resource | Path | Load |
|----------|------|------|
| **22-domain map** | `SYSTEM-TAXONOMY.md` | On demand |
| Foundation repos | `docs/knowledge-base/FOUNDATION-REPOS.md` | Refresh / planning |
| External URL catalog | `docs/knowledge-base/EXTERNAL-CATALOG.md` | Lookup |
| Agency → Squad map | `docs/knowledge-base/AGENCY-PORTFOLIO-MAP.md` | Spawn agency personas |
| Token & memory caps | `docs/knowledge-base/TOKEN-MEMORY-POLICY.md` | Long sessions |
| Token optimization catalog | `docs/knowledge-base/TOKEN-OPTIMIZATION-SOURCES.md` | Economy planning |
| AI stack map (hub vs project) | `docs/knowledge-base/AI-STACK-MAP.md` | What to install where |
| AI agency playbook | `docs/knowledge-base/AI-AGENCY-STARTUP.md` | Business planning |
| Pixel office (viz) | `tools/pixel-office/` · `commands/pixel-office.ps1` | Opt-in demo |

## Always-on rules

| File | Role |
|------|------|
| `rules/00-agent-orchestrator.mdc` | MCP/skill routing tables, registry pointer |
| `rules/user-profile.mdc` | Quiz profile: plain RU, questions policy, automation |
| `rules/task-router.mdc` | Auto intent → skill/MCP/subagent (hook-backed) |
| `rules/prompt-engineering-coach.mdc` | Post-session prompt lessons (DEC-058) |
| `rules/markitdown.mdc` | Document intake always-on |
| `rules/rtk-token-economy.mdc` | RTK, compress Shell output |
| `rules/ponytail.mdc` | YAGNI / minimal code |
| `rules/openrouter-free-routing.mdc` | Draft work → OpenRouter free; subagent model replace |

## Task Router (DEC-057)

| Resource | Path |
|----------|------|
| Manifest (keywords RU+EN) | `lib/task-router/routes.json` |
| Resolver | `lib/task-router/Resolve-TaskRoute.ps1` |
| Hook (every prompt) | `hooks/task-router.ps1` |
| Test | `commands/task-router-test.ps1` · `/route` |

## Prompt Engineering Coach (DEC-058)

| Resource | Path |
|----------|------|
| Skill | `skills/prompt-engineering-coach/SKILL.md` |
| Capture hook | `hooks/prompt-coach-capture.ps1` |
| State / gating | `lib/prompt-coach/PromptCoach.ps1` |
| Lessons | `ai-tracking/prompt-lessons/` |
| Notion hub | 📚Мой promt-engineering |
| Status | `commands/prompt-coach-status.ps1` · `/prompt-lesson` |
| Test | `commands/prompt-coach-test.ps1` |
| Combined test | `commands/hub-learning-test.ps1` (router + coach) |
| Rule | `rules/prompt-engineering-coach.mdc` (always-on check after delivery) |
| Mini-score | `hooks/prompt-coach-stop.ps1` · `_scores.jsonl` |
| Water metrics | `Measure-PromptWater` · `_metrics.jsonl` · `commands/prompt-water-report.ps1` |
| Notion publish | `commands/prompt-lesson-notion.ps1` (approval) |
| Cheatsheet | `commands/prompt-hooks-cheatsheet.ps1` (30d) |
| Autopilot contract | `templates/prompt-lesson/CONTRACT-TEMPLATE.md` |
| TTS | `commands/prompt-lesson-tts.ps1` |

## User profile (Phase C-D-E)

| Resource | Path |
|----------|------|
| Profile data | `ai-tracking/user-profile/profile.json` |
| Rule | `rules/user-profile.mdc` (always-on) |
| Hook | `hooks/user-profile-intake.ps1` |
| Loader | `lib/user-profile/UserProfile.ps1` |
| Test | `commands/personalization-test.ps1` |

## ECC harness (Phase C-D-E)

| Resource | Path |
|----------|------|
| Skill | `skills/ecc-harness/SKILL.md` |
| Source clone | `lib/ecc-src/` (gitignored) |
| Instincts | `ai-tracking/instincts/` |
| Ensure | `commands/ensure-ecc.ps1` |

## MCP tiers (Phase C-D-E)

| Resource | Path |
|----------|------|
| Tier manifest | `lib/mcp-router/McpTier.ps1` |
| Health | `commands/mcp-health.ps1` |
| Stack install | `commands/ensure-mcp-stack.ps1` |
| Playwright | `commands/ensure-playwright-mcp.ps1` |
| MarkItDown MCP | в профиле `docs`; hook always-on |
| Repo index | `docs/knowledge-base/REPO-INTAKE-INDEX.md` |
| Memory protocol | `docs/knowledge-base/USER-MEMORY-PROTOCOL.md` |

## Hub gate & benchmarks

| Resource | Path |
|----------|------|
| All tests | `commands/hub-gate.ps1` |
| Benchmark axes | `lib/hub-benchmark/axes.json` |
| Snapshots | `ai-tracking/benchmark-snapshot-*.json` |
| Disk audit | `commands/hub-disk-audit.ps1` |
| GitHub archive | `commands/hub-archive-to-github.ps1` (dry-run default) |

## Video / Notion tasks

| Resource | Path |
|----------|------|
| Video learning | `skills/video-learning/SKILL.md` |
| Notion tasks | `skills/notion-tasks/SKILL.md` |
| Marketing brief | `templates/marketing/landing-brief.md` |
| Understand-Anything | `skills/understand-anything/SKILL.md` |
| Ruflo bridge | `docs/knowledge-base/RUFLO-SQUAD-BRIDGE.md` |

## Site compliance audit (legal / docs / licenses)

| Resource | Path |
|----------|------|
| Skill | `skills/site-compliance-audit/SKILL.md` |
| Sources (re-fetch every run) | `skills/site-compliance-audit/references/sources.md` |
| Modules | `skills/site-compliance-audit/references/modules.md` |
| Handoff (NLMedia chat, generalized) | `skills/site-compliance-audit/references/handoff.md` |
| Rule | `rules/site-compliance-audit.mdc` (on-demand) |
| Route | one id `site-compliance-audit` in `lib/task-router/routes.json` (`skills[]` helpers; no competing ids for oss-review / privacy-auditor / wcag) |
| Command | `commands/site-compliance.md` · `/site-compliance` |
| Catalog helpers | `~/.agents/skills/{oss-review,gdpr-ccpa-privacy-auditor,license-compliance-auditor,wcag-accessibility-audit}` |
| Tree | `rules/auto-orchestrator.mdc` · taxonomy domain 2 |

Default profile: MD + EU. Universal via `--profile eu|us|generic`. Not legal advice.

## Find Skills / skills.sh (Session 1 wire)

| Resource | Path |
|----------|------|
| Hub wrapper | `skills/find-skills/SKILL.md` |
| Upstream (npx) | `.agents/skills/find-skills/SKILL.md` |
| Rule | `rules/find-skills.mdc` (on-demand) |
| Route | `find-skills` in `lib/task-router/routes.json` |
| CLI wrapper | `commands/find-skills.ps1` |
| Test | `commands/find-skills-test.ps1` |
| Catalog | https://www.skills.sh/ |
| Install policy | Ask once → then `npx skills add … -g -y` |
| Liquidity | Prefer high installs; Design/UI exception |

## OpenRouter free models (cost routing)

| Resource | Path |
|----------|------|
| Canon (search here) | `ai-tracking/openrouter-free.md` |
| Skill | `skills/openrouter-free/SKILL.md` |
| Wrapper | `skills/openrouter-free/scripts/openrouter.ps1` |
| Rule (always-on) | `rules/openrouter-free-routing.mdc` |
| Squad override | `skills/project-squad/reference/model-map.md` (Free-model override) |
| Test | `commands/openrouter-free-test.ps1` |
| Health | `ai-tracking/openrouter-free-health.json` |
| Route | `openrouter-free` in `lib/task-router/routes.json` |
| AGENTS.md | `<!-- openrouter-free:start -->` |

Draft/routine → wrapper. Subagent map slugs are replaced. Do not Override OpenAI Base URL. Key: `OPENROUTER_API_KEY` user env.

## Skills / MCP Session 2 artifacts

| Resource | Path |
|----------|------|
| Skills taxonomy | `ai-tracking/skills-taxonomy-s2.md` |
| MCP/plugin tiers | `ai-tracking/mcp-plugin-tiers-s2.md` |
| Design replace list | `ai-tracking/design-replace-candidates-s2.md` |
| LVM image prompt schema | `lib/lvm/image-prompt.schema.json` |
| Archived skills | `skills/_archive/` |

## Awesome Prompts (DEC-062)

| Resource | Path |
|----------|------|
| Skill | `skills/awesome-prompts/SKILL.md` |
| Rule | `rules/awesome-prompts.mdc` |
| Matcher | `lib/awesome-prompts/Match-PromptTemplate.ps1` |
| Index | `lib/awesome-prompts/prompt-index.json` (659 templates) |
| Corpus | `lib/awesome-prompts/prompt-corpus.jsonl` (gitignored, rebuild) |
| Build | `commands/build-awesome-prompts-index.ps1` |
| Match CLI | `commands/awesome-prompts-match.ps1` |
| Test | `commands/awesome-prompts-test.ps1` |
| MCP fallback | `prompts.chat` in `mcp.json` |

## CrewAI (DEC-063)

| Resource | Path |
|----------|------|
| Skill | `skills/crew-ai/SKILL.md` |
| Rule | `rules/crew-ai.mdc` |
| Crews | `lib/crew-ai/crews/marketing-crew.json`, `production-crew.json` |
| Plan expander | `lib/crew-ai/Expand-CrewPlan.ps1` |
| CLI | `commands/crew-plan.ps1` |
| Test | `commands/crew-ai-test.ps1` |
| Squad bridge | `skills/project-squad/reference/crew-ai-bridge.md` |

## BabyAGI creative loop (DEC-064)

| Resource | Path |
|----------|------|
| Skill | `skills/babyagi/SKILL.md` |
| Rule | `rules/babyagi.mdc` |
| Loop engine | `lib/babyagi/CreativeLoop.ps1` |
| CLI | `commands/creative-loop.ps1` |
| Sessions | `ai-tracking/creative-loop/sessions/` |
| Test | `commands/babyagi-test.ps1` |

## LLM Council (DEC-061)

| Resource | Path |
|----------|------|
| Skill | `skills/llm-council/SKILL.md` |
| Rule | `rules/llm-council.mdc` |
| Source repo | karpathy/llm-council (pattern only) |

## Ecosystem audit + Quiz channel (Notion «2»)

| Resource | Path |
|----------|------|
| **Localhost landing** | `docs/ecosystem-audit/index.html` → `http://localhost:8765` |
| Server | `commands/ecosystem-audit-server.ps1` |
| Full audit (md) | `ai-tracking/FULL-SYSTEM-AUDIT.md` |
| Canvas (alt) | `projects/c-Users-artyo-cursor/canvases/ecosystem-audit.canvas.tsx` |
| Ingest | `commands/quiz-ingest.ps1` · `lib/quiz-channel/QuizChannel.ps1` |
| Profile store | `ai-tracking/user-profile/` (profile, fixes, **automation** quizzes) |
| Writing prefs | `ai-tracking/user-profile/writing-preferences.json` · `rules/humanizer-writing.mdc` |
| Issues backlog | `ai-tracking/ISSUES-INDEX.md` |
| Execution tracker | `ai-tracking/notion-prompts/page-2-EXECUTION.md` |

## MarkItDown (document intake)

| Resource | Path |
|----------|------|
| Skill | `skills/markitdown/SKILL.md` |
| Rule | `rules/markitdown.mdc` (always-on) |
| Core lib | `lib/markitdown/MarkItDown.ps1` |
| Venv | `.venv-markitdown` (Python 3.12 via uv) |
| Hook | `hooks/markitdown-intake.ps1` |
| Ensure | `commands/ensure-markitdown.ps1` |
| Drain queue | `commands/markitdown-drain.ps1` |
| Test | `commands/markitdown-test.ps1` |
| Health | `ai-tracking/markitdown-health.json` |
| Cache | `.cache/markitdown/` |

## n8n Templates (awesome-n8n-templates)

| Resource | Path |
|----------|------|
| Skill | `skills/n8n-templates/SKILL.md` |
| Source (gitignored) | `lib/n8n-templates-src/` |
| Index | `lib/n8n-templates/template-index.json` (297 templates) |
| Corpus | `lib/n8n-templates/template-corpus.jsonl` (path refs) |
| Matcher | `lib/n8n-templates/Match-N8nTemplate.ps1` |
| Build | `commands/build-n8n-templates-index.ps1` |
| Match CLI | `commands/n8n-templates-match.ps1` |
| Test | `commands/n8n-templates-test.ps1` |
| Pair with | `skills/n8n-workflow/`, MCP `n8n-mcp` |

## RTK + token economy

Three complementary layers: **RTK** (shell) · **Caveman** (prose) · **Ponytail** (code volume).

| Resource | Path |
|----------|------|
| Binary | `tools/rtk/rtk.exe` |
| Lib | `lib/rtk/Rtk.ps1` |
| Hook | `hooks/rtk-cursor-hook.ps1` → `preToolUse` / `Shell` |
| Ensure | `commands/ensure-rtk.ps1` |
| Install | `commands/install-rtk-binary.ps1` |
| Test | `commands/rtk-test.ps1` |
| Rule | `rules/rtk-token-economy.mdc` |
| tiktoken | `lib/prompt-coach/count_tokens.py` |
| Health | `ai-tracking/rtk-health.json` |
| KB | `docs/knowledge-base/TOKEN-OPTIMIZATION-SOURCES.md`, `AI-STACK-MAP.md` |
| Ponytail rule | `rules/ponytail.mdc` (always-on YAGNI) |
| Ponytail skill | `skills/ponytail/SKILL.md` (+ review/audit/debt) |
| Ponytail status | `commands/ponytail-status.ps1` |
| Caveman | `skills/caveman/SKILL.md` |

## Security Hub

| Resource | Path |
|----------|------|
| Skill | `skills/security-hub/SKILL.md` |
| Tool matrix | `skills/security-hub/tool-matrix.json` |
| Findings schema | `skills/security-hub/findings.schema.json` |
| Auth gate | `skills/security-hub/references/auth-gate.md` |
| Diff AI prompts | `skills/security-hub/prompts/` |
| Ensure | `commands/ensure-security-tools.ps1` |
| Scan | `commands/security-scan.ps1` |
| DAST / recon wrappers | `commands/security-dast.ps1`, `security-recon.ps1` |
| CI templates | `templates/security-ci/` |
| Health | `ai-tracking/security-tools-health.json` |
| Smoke test | `commands/security-hub-test.ps1` |
| Library | `skills/cybersecurity/` |

## On-demand rules

| File | Trigger |
|------|---------|
| `rules/auto-orchestrator.mdc` | Decision tree: task → MCP → skill → subagent |
| `rules/mcp-routing.mdc` | MCP conflicts, web dedup |
| `rules/open-design.mdc` | `@open-design` / `@od` / `@huashu`, prototypes, motion, decks |
| `rules/21st-design.mdc` | `@21st`, 21st.dev components |
| `rules/clone-website.mdc` | Site clone, pixel-perfect rebuild |
| `rules/cybersecurity.mdc` | Security audit, Anthropic cyber skills |
| `rules/seo-geo.mdc` | SEO/GEO pack |
| `rules/ui-ux-pro-max.mdc` | `@ui-ux` design system |
| `rules/awesome-design-md.mdc` | Design markdown patterns |
| `rules/system-taxonomy.mdc` | 22-domain classification, hub refresh |
| `rules/karpathy-guidelines.mdc` | Surgical edits, simplicity, verify loops |
| `rules/subagent-guardrails.mdc` | REQ-032–038 Squad delegation |
| `rules/notion-workspace.mdc` | Notion MCP + task UX |
| `rules/design-stack.mdc` | shadcn, CRO, design deps |
| `rules/ai-coding-security.mdc` | REQ-067–068 blindspots |

## User MCP (`mcp.json`, gitignored)

**Setup:** copy `mcp.json.example` → `mcp.json` (ядро). Полный каталог без секретов: `lib/mcp-router/mcp.json.example-full.json`. Живые ключи: `mcp.json.store`.

**Профили:** `powershell -File commands/mcp-profile.ps1 -Name core|design|qa|docs|ops|full` затем Reload Window. Статус: `commands/mcp-profile.ps1 status`. Heap GitNexus: 1536. Ignore индекса: `.gitnexusignore`.

| Сервер | Роль | Профиль |
|--------|------|---------|
| `memory` | Сессионные факты | core |
| `gitnexus` | Граф кода | core |
| `open-design` · `stitch` · `21st` · `context7` | Дизайн / UI / доки | design |
| `playwright` | E2E-код | qa |
| `markitdown-mcp` | Конвертация MCP (hook отдельно) | docs |
| `notion` · `n8n-mcp` · `google-workspace` | Второй мозг / автоматизация | ops |

## Plugin MCP (enable on demand)

| When | Server (descriptor folder) |
|------|----------------------------|
| Web research | **`plugin-exa-exa`** (primary) |
| Deploy | `plugin-vercel-vercel` |
| Database | `plugin-supabase-supabase` |
| Payments | `plugin-stripe-stripe` |
| Auth | `plugin-clerk-clerk` |
| Design | `plugin-figma-figma` |
| Browser E2E | `cursor-ide-browser` |
| Automation | `plugin-zapier-zapier` |
| Crawl (only if Exa insufficient) | `plugin-tavily-tavily` |

**Web dedup:** use **Exa** first; `user-fetch` for one known URL; avoid parallel Exa+Tavily+Firecrawl.

## MCP naming map (config id ↔ descriptor folder)

| `mcp.json` / UI id | Descriptor folder under `projects/.../mcps/` |
|--------------------|-----------------------------------------------|
| `gitnexus` | `user-gitnexus` |
| `memory` | `user-memory` |
| `fetch` | `user-fetch` |
| `stitch` | `user-stitch` |
| `figma` | `plugin-figma-figma` |
| `gemini` | `user-gemini` |
| `prompts.chat` | `plugin-prompts-chat` |
| `notion` | `user-notion` / `plugin-notion-notion` |
| `context7` | `user-context7` (after first connect) |
| `iconify` | `user-iconify` (after first connect) |
| `@21st-dev/magic` / **`21st`** | `user-21st` (канон в mcp.json: `21st`) |

## Top personal skills

| Skill | Path |
|-------|------|
| clone-website | `skills/clone-website/SKILL.md` |
| open-design | `skills/open-design/SKILL.md` · repo `skills/open-design/repo/` |
| 21st-design | `skills/21st-design/SKILL.md` |
| seo-geo | `skills/seo-geo/SKILL.md` |
| project-squad | `skills/project-squad/SKILL.md` |
| n8n-workflow | `skills/n8n-workflow/SKILL.md` — JSON authoring, expressions, validation |
| dev-os | `skills/dev-os/SKILL.md` — research-first meta-layer, bootstrap gate |
| cybersecurity | `skills/cybersecurity/SKILL.md` — library playbooks |
| security-hub | `skills/security-hub/SKILL.md` — orchestrator + scans |
| **site-compliance-audit** | `skills/site-compliance-audit/SKILL.md` — legal/docs/licenses gap scan |
| ponytail | `skills/ponytail/SKILL.md` — YAGNI code ladder |
| **agency-agents** | `skills/agency-agents/SKILL.md` — 66 personas in `rules/agency/` |
| **production-studio** | `skills/production-studio/SKILL.md` — storyboard, LVM shorts |
| **notion-workspace** | `skills/notion-workspace/SKILL.md` — Notion T3 cleanup, tasks |
| **prompt-engineering-coach** | `skills/prompt-engineering-coach/SKILL.md` — post-session lessons |

## Notion mega-prompt (Jul 2026)

| Artifact | Path |
|----------|------|
| Verbatim combined prompt | `ai-tracking/COMBINED-NOTION-PROMPT.md` (~65KB) |
| REQ registry (80 items) | `ai-tracking/REQ-REGISTRY-NOTION.md` |
| Pre-implementation gates | `ai-tracking/PRE-IMPLEMENTATION-RULES.md` |
| Rebuild script | `commands/build-combined-notion-prompt.mjs` |

Auto index: `skills/_INDEX.md` (**112** hub-only, `commands/generate-skill-index.mjs`). Не включает Open Design `repo/`.

## Subagents

### Dev OS meta-layer (Phase 5 — DEC-008 executive, DEC-006 autonomy, DEC-007 evolution)

Operating model: Candidate A. **Evolution:** permanent 10-principle policy. **Autonomy:** execute by default; escalate critical only.

| Resource | Path |
|----------|------|
| Skill | `skills/dev-os/SKILL.md` |
| Executive charter | `docs/dev-os/EXECUTIVE.md` |
| Execution lifecycle | `skills/dev-os/execution/SKILL.md` |
| Evolution | `skills/dev-os/evolution/SKILL.md` · `policies/evolution-principles.md` |
| Autonomy | `skills/dev-os/autonomy/SKILL.md` |
| Emergence | `skills/dev-os/emergence/SKILL.md` |
| Structure | `ai-tracking/dev-os/synthesis/structure-emergence.md` |
| Canon | `docs/dev-os/BOOTSTRAP.md` |
| Corpus | `ai-tracking/dev-os/` |
| Command | `/dev-os` → `commands/dev-os.md` |
| Rule | `rules/dev-os.mdc` (on-demand) |

| Agent | Model | Role |
|-------|-------|------|
| `dev-os-research` | Composer 2.5 Fast | Domain research sprints, source cards |

New agents require DEC log + emergence checklist. Gate: `understanding.md` → `research_complete`.

### Ecosystem Architect (`agents/ecosystem-architect.md`) — governance layer

| Agent | Role |
|-------|------|
| `ecosystem-architect` | Sole permanent hub governance agent: architecture drift, skill taxonomy/quarantine, MCP profiles, registry/graph health, tech research. **Not** Project Squad. |

Skill: `skills/ecosystem-architect/SKILL.md` · Canon: `ai-tracking/ecosystem-governance/` · Route: `ecosystem-architect`  
**Policy (2026-08-24):** do not auto-create Squad; on new project ask Boss if personal Squad is needed.

### Project Squad v2 (`agents/squad-*.md`) — execution layer (opt-in per project)

| Agent | Model | Role |
|-------|-------|------|
| `squad-scout` | Composer 2.5 | Audit / inventory |
| `squad-architect` | Sonnet 4.6 | Tech plan |
| `squad-design` | Sonnet 4.6 | UI/UX / motion |
| `squad-build` | Codex 5.3 High | Code |
| `squad-qa` | Sonnet 4.6 | Tests / Playwright |
| `squad-review` | GPT-5.5 | Code review |
| `squad-growth` | Sonnet 4.6 | SEO / GEO / perf |
| `squad-ship` | Sonnet 4.6 | Deploy (gated) |
| `squad-memory` | Haiku 4.5 | user-memory + AGENTS.md |
| `squad-cleanup` | Composer 2.5 | Cache / hub refresh |
| `squad-marketing` | Sonnet 4.6 | Copy / content / ads |

Boss (parent chat): **Opus 4.7**. Skill: `skills/project-squad/SKILL.md` · Command: `/project-squad`

### Built-in Task types (fallback)

| Task | Subagent |
|------|----------|
| Broad scan | `explore` |
| Shell / CI | `shell` |
| Deploy | `deployment-expert` |
| Review | `code-reviewer`, `bugbot` |

## Commands

| Script | Purpose |
|--------|---------|
| `commands/cursor-system-refresh.cmd` | **Full refresh:** audit → cyber library → sync → index → cleanup (unlocked) → queue deferred |
| `commands/cursor-system-refresh-quick.cmd` | **Quick:** sync rules + skill index + audit only |
| `commands/cursor-system-refresh.ps1` | Orchestrator (`-Quick`, `-Deferred`, `-SkipCyber`) |
| `commands/cursor-system-refresh-deferred.ps1` | Heavy cleanup after Cursor exits (auto-spawned) |
| `commands/project-squad.md` | **Project Squad** — `/project-squad` multi-agent team |
| `commands/stitch-mcp.md` | **Stitch MCP** — proxy + 14 UI design tools |
| `commands/n8n-mcp.md` | **n8n MCP** — instance workflows + Workflow SDK |
| `commands/n8n-workflow.md` | **n8n Workflow skill** — offline JSON authoring knowledge |
| `commands/dev-os.md` | **Dev OS** — research-first meta-layer bootstrap |
| `commands/stitch-mcp-proxy.mjs` | stdio proxy (strips outputSchema for Cursor) |
| `commands/ensure-stitch.ps1` | Stitch health check + descriptor sync |
| `commands/ensure-n8n.ps1` | n8n MCP health check + descriptor sync |
| `commands/cursor-system-audit.ps1` | Hub health report → `ai-tracking/` |
| `commands/cursor-system-cleanup.ps1` | Move repos, delete caches (`-Apply`, `-SkipLocked`, `-Force`) |
| `commands/huashu-sync-workspace-rules.py` | Push rules to workspaces |
| `commands/ensure-open-design.ps1` | Sparse-clone/update nexu-io/open-design |
| `commands/generate-skill-index.mjs` | Regenerate `skills/_INDEX.md` |
| `commands/foundation-refresh.md` | Taxonomy / knowledge-base update checklist |
| `commands/install-agency-agents.ps1` | Sync agency-agents → `rules/agency/` |
| `commands/generate-agency-index.mjs` | Regenerate `rules/agency/_INDEX.md` |
| `commands/bumblebee-scan.ps1` | Supply-chain scan (WSL linux binary or fallback) |
| `commands/hub-supply-scan.ps1` | Fallback lockfile/MCP inventory |
| `commands/sync-prompts-chat-mcp-descriptors.mjs` | prompts.chat MCP stubs |
| `commands/sync-notion-mcp-descriptors.mjs` | Notion MCP stubs |
| `commands/build-combined-notion-prompt.mjs` | Concat Notion prompt pages |
| `commands/pagespeed-audit.ps1` | PageSpeed Insights API run |
| `commands/task-router-test.ps1` | Task Router classification test |
| `commands/ensure-markitdown.ps1` | MarkItDown venv + smoke convert |
| `commands/markitdown-test.ps1` | MarkItDown install + hook dry-run |
| `commands/ensure-rtk.ps1` | RTK binary + Cursor preToolUse hook |
| `commands/rtk-test.ps1` | RTK health + tiktoken smoke |
| `commands/build-n8n-templates-index.ps1` | Index awesome-n8n-templates |
| `commands/n8n-templates-match.ps1` | Top-3 template match by query |
| `commands/route.md` | `/route` — preview auto-routing |

### Deferred cleanup flow

1. Run `cursor-system-refresh.cmd` (safe while Cursor is open).
2. Script spawns hidden `cursor-system-refresh-deferred.ps1` and writes `ai-tracking/.deferred-refresh-pending.json`.
3. After you **close Cursor**, deferred job deletes `extensions/`, moves embedded repos, refreshes cyber library if needed.
4. Log: `ai-tracking/deferred-refresh-*.txt`.

## External projects

Client repos live in `C:\Users\artyo\projects\` — open as separate Cursor workspaces, not embedded in hub.

### SEO+GEO+AIO block

Charter: `ai-tracking/ecosystem-governance/blocks/seo-geo-aio/CHARTER.md` · Route: `seo-geo-aio-block` · Sentry: ops/qa (see `SENTRY-MCP.md`).

