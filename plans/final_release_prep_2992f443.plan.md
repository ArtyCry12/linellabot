---
name: Final release prep
overview: "Выполнить финальный оптимизированный аудит и довести проект до состояния: сборка/тесты проходят без ошибок, frontend не падает при prerender/SSR, расчёты корректны, лишний кеш очищен, затем поочередные git-коммиты и запуск локальной тест-версии для ручной проверки."
todos:
  - id: audit-1
    content: "Запустить full tests/coverage: hardhat clean+test+coverage, frontend lint+test+build и зафиксировать отсутствие ошибок."
    status: completed
  - id: fix-indexeddb
    content: "Убрать `indexedDB is not defined` при `next build`: динамическая загрузка Providers с `ssr:false` в layout."
    status: completed
  - id: fix-bignumber-ui
    content: "Сделать SaleCard валидации min/max/balance через BigInt (без Number rounding): расширить useTokenSale для min/max wei."
    status: completed
  - id: cleanup-cache
    content: Удалить лишние build/кеш директории перед коммитами; проверить .gitignore.
    status: completed
  - id: git-init-commit-1
    content: "Инициализировать git в flash-tokens-trust и сделать коммит #1 (smart-contract + scripts + tests)."
    status: completed
  - id: git-init-commit-2
    content: "Коммит #2 (frontend: config/hooks/components/layout/theme)."
    status: completed
  - id: git-init-commit-3
    content: "Коммит #3 (README + CI + финальная чистка)."
    status: completed
  - id: local-dev
    content: Запустить локальный `frontend` (next dev) и выдать вам адрес + чеклист ручной верификации.
    status: completed
  - id: env-setup
    content: Создать smart-contract/.env из .env.example и вывести вам команду/инструкцию куда вставить `PRIVATE_KEY` и `BSCSCAN_API_KEY`.
    status: completed
isProject: false
---

# Final release prep

## 0) Принятые решения

- Testnet deploy/Vercel preview сейчас не делаем: локальная проверка (next dev + build/test) до автодеплоя.
- Git делаем внутри [`c:\Users\Asus\.cursor\flash-tokens-trust`](c:\Users\Asus\.cursor\flash-tokens-trust) (отдельный репозиторий).
- `smart-contract/.env` требуется: у вас пока **нет** `PRIVATE_KEY` в файле, поэтому мы создадим `smart-contract/.env` из `.env.example` и вы заполните значения (мы напомним точные поля).

## 1) Текущий аудит (что уже подтверждено)

- Hardhat: `TokenSale.test.ts` проходит, включая reentrancy/pause/withdraw.
- Frontend: `npm run build` собирается после фиксов типов/SSR, но во время сборки встречались `ReferenceError: indexedDB is not defined` (это признак того, что часть RainbowKit/Wagmi-кода попадает в server/prerender контекст).

Цель финализации: убрать `indexedDB` ошибки, сделать расчёты в UI полностью BigInt-основанными (без `Number()`), подчистить кеш/мусор и гарантировать повторяемую сборку.

## 2) Создать/подготовить окружение для тестнета (без деплоя)

- Создать [`c:\Users\Asus\.cursor\flash-tokens-trust\smart-contract\.env`](c:\Users\Asus\.cursor\flash-tokens-trust\smart-contract\.env) на основе [`smart-contract/.env.example`](c:\Users\Asus\.cursor\flash-tokens-trust\smart-contract\.env.example).
- Оставить поля пустыми/placeholder-значениями **только внутри env**, затем пользователь заполняет:
  - `PRIVATE_KEY`
  - `BSCSCAN_API_KEY` (опционально для verify)
  - `TOKEN_ADDRESS` (для real token на тестнете) / или `USE_MOCK_TOKEN=true`

## 3) Полный прогон тестов/проверок (перед правками и после)

Выполнить команды:

### 3.1 Smart contract

- `cd c:\Users\Asus\.cursor\flash-tokens-trust\smart-contract`
- `npx.cmd hardhat clean`
- `npx.cmd hardhat test`
- `npx.cmd hardhat coverage`

### 3.2 Frontend

- `cd c:\Users\Asus\.cursor\flash-tokens-trust\frontend`
- `npm run lint`
- `npm run test`
- `npm run build`

Критерий готовности: **без** `indexedDB` ошибок и без failed compile/typecheck.

## 4) Исправление `indexedDB is not defined` (SSR/prerender стабильность)

Проблема проявилась при prerender/production build, значит часть кода RainbowKit вызывает indexedDB на сервере.

### Правка

- Переместить `Providers` в динамическую загрузку с `ssr:false`, чтобы серверный сборочный контекст вообще не импортировал RainbowKit/Wagmi.

Затрагиваемые файлы:

- [`c:\Users\Asus\.cursor\flash-tokens-trust\frontend\app\layout.tsx`](c:\Users\Asus\.cursor\flash-tokens-trust\frontend\app\layout.tsx)
- [`c:\Users\Asus\.cursor\flash-tokens-trust\frontend\app\providers.tsx`](c:\Users\Asus\.cursor\flash-tokens-trust\frontend\app\providers.tsx)

Ожидаемый результат: `npm run build` заканчивается без `ReferenceError: indexedDB is not defined`.

## 5) Улучшение стабильности UI: убрать ошибки из-за `Number()`

В [`frontend/components/SaleCard.tsx`](c:\Users\Asus\.cursor\flash-tokens-trust\frontend\components\SaleCard.tsx) текущие проверки disabled/лимитов вычислялись через `Number(bnbAmount)` и строковые formatted значения.

### Правка

- Использовать BigInt для:
  - сравнения `bnbWei < minWei`
  - сравнения `bnbWei > maxWei`
  - сравнения `bnbWei > userBnbWei`

Нужные данные:

- `useBalance` возвращает `value: bigint` — используем его.
- `useTokenSale` уже читает `getMaxPurchase()` и `getMinPurchase()` — расширим хук, чтобы отдавать `minPurchaseWei/maxPurchaseWei`.

Ожидаемый результат: невозможные к покупке значения блокируются строго по контрактной логике без округлений.

## 6) Кеш/мусор: ускорение и чистота репозитория

- Перед коммитами удалить:
  - [`frontend/.next`](c:\Users\Asus\.cursor\flash-tokens-trust\frontend\.next)
  - `smart-contract/artifacts/` и `smart-contract/cache/` (если не нужны для сборки)
- Проверить `.gitignore` на корректность (чтобы туда не попали node_modules, .next, artifacts).

## 7) Последовательные git-коммиты (поэтапно)

Создать git repo в [`c:\Users\Asus\.cursor\flash-tokens-trust`](c:\Users\Asus\.cursor\flash-tokens-trust) и сделать 3 коммита:

1) Smart contract + tests + scripts
2) Frontend (config/hooks/components/page/style)
3) README + CI + cleanup

После каждого коммита — повторный минимум:

- `smart-contract: npx.cmd hardhat test`
- `frontend: npm run build`

## 8) Открыть локальную тестовую версию (после последнего коммита)

- Запустить `frontend` в dev-режиме: `npm run dev`.
- Дать вам адрес (обычно `http://localhost:3000`) и чеклист ручной проверки:
  - Connect (Trust Wallet via WalletConnect)
  - Buy: min/max validation
  - Admin: pause/unpause, setRate, setMaxTokensPerTx, withdraw

## 9) Следующий шаг после вашей проверки

Если вы подтвердите, что всё работает стабильно:

- По вашему отдельному указанию выполню автодеплой/релиз (testnet deploy + sync env + возможно Vercel), включая повторный полный аудит в конце.
