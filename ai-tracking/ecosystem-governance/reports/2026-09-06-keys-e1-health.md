# E1 keys finalize — health 2026-09-06

## Facts

- Ping: ok (`keyStatus=ok`)
- Free chat: first attempt fell through to inkling **403** (forbid/fallback); retry → **ok** `z-ai/glm-5.2:free`
- TTS Fish: ok (via health test)
- STT: ogg multipart path failed (client 400). Wrapper switched to **JSON base64** `input_audio`. Ogg with `-BossYes` → **ok** `microsoft/mai-transcribe-2`
- Health artifact: `ai-tracking/openrouter-free-health.json` — `checkedAt=2026-09-05T22:50:53.0915046Z`, `ok=true`, `sttSkipped=false`

## Classification

| Signal | Meaning |
|--------|---------|
| 401 | dead key — stop |
| 429 | rate — not dead |
| 403 last free fallback | forbid — not dead key; do not SoT `dead` |
| STT MIME/multipart | client — not STT model dead |

## Residual (not keys fail)

- `lib/task-router/routes.json` note still `Task glm-5.2-high` → Router wave E4+
