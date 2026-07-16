---
name: Go-live finalization
overview: "Пошагово довести проект до состояния «готов к запуску»: полный аудит, стабилизация, финальная проверка блокчейна, затем деплой в новый Vercel-проект и контроль post-deploy."
todos:
  - id: full-audit-debug
    content: Провести полный read-only и debug аудит frontend/smart-contract/config и собрать P0/P1/P2
    status: completed
  - id: fix-and-stabilize
    content: Исправить найденные проблемы логики/конфигов, синхронизировать mainnet env и метрики
    status: completed
  - id: blockchain-diagnostics
    content: Проверить контрактный контур и e2e-поток покупки с авто+ручной валидацией Trust Wallet
    status: completed
  - id: new-vercel-project
    content: Создать новый Vercel-проект, применить env, выполнить production deploy и smoke API/UI
    status: completed
  - id: final-release-audit
    content: Повторный полный прогон качества и финальные логические коммиты без секретов
    status: completed
isProject: false
---

# Финальный план: аудит, стабилизация, релиз

## Зафиксированные решения
- Деплой в **новый Vercel-проект** (автоматически).
- Секреты использовать **как есть сейчас**.
- Финальный запуск сразу в **BSC Mainnet (56)**.
- Минимум покупки оставить **1 токен**.

## Что уже подтверждено в проекте
- Mainnet deployment записан в [smart-contract/deployed-contract.json](smart-contract/deployed-contract.json).
- Минимум покупки = 1 в [smart-contract/contracts/TokenSale.sol](smart-contract/contracts/TokenSale.sol).
- Cron в Vercel сейчас daily (`0 0 * * *`) в [frontend/vercel.json](frontend/vercel.json) из-за лимита Hobby.
- Админ-панель и серверные admin API уже есть: [frontend/components/AdminPanel.tsx](frontend/components/AdminPanel.tsx), [frontend/app/api/admin/auth/route.ts](frontend/app/api/admin/auth/route.ts), [frontend/app/api/admin/apply-config/route.ts](frontend/app/api/admin/apply-config/route.ts).

## Этап 1 — Полный технический аудит (read-only + debug)
- Проверить структуру и критические контуры:
  - frontend runtime/SSR API, кошелёк, sale flow, monitor flow.
  - smart-contract инварианты покупки, лимитов, owner-операций.
- Проверить ключевые риски недопонимания:
  - Available с owner-кошелька vs фактический inventory контракта.
  - Совпадение chainId, адресов, decimals, rate и max.
  - Поведение при пустом inventory, pause, invalid input, stale env.
- Результат: consolidated debug-отчёт с приоритетами P0/P1/P2 и конкретными правками.

## Этап 2 — Исправления и стабилизация
- Устранить найденные P0/P1 проблемы в логике и конфигурации.
- Дочистить только безопасный мусор (кэш/артефакты), не затрагивая рабочие данные.
- Синхронизировать env/адреса для mainnet через [scripts/sync-frontend-env.mjs](scripts/sync-frontend-env.mjs).
- Проверить, что UI и API показывают непротиворечивые метрики.

## Этап 3 — Полная диагностика блокчейн-контура
- Локально:
  - hardhat tests,
  - контрактные read-проверки в mainnet,
  - проверка admin-операций (безопасно, без лишних tx).
- E2E:
  - автоматический Playwright-аудит,
  - ручной чеклист Trust Wallet для подписания критичных транзакций (owner approve/deposit и 1 тест-покупка).
- Подтвердить:
  - покупка проходит,
  - BNB списывается,
  - токены приходят,
  - метрики обновляются без NaN/расхождений.

## Этап 4 — Новый Vercel-проект и деплой
- Создать новый проект в Vercel CLI и привязать root к [frontend](frontend).
- Применить env (runtime + build) и перепроверить cron/авторизацию cron endpoint.
- Сделать production deploy, проверить:
  - `/` отвечает 200,
  - `/api/monitor` отвечает 200,
  - админ-auth работает,
  - mainnet-адреса и chainId корректны.
- Если включена Deployment Protection, настроить доступ, чтобы вы видели сайт публично.

## Этап 5 — Финальный release-аудит перед handoff
- Повторный полный прогон:
  - lint/test/build,
  - Playwright,
  - мониторинг/cron,
  - smoke mainnet flow.
- Финальные коммиты по логическим блокам (поэтапно, без секретов и без лишних артефактов).
- Подготовить короткий запускной пакет:
  - production URL,
  - final contract addresses,
  - что делать вам только при необходимости (1-2 ручных шага в Trust Wallet).

```mermaid
flowchart TD
  auditFull[FullAuditAndDebug] --> fixStabilize[FixAndStabilize]
  fixStabilize --> chainDiag[BlockchainDiagnostics]
  chainDiag --> deployVercel[NewVercelProjectDeploy]
  deployVercel --> finalAudit[FinalReleaseAudit]
  finalAudit --> handoffReady[ReadyToLaunch]
```

## Данные, которые могу запросить по ходу (если обнаружу блокер)
- Только если реально потребуется: подтверждение owner-транзакции в Trust Wallet или дополнительный RPC endpoint при нестабильном публичном RPC.
- Все остальные шаги выполняю самостоятельно и автоматически.