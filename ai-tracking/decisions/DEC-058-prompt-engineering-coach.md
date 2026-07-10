# DEC-058 — Prompt Engineering Coach (персональные уроки)

**Status:** Accepted  
**Date:** 2026-07-10

## Context

User wants parallel prompt-engineering coaching from real prompts (not generic lessons), distinguishing user vs AI text, brief human-style lessons in `ai-tracking/prompt-lessons/`, synced with Notion hub 📚Мой promt-engineering.

## Decision

1. **Capture hook** — `hooks/prompt-coach-capture.ps1` on every UserPromptSubmit
2. **State + gating** — `lib/prompt-coach/PromptCoach.ps1`, `CoachConfig.json`
3. **Always-on rule** — `rules/prompt-engineering-coach.mdc` checks readiness after major delivery
4. **Skill + template** — expanded `skills/prompt-engineering-coach/`, `templates/prompt-lesson/`
5. **Commands** — `prompt-coach-status.ps1`, `/prompt-lesson`

## Gating

- Auto lesson: ≥4 substantive prompts + ≥2 days since last lesson
- Forced: user says «урок промта» or `/prompt-lesson`
- Filter system noise (Plan mode, Cursor follow-ups)

## Consequences

- Lessons are infrequent by design
- Reload Window picks up new hook
- REQ-069–071 fully operational
