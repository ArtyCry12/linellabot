---
name: Trust wallet connection hard fix
overview: Полностью убрать нестабильный QR/WalletConnect путь, перейти на Trust-only injected+deep-link подключение и проверить end-to-end flow покупки в testnet.
todos:
  - id: remove-rainbowkit-connect-path
    content: Убрать ConnectButton/RainbowKit wallet modal и исключить путь, который вызывает cuer/qr invalid border=0
    status: completed
  - id: implement-trust-only-connector
    content: Сделать кастомную кнопку подключения Trust Wallet через wagmi injected connector и mobile deep link fallback
    status: completed
  - id: add-guardrails-and-errors
    content: Добавить понятные состояния ошибок (нет extension, неверная сеть, отклонение подключения) и UX-подсказки
    status: completed
  - id: validate-testnet-buy-flow
    content: Проверить подключение, покупку токенов, обновление метрик и админ-действия в testnet
    status: completed
  - id: run-regression-checks
    content: Прогнать lint/test/build и smoke-проверку локального сценария
    status: completed
isProject: false
---

# План устранения проблемы подключения кошелька

## Что уже подтверждено
- Источник падения: путь WalletConnect QR в RainbowKit (`invalid border=0` из `cuer/qr`).
- Выбрана стратегия: **только Trust Wallet**, без QR/WalletConnect modal.
- Приоритет: mobile Trust Wallet; на desktop показываем корректную подсказку/флоу с extension.

## Этап 1 — Полностью отключить проблемный QR-путь
- Убрать использование RainbowKit modal (`ConnectButton`) из [frontend/components/Header.tsx](frontend/components/Header.tsx).
- Отключить провайдерную зависимость от RainbowKit UI в [frontend/app/providers.tsx](frontend/app/providers.tsx), оставив стабильный `WagmiProvider` + `QueryClientProvider`.
- Привести wallet-конфиг к Trust-only injected сценарию в [frontend/config/rainbow.ts](frontend/config/rainbow.ts) (или переименовать в `wagmi`-конфиг по факту).

## Этап 2 — Реализовать Trust-only подключение (без QR)
- Добавить кастомную кнопку/контрол в [frontend/components/Header.tsx](frontend/components/Header.tsx):
  - `connectInjected()` для Trust Wallet extension,
  - mobile fallback: deep link в Trust Wallet.
- Добавить явные состояния:
  - не найден injected provider,
  - неподдерживаемая сеть (предложение переключиться на BSC Testnet 97),
  - пользователь отклонил подключение.
- Исключить любые вызовы, которые могут инициировать QR рендер.

## Этап 3 — UX/защита от повторного бага
- Добавить «жёсткий guard» на Trust-only в клиентской логике (блокировать прочие wallets в UI).
- Добавить диагностические сообщения в toast/баннеры, чтобы ошибка была объяснима пользователю, а не runtime crash.
- Зафиксировать причину в документации проекта, чтобы при будущих обновлениях не вернуть RainbowKit modal случайно.

## Этап 4 — Полный аудит рабочего сценария
- Проверить реальный сценарий на testnet:
  - подключение кошелька,
  - покупка токенов за BNB,
  - обновление `Total quantity purchased / Sold / Available`,
  - доступность admin-панели и выполнение admin-транзакций.
- Прогнать регрессию: `npm run lint`, `npm run test`, `npm run build`, плюс смоук локально.

## Ожидаемый результат
- Runtime ошибка `invalid border=0` больше не воспроизводится.
- Подключение Trust Wallet стабильно работает в выбранной модели (injected + mobile deep link).
- Покупка и on-chain обновления проходят без сбоев в testnet.