# Model hierarchy wave — 2026-09-04

**Status:** executed (PASS-WITH-RESIDUALS)  
**Key:** User env `OPENROUTER_API_KEY` present → **401 unauthorized** (dead auth). Rank 2 / STT **not** probed (Q3).

## Сущность

Иерархия моделей хаба: Rank1 Cursor / Rank2 OpenRouter mid / Rank3 free + wrapper STT/TTS.

## Бриф

Убрали «Task glm-5.2-high = free». Volume = Composer. Never inherit. Полуавто Rank2 — только parent. Ladder = SoT.

## Проблемы

1. Ключ OpenRouter 401 — `keyStatus=dead`. Ротация User env + рестарт Cursor. Модели Rank3 **не** помечены dead за ключ.
2. Residual: `lib/task-router/routes.json` note ещё про glm-5.2-high (волна Router).
3. Residual: `agents/adversarial-hub-auditor.md` slug `xhigh`; `agents/*.md` inherit.
4. Residual: wrapper `-Tier mid` / `-Action stt` без CLI-гейта — политика в always-on (parent only).
5. `plans/**` история не чистилась.

## Adversarial disk (после execute)

Аудитор: [diff-audit](b131ff77-52cc-4f77-9442-a5454405f53e) → PASS-WITH-RESIDUALS.  
Правки после аудита: ladder GLM снова `unknown` (не dead за ключ); SKILL whitelist = not banned/dead; health `keyStatus`; SYSTEM-REGISTRY L42.

## Решение / работа

| Артефакт | Статус |
|----------|--------|
| `ai-tracking/model-ladder.json` | создан |
| `ai-tracking/openrouter-free.md` | обновлён |
| `rules/openrouter-free-routing.mdc` | Composer / never inherit / полуавто |
| `AGENTS.md` openrouter-блок | зеркало |
| `skills/openrouter-free/SKILL.md` | whitelist = ladder |
| `skills/openrouter-free/scripts/openrouter.ps1` | chat/tts/stt/ping, `-NoPlay`, `-Tier mid`, без Nemotron/Deepgram |
| `commands/openrouter-free-test.ps1` | health + models map; STT skip без файла |
| `ai-tracking/openrouter-free-health.json` | 401 dead |
| `SYSTEM-REGISTRY.md` | ladder path |
| `registry.json` | `canon.modelLadder` |

Не трогали: `routes.json` тело, MCP, security, Asus, `plans/**`, `CLAUDE.md`, `agents/*.md`.

## Порядок проверки

1. Stub ladder → ping+R3 chat → 401 зафиксирован.
2. Канон/правило/AGENTS/SKILL/SYSTEM-REGISTRY.
3. Wrapper + test (`stt` без `-AudioPath` → skip exit 2).
4. Mid/STT probe — **ждёт да Boss**.
5. Adversarial на diff — в этой сессии.
6. Registry + этот отчёт.

## DoD

- [x] Нет «Task glm = free» в always-on / AGENTS / SKILL
- [x] Never inherit; mid только после ответа parent (docs; CLI без гейта = residual)
- [x] Ladder SoT; SKILL = не banned/dead из ladder
- [x] Nemotron/Deepgram вычищены из wrapper
- [x] STT через transcriptions; skip без файла
- [x] Health per-model + keyStatus; execute ping без R2
- [x] `canon.modelLadder` в registry
- [x] Residuals задокументированы
- [x] Google Studio не трогали
- [ ] Живой ping/chat после ротации ключа — ждёт Boss

## Дальше

1. Ротировать `OPENROUTER_API_KEY` (User env) → закрыть Cursor → открыть → `openrouter-free-test.cmd`.
2. Сказать «да» на probe Rank2/STT — тогда `-ProbeMid` / `-SttAudioPath`.
3. Волна Task Router (починить note в `routes.json`).
4. Коммит — только если Boss скажет.
