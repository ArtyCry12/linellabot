# KEYS-MAP — куда что класть (без секретов)

Канон лестницы моделей: [`model-ladder.json`](model-ladder.json) · health: [`openrouter-free-health.json`](openrouter-free-health.json).  
Значения ключей **не** пишем сюда и **не** в чат.

## Три ярлыка (не путать)

| Ярлык | Env / файл | Зачем | Сейчас |
|-------|------------|-------|--------|
| **OR-LLM** | Windows **User** env `OPENROUTER_API_KEY` | Весь LLM через OpenRouter: Rank3 free + Rank2 mid/STT | Один ключ на free и mid |
| **Studio** | User env `GEMINI_API_KEY` и `GOOGLE_API_KEY` | Google AI Studio → Gemini MCP (когда включишь design) | **Пока не ставим.** Часто **один** ключ с aistudio.google.com в оба имени |
| **Google-Login** | `ai-tracking/secrets.local.json` → `GOOGLE_OAUTH_*` | Будущий Gmail/Drive/GSC OAuth | **Не удалять** при чистке LLM |

Не путать:

- OpenRouter slug `google/gemini-…` = OR-LLM (тот же `OPENROUTER_API_KEY`), не Studio.
- `GOOGLE_OAUTH_*` = Google-Login, не Studio.
- PageSpeed / другие Google API — отдельные имена, не этот файл.

## OR-LLM — ранги и команды

| Ранг | Модели (кратко) | Env | Команда |
|------|-----------------|-----|---------|
| R3 free | GLM 5.2 → MiniMax → Inkling; TTS Fish | `OPENROUTER_API_KEY` | `openrouter.ps1 -Action chat` / `tts -NoPlay` / `ping` |
| R2 mid | DeepSeek / GLM 5.3 / Gemini flash OR | тот же ключ | `-Action chat -Tier mid` **и** `-BossYes` |
| R2 STT | `microsoft/mai-transcribe-2` | тот же ключ | `-Action stt -AudioPath …` **и** `-BossYes` |
| Cursor volume | `composer-2.5-fast` | Cursor счётчик | Task model |
| Cursor review | `cursor-grok-4.6-high` | Cursor счётчик | Task model |
| banned | `glm-5.2-high` | — | не звать |

Железный замок: без `-BossYes` mid / STT / `-Model` из Rank2 → exit 3, `boss_yes_required`.  
В чате «да» на mid = parent может поставить `-BossYes` в том же ходе.

## Studio — слоты на потом (ключ не ставим сейчас)

| Имя | Обычно |
|-----|--------|
| `GEMINI_API_KEY` | ключ AI Studio |
| `GOOGLE_API_KEY` | тот же ключ (алиас для библиотек) |

Live `mcp.json` (core) сейчас без gemini. Пример: `mcp.json.example` → сервер `gemini`.

## Google-Login — не трогать

Имена в `secrets.local.json`: `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`, `GOOGLE_OAUTH_CREDENTIALS_PATH`.

## Router (парковка)

`lib/task-router/routes.json` route `openrouter-free` aligned 2026-09-06: volume = `composer-2.5-fast`, never Task `glm-5.2-high` as free; mid/STT = `-BossYes`.

## Куда класть OR ключ руками

1. Win+S → «Переменные среды» → **пользователя** (не системы).
2. `OPENROUTER_API_KEY` = новый ключ (без кавычек).
3. Полностью закрыть Cursor → открыть.
4. В чат: «ключ поставил» (без значения).
5. Проверка: `commands/openrouter-free-test.cmd` или `openrouter.ps1 -Action ping`.

Не класть ключ в: git, чат, `secrets.local.json`, `mcp.json`, этот файл.
