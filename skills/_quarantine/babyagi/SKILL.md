---
name: babyagi
description: >-
  Creative autonomous task loop adapted from yoheinakajima/babyagi. Use for
  open-ended ideation, brainstorming pipelines, and self-expanding task lists
  when the user wants agent creativity (not a single fixed deliverable).
  File-backed loop in ai-tracking/creative-loop/. Triggers: babyagi, creative
  loop, brainstorm tasks, agent creativity, expand tasks.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
  source: https://github.com/yoheinakajima/babyagi
when_to_use: creative_ideation, open_ended_objective, task_expansion
argument-hint: "[objective or session id]"
---

# BabyAGI — Cursor creative loop

Sources:
- **Classic loop** (Mar 2023): objective → task list → execute → spawn new tasks → repeat — [archive](https://github.com/yoheinakajima/babyagi_archive)
- **Modern repo**: self-building `functionz` framework — **not installed in hub** (experimental Python)

## Hub adaptation

File-backed **creative loop** for Cursor agent sessions:

```
Objective → seed tasks → execute next → complete + result → expand (optional) → repeat
```

Storage: `ai-tracking/creative-loop/sessions/<sessionId>/`

| File | Role |
|------|------|
| `manifest.json` | objective, task queue, status |
| `results.jsonl` | completed task outputs |

## When to use

- Open-ended creative work: campaigns, naming, content angles, product ideas
- User asks for **brainstorm**, **creative agent**, **babyagi**, **expand tasks**
- Multiple iterations before a deliverable exists

**Skip** when: `!auto` with fixed deliverables, single SEO audit, or crew-plan already defines steps.

## Agent loop (each turn)

1. **Init** (once):
   ```powershell
   powershell -File commands/creative-loop.ps1 -Action init -Objective "<goal>" -Context "<constraints>"
   ```
2. **Next task**:
   ```powershell
   powershell -File commands/creative-loop.ps1 -Action next -SessionId <id>
   ```
3. Do the work in chat (use huashu-design, awesome-prompts, crew-ai as needed).
4. **Complete**:
   ```powershell
   powershell -File commands/creative-loop.ps1 -Action complete -SessionId <id> -TaskId t1 -Result "<summary>"
   ```
5. **Expand** (spawn follow-ups from results):
   ```powershell
   powershell -File commands/creative-loop.ps1 -Action expand -SessionId <id> -TasksJson '[{"description":"..."}]'
   ```
6. Repeat until `next` returns empty or user stops.

## Limits

- Default **max 12 tasks** per session (anti runaway)
- No auto-deploy, publish, or commit
- Pair with **llm-council** for evaluating creative options; **crew-ai** to execute a finalized pipeline

## CLI

```powershell
powershell -File commands/creative-loop.ps1 -Action list
powershell -File commands/creative-loop.ps1 -Action status -SessionId <id>
```

## Связи

- `rules/babyagi.mdc`
- `skills/crew-ai/SKILL.md` — after ideation crystallizes
- `skills/llm-council/SKILL.md` — multi-angle review
