# ISSUES-INDEX — Cursor Hub weaknesses & fixes

Single file for all errors/weaknesses found during audits. Fix in separate sessions.

**Updated:** 2026-07-12 · Source: MarkItDown + n8n-templates + RTK plan

| ID | Area | Severity | Issue | Fix track |
|----|------|----------|-------|-----------|
| ISS-013 | Token economy | P2 | RTK hook needs Reload Window after hooks.json | **DONE** — ensure-rtk + rtk-cursor-hook.ps1 |
| ISS-014 | Integrations | P2 | awesome-n8n-templates not indexed | **DONE** — `skills/n8n-templates/`, 297 templates |
| ISS-015 | Integrations | P2 | MarkItDown not always-on | **DONE** — hook + rule + ensure |
| ISS-016 | Docs | P3 | No hub vs project stack map | **DONE** — `AI-STACK-MAP.md` |
| ISS-001 | Tests | P1 | Hub test score 5.4/10 — repo-intake may be uncommitted | Run hub-learning-test + commit intake |
| ISS-002 | Integrations | P1 | awesome-chatgpt-prompts not indexed locally | **DONE** — `skills/awesome-prompts/` |
| ISS-003 | Integrations | P1 | crewAI patterns not wired to squad-growth | **DONE** — `skills/crew-ai/` |
| ISS-004 | Integrations | P1 | babyagi creative loop not in skills | **DONE** — `skills/babyagi/` |
| ISS-005 | Hooks | P2 | Reload Window required after hooks.json — easy to forget | POST-RELOAD-GUIDE reminder in autopilot |
| ISS-006 | MCP | P2 | Notion MCP intermittent timeout | Retry + cache fetch in commands |
| ISS-007 | Quiz channel | P2 | Canvas cannot write disk — manual !quiz-ingest step | inbox/ + ScanInbox documented |
| ISS-008 | Prompt coach | P2 | User prompt "water" — no hard trim yet | **DONE** — `_metrics.jsonl`, water report |
| ISS-009 | Production | P3 | Carousel GPT Image 2 template missing | **DONE** — carousel-gpt-image-2.md |
| ISS-010 | Production | P3 | AI video photocard prompts not in registry | **DONE** — photocard-ai-video.md |
| ISS-011 | Writing | P2 | Learning text too AI-ish | **DONE** — humanizer rule + writing-preferences.json |
| ISS-012 | Automation | P2 | !auto gates unclear | **DONE** — quiz automation + profile.automationPrefs |

## Resolved (this session)

| ID | Fix |
|----|-----|
| ISS-R01 | llm-council → `skills/llm-council/` + rule + route |
| ISS-R02 | Online presentation + 2 quizzes → `canvases/ecosystem-audit.canvas.tsx` |
| ISS-R07 | MarkItDown always-on → hook, venv, cache, drain |
| ISS-R08 | n8n-templates index 297 + matcher + skill |
| ISS-R09 | RTK preToolUse + TOKEN-OPTIMIZATION-SOURCES + AI-STACK-MAP |

## Quiz ingest paths

- `ai-tracking/user-profile/quiz-responses.jsonl` — all submissions
- `ai-tracking/user-profile/profile.json` — merged profile + fix priorities + **automationPrefs**
- Quizzes: `profile` | `fixes` | `automation`
- `ai-tracking/user-profile/inbox/*.json` — drop zone for `-ScanInbox`
