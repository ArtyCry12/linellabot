---
name: alchemy-referral-migration
overview: Заменить Moralis на Alchemy Webhooks для события покупок и полностью автоматизировать раскладку env/секретов из существующих локальных переменных в Vercel/Supabase/бот без ручных шагов.
todos:
  - id: migrate-webhook-parser
    content: Перевести parser/verification webhook с Moralis на Alchemy в API и lib
    status: completed
  - id: preserve-performance-idempotency
    content: Сохранить dedupe/скорость обработки и добавить fallback/диагностику
    status: completed
  - id: automate-env-rollout
    content: Расширить скрипт авто-upsert env и автоматизировать bootstrap env для telegram-bot
    status: completed
  - id: update-docs-env-example
    content: Обновить docs и .env.example под Alchemy
    status: completed
  - id: validate-end-to-end
    content: Сделать build, webhook smoke и Playwright-проверку после раскладки env
    status: completed
isProject: false
---

# План миграции Moralis → Alchemy + авто-деплой

## 1) Перевести ingestion событий на Alchemy Webhooks
- Заменить Moralis-специфичные части в [frontend/lib/referral/moralis.ts](c:/Users/Asus/.cursor/flash-tokens-trust/frontend/lib/referral/moralis.ts):
  - сделать провайдер-нейтральный parser/validator (`webhook-events.ts`) с поддержкой формата Alchemy.
  - добавить проверку подписи Alchemy (`X-Alchemy-Signature`) через новый env (`ALCHEMY_WEBHOOK_SIGNING_KEY`).
- Обновить endpoint [frontend/app/api/webhooks/purchase/route.ts](c:/Users/Asus/.cursor/flash-tokens-trust/frontend/app/api/webhooks/purchase/route.ts):
  - убрать зависимость от Moralis headers/secret,
  - принимать Alchemy payload,
  - сохранить текущую идемпотентность по `tx_hash` через уже существующий `creditPurchaseFromWebhook`.

## 2) Сохранить скорость и качество обработки
- Не менять бизнес-логику начислений в [frontend/lib/referral/referral.ts](c:/Users/Asus/.cursor/flash-tokens-trust/frontend/lib/referral/referral.ts) (10%, dedupe, баланс/withdraw).
- Добавить fallback-режим при временной деградации webhook:
  - опциональный backfill через RPC (по tx hash из payload, если часть полей отсутствует),
  - безопасный early-return без двойного начисления.
- Добавить логирование причин reject/skip (подпись, неизвестный формат, пустые логи) для мониторинга качества доставки.

## 3) Полностью автоматизировать env/секреты из existing env
- Расширить [scripts/refresh-vercel-production-env.mjs](c:/Users/Asus/.cursor/flash-tokens-trust/scripts/refresh-vercel-production-env.mjs):
  - включить referral/env ключи в auto-upsert (production/preview/development),
  - добавить Alchemy-переменные: `ALCHEMY_API_KEY`, `ALCHEMY_WEBHOOK_SIGNING_KEY`,
  - удалить/деактивировать Moralis-ключи (`MORALIS_WEBHOOK_SECRET`) из целевого набора.
- Источник значений — только уже существующие переменные в `.env.local` / `.env.production.local` / процесс окружения (как вы выбрали: `from_existing_env`).
- Добавить отдельный скрипт bootstrap для окружений бота (`telegram-bot/.env` из существующих root/frontend env), чтобы не заполнять вручную.

## 4) Обновить документацию и операционный runbook
- Заменить [docs/referral/MORALIS_SETUP.md](c:/Users/Asus/.cursor/flash-tokens-trust/docs/referral/MORALIS_SETUP.md) на Alchemy setup guide (или переименовать в `ALCHEMY_SETUP.md`):
  - создание webhook,
  - фильтр по `TokenSale` + `TokensPurchased`,
  - URL endpoint,
  - signing key.
- Обновить [frontend/.env.example](c:/Users/Asus/.cursor/flash-tokens-trust/frontend/.env.example):
  - убрать Moralis ключ,
  - добавить Alchemy ключи,
  - оставить остальные referral/telegram поля.

## 5) Верификация и приемка
- Build/typecheck: `npm run build` в `frontend`.
- Smoke webhook:
  - тестовый payload Alchemy в `/api/webhooks/purchase`,
  - проверка, что `ref_purchases` и `ref_earnings` обновляются 1 раз на tx.
- Деплой env скриптом и повторная валидация:
  - сравнение фактических env в Vercel,
  - повторный e2e прогон `npm run audit:playwright`.

## Критерии готовности
- Moralis полностью не используется в коде/доках/env.
- Начисления referral работают с Alchemy без просадки по времени обработки.
- Все нужные переменные автоматически разложены из existing env без ручного ввода.
- Текущий sale/referral функционал не деградировал.