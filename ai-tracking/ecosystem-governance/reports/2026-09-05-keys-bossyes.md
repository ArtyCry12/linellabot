# Keys / BossYes wave — 2026-09-05

**Status:** done. Key live after Boss rotate 2026-09-05; E1 health 2026-09-06 green (see `2026-09-06-keys-e1-health.md`).

## Сделано

| Артефакт | Изменение |
|----------|-----------|
| `skills/openrouter-free/scripts/openrouter.ps1` | `-BossYes`; mid / stt / Rank2 `-Model` без флага → exit 3 `boss_yes_required` |
| `commands/openrouter-free-test.ps1` | `-ProbeMid` / `-SttAudioPath` требуют `-BossYes` |
| `ai-tracking/KEYS-MAP.md` | шпаргалка OR-LLM / Studio / Google-Login |
| rule + SKILL + canon + SYSTEM-REGISTRY | ссылки и `-BossYes` |
| `agents/adversarial-hub-auditor.md` | `cursor-grok-4.6-high` |
| `agents/ecosystem-architect.md` | `cursor-grok-4.6-high` |
| `agents/dev-os-research.md` | `composer-2.5-fast` |
| `ADVERSARIAL-PIPEPLAN.md` | slug high, не xhigh |

Smoke: mid без `-BossYes` → `boss_yes_required`. stt без флага → то же.

## Не трогали

Router `routes.json`, Impeccable agents, коммит, значения секретов.

## Ждёт Boss

1. ~~Ротация ключа~~ — **ok** 2026-09-05 (User+Process, label set).
2. Mid probe: **ok** `deepseek/deepseek-v4-pro-0813`.
3. Free chat: 429/403 на цепочке free (лимит/запрет провайдера), TTS Fish **ok**.
4. STT: skip без wav (ожидаемо).
