---
name: openrouter-free
description: >-
  Calls OpenRouter models from a local wrapper (not the Cursor model picker).
  Catalog SoT: ai-tracking/model-ladder.json (only status=live).
  Text free: z-ai/glm-5.2:free → minimax/minimax-m3:free → thinkingmachines/inkling:free.
  TTS: fish-audio/s2.1-pro-free:free. STT mid: microsoft/mai-transcribe-2 (Boss yes).
  Mid chat after Boss yes. Never Override OpenAI Base URL.
---

# OpenRouter models (wrapper)

Do **not** enable Cursor Override OpenAI Base URL. This skill is a script, not a picker model.

Key: Windows user env `OPENROUTER_API_KEY`. Never print it. Never write it into the repo.

**Whitelist:** call only slugs listed in `ai-tracking/model-ladder.json` that are not `status: banned` or `status: dead` (model delist/404). `unknown` and `live` are callable. Key auth 401 lives in health JSON — do **not** mark free text models `dead` for a bad key.

## When to run

Draft/routine text without Cursor tools → this wrapper (`-Action chat`). Voiceover ("озвучь", TTS) → `-Action tts`. STT → `-Action stt` only after Boss yes (Rank 2).

## Subagent override (boss rule)

Never `inherit` the chat model onto a Task subagent.

1. Text-only draft → this wrapper (`-Action chat`).
2. Subagent needs Cursor tools (volume) → Task `model: "composer-2.5-fast"`. **Not** `glm-5.2-high`.
3. Review / adversarial → Task `model: "cursor-grok-4.6-high"`.
4. Legal / pixel 1:1 / final QA → boss model unless Boss cheapens it.
5. Rank 2 mid/STT → **parent asks Boss**. After «да» in this chat, call wrapper with **`-BossYes`**. Task must not call mid. No answer = no HTTP. Without `-BossYes`, script exits `boss_yes_required`.

Полуавто (parent only):

```text
Задача похожа на Rank N.
Предлагаю: <slug> — <одна строка>.
Берём / другой slug / этот ранг не используем?
```

## Commands

Hub root: `C:/Users/artyo/.cursor`

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/openrouter-free/scripts/openrouter.ps1" -Action chat -Prompt "..."
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/openrouter-free/scripts/openrouter.ps1" -Action tts -Prompt "..." -NoPlay
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/openrouter-free/scripts/openrouter.ps1" -Action stt -BossYes -AudioPath "path.ogg"
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/openrouter-free/scripts/openrouter.ps1" -Action chat -Tier mid -BossYes -Prompt "..."
powershell -NoProfile -ExecutionPolicy Bypass -File "skills/openrouter-free/scripts/openrouter.ps1" -Action ping
```

Long text: `-PromptFile path`. Mid: `-Tier mid -BossYes` and/or Rank2 `-Model <slug> -BossYes`.

Chat/STT stdout is JSON. STT uses JSON `input_audio` (base64 + format: wav/mp3/ogg/…). Parent may `ffmpeg` → temp wav if API rejects a container; do not mark STT `dead` for MIME/client skip. TTS with `-NoPlay` does not open the player (tests).

## Models (mirror of ladder)

| Role | Model |
|------|--------|
| Text primary | `z-ai/glm-5.2:free` |
| Text multimodal | `minimax/minimax-m3:free`, `thinkingmachines/inkling:free` |
| Speech TTS | `fish-audio/s2.1-pro-free:free` |
| Speech STT (mid) | `microsoft/mai-transcribe-2` → `POST /api/v1/audio/transcriptions` |

Nemotron and Deepgram are **not** defaults.

## Missing key / 401

Stop text draft. Tell Boss to set/rotate `OPENROUTER_API_KEY` (User env) and restart Cursor. Files/tools → Composer. Do not inherit R1 for draft.

Health: `commands/openrouter-free-test.ps1`. Canon: `ai-tracking/openrouter-free.md`. Ladder: `ai-tracking/model-ladder.json`. Keys map (no secrets): `ai-tracking/KEYS-MAP.md`.
