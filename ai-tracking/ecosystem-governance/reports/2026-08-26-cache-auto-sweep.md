# Cache auto-sweep — first dry-run (2026-08-26)

**Сущность:** hub OS cold cache sweep  
**Бриф:** Внедрена безопасная автоподчистка без kill процессов и без `cursor-system-cleanup.ps1`.

## Найденные проблемы (до)

- После сборок копился холодный мусор (temp hook payloads, numeric hub `projects/`, старые отчёты).
- Агрессивный cleanup в refresh переносил репы / `takeown` — нельзя в авто.
- CACHE-POLICY была слишком короткой и разрешала wipe npm-cache.

## Решение

| Артефакт | Роль |
|----------|------|
| `CACHE-POLICY.md` | Тиры T0–T3, hot-rule, circuit breakers |
| `commands/cache-auto-sweep.ps1` | Оркестратор dry-run / `-Apply` |
| `commands/cache-auto-sweep-install.ps1` | User tasks Idle T0 + 03:00 T1 |
| `cursor-system-refresh.ps1` | In-session только T0 `-Apply` |

## Выполненная работа

- Dry-run T0: OK (`cache-sweep-last.json`, `orphan-processes-last.json`).
- Scheduled tasks: `CursorHub-CacheAutoSweep-Idle`, `CursorHub-CacheAutoSweep-Nightly` — **DRY-RUN** (без `-Apply`).
- Orphans: 0 (report-only, never kill).
- Registry + SYSTEM-REGISTRY обновлены.

## Первый dry-run (снимок)

- Tier: T0, applyEffective: false
- Rows: ~214 (в основном `temp/cursor-hook-payload-*` старше 24ч + hub-safe-cleanup candidates)
- Freed: 0 MB (dry-run)
- Elapsed: ~61 s

## Ворота для Boss

1. Просмотреть `reports/cache-sweep-2026-08-26.md` и `cache-sweep-last.json`.
2. Если ок — `powershell -File commands/cache-auto-sweep.ps1 -Tier T0 -Apply` (ручной Apply).
3. Отдельный YES — `cache-auto-sweep-install.ps1 -Apply` чтобы задачи реально удаляли.

## Финальный результат

Подсистема готова в режиме dry-run. Сборки не ломает: hot `.next`/`.turbo` только в T1 и только для холодных проектов; процессы только в отчёте.
