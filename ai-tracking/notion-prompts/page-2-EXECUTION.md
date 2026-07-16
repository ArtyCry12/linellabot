# Notion «2» — execution tracker (w5 repo-first + !auto A)

**Notion:** https://app.notion.com/p/3996689eb5b880e6aa94f17271d51c8c  
**Strategy:** Variant 5 — integrate 4 repos before full audit  
**User:** `!auto A` + quizzes must be **online**, same UI, **channel to system**

## Phase A — Repos (4/4 complete)

| # | Repo | Status | Hub path |
|---|------|--------|----------|
| 1 | karpathy/llm-council | **DONE** | `skills/llm-council/`, `rules/llm-council.mdc` |
| 2 | f/awesome-chatgpt-prompts | **DONE** | `lib/awesome-prompts/`, matcher |
| 3 | crewAIInc/crewAI | **DONE** | `skills/crew-ai/`, marketing + production crews |
| 4 | yoheinakajima/babyagi | **DONE** | `skills/babyagi/`, `creative-loop.ps1` |

## Phase B — Audit deliverable

| Item | Status | Path |
|------|--------|------|
| **Full system audit** | **DONE** | `ai-tracking/FULL-SYSTEM-AUDIT.md` (12 zones, 10 benchmarks) |
| **Localhost landing** | **DONE** | `docs/ecosystem-audit/index.html` → http://localhost:8765 |
| Server | **DONE** | `commands/ecosystem-audit-server.ps1` |
| Custom benchmarks | **DONE** | 10 axes on landing (avg 7.6) |
| Quiz 1 profile | **DONE** | quiz=profile |
| Quiz 2 system fixes | **DONE** | quiz=fixes |
| Quiz 3 automation | **DONE** | quiz=automation → profile.automationPrefs |
| Humanizer prefs | **DONE** | `rules/humanizer-writing.mdc`, writing-preferences.json |
| Canvas (alt) | **DONE** | `canvases/ecosystem-audit.canvas.tsx` |
| System channel | **DONE** | `commands/quiz-ingest.ps1` |
| ISSUES-INDEX | **DONE** | `ai-tracking/ISSUES-INDEX.md` |

## Phase C — Remaining

- [x] Speech/prompt water metrics DB (extend prompt-coach)
- [x] Carousel + photocard prompts for production-studio
- [x] Full audit refresh (canvas benchmarks post Phase A)

## How to use quizzes

1. Start server: `powershell -File commands/ecosystem-audit-server.ps1`
2. Open http://localhost:8765/ — fill Quiz 1, 2, or **3 (automation)**
3. Fallback: JSON → `ai-tracking/user-profile/inbox/*.json` + `quiz-ingest.ps1 -ScanInbox`
