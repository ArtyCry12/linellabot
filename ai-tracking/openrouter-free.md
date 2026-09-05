# OpenRouter models (hub) — канон

Искать в hub: этот файл · лестница [`ai-tracking/model-ladder.json`](model-ladder.json) (**SoT каталог**) · карта ключей [`ai-tracking/KEYS-MAP.md`](KEYS-MAP.md) · скилл `skills/openrouter-free/SKILL.md` · правило `rules/openrouter-free-routing.mdc` · тест `commands/openrouter-free-test.ps1` · здоровье `ai-tracking/openrouter-free-health.json` · блок в `AGENTS.md`.

Ключ: Windows user env `OPENROUTER_API_KEY`. Не в git. Не печатать. Не Override OpenAI Base URL.

## Источник правды

1. **`model-ladder.json`** — ранги, slug, `status` (live/dead/unknown/banned), modality.
2. **`openrouter-free-health.json`** — runtime (ключ, ping, per-model ok/dead/degraded). Без секрета.
3. Этот файл + SKILL + always-on + AGENTS — зеркала. При споре побеждает ladder.

## Зачем

Черновик (перевод пачками, сводки, глоссарий) — OpenRouter Rank 3 через обёртку, не жечь Opus/Grok/Sol. Volume-Task с тулами Cursor = `composer-2.5-fast`. Review = `cursor-grok-4.6-high`. **`glm-5.2-high` как worker запрещён** (это счётчик Cursor, не `:free`).

## Rank 3 — free (текст / TTS)

| Роль | Модель |
|------|--------|
| Текст primary | `z-ai/glm-5.2:free` |
| Текст + image/video in | `minimax/minimax-m3:free` |
| Текст + image/audio in | `thinkingmachines/inkling:free` |
| TTS | `fish-audio/s2.1-pro-free:free` |

Порядок текста: GLM → MiniMax → Inkling. Nemotron и Deepgram **удалены** из дефолтов.

## Rank 2 — mid (платный OpenRouter)

Только после **да Boss** (полуавто, спрашивает parent). Без ответа — нет HTTP. Вызов: `openrouter.ps1 … -BossYes` (обязательно). Без флага скрипт отказывает (`boss_yes_required`).

Порядок chat: `deepseek/deepseek-v4-pro-0813` → `z-ai/glm-5.3` → flash-slug’и → STT `microsoft/mai-transcribe-2` (`POST /api/v1/audio/transcriptions`).

429/5xx на Rank 2 → `degraded` в health → **стоп и спросить**. Не эскалировать самим.

## Субагенты

| Работа | Куда |
|--------|------|
| Текст без тулов | `openrouter.ps1 -Action chat` (ladder live) |
| Volume explore / inventory | Task `composer-2.5-fast` |
| Review / adversarial | Task `cursor-grok-4.6-high` |
| Cursor GLM 5.2 | **не звать** |
| Mid / STT | только parent после ответа Boss |

`inherit` модели чата на субагента **запрещён**.

Полуавто (только parent):

```text
Задача похожа на Rank N.
Предлагаю: <slug> — <одна строка>.
Берём / другой slug / этот ранг не используем?
```

Task/explore **не** зовут OpenRouter mid. Нужен mid — стоп, вернуть parent.

## Мультимодал

Понять файл через OR Rank 3 — только скрипт без тулов Cursor. Генерация фото/видео = Google Studio (отдельный контур). Не замена hub (Stitch, open-design, browser).

## Нет ключа / 401

- Текст без тулов: стоп, сказать Boss. Не inherit R1.
- Файлы/тулы: Composer.
- 401 = dead key (ротация User env + рестарт Cursor).

## Команды

```powershell
C:\Users\artyo\.cursor\commands\openrouter-free-test.cmd
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\artyo\.cursor\commands\openrouter-free-test.ps1
powershell -File skills/openrouter-free/scripts/openrouter.ps1 -Action ping
powershell -File skills/openrouter-free/scripts/openrouter.ps1 -Action chat -Prompt "..."
powershell -File skills/openrouter-free/scripts/openrouter.ps1 -Action tts -Prompt "..." -NoPlay
powershell -File skills/openrouter-free/scripts/openrouter.ps1 -Action stt -BossYes -AudioPath path.ogg
```

STT: JSON `input_audio` (base64 + format). Ogg/wav/mp3 ok. Parent may ffmpeg→temp wav if needed; do not mark STT `dead` for MIME/client skip.

## Health 2026-09-06

Ключ User env: `ok`. Ping/chat/TTS/STT green (`z-ai/glm-5.2:free`, Fish, `microsoft/mai-transcribe-2`). Разовый 403 на inkling fallback ≠ мёртвый ключ. Residual: `routes.json` note ещё может упоминать `glm-5.2-high` до волны Task Router.

## Не путать

- Ask AI клиента NLMedia (платный OpenRouter PAYG) — другой контур.
- Google Studio ≠ `google/gemini-3.8-flash` на OpenRouter.
