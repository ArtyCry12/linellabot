# Linella Telegram Bot + Next.js Web App (MVP)

Production-ready MVP: **Next.js App Router** (Vercel) + **Telegraf** webhook, mock catalog (`data/products.json`), Glassmorphism / Bento UI, i18n RU / RO / EN.

## Стек

- Next.js 15, Tailwind CSS, Route Handlers
- Telegram: `BOT_TOKEN`, webhook `POST /api/webhook`
- Цвет бренда: `#e30613`, белый

## Локально

```bash
cd linellabotprojet
npm install
cp .env.example .env.local
```

Заполните `BOT_TOKEN` (от [@BotFather](https://t.me/BotFather)). Для локального теста веб-приложения:

```bash
npm run dev
```

Открыть: http://localhost:3000  

Telegram-хуки локально нужны только если проксируете HTTPS-туннелем (например `ngrok`); иначе тестируйте бота после деплоя.

## Переменные окружения (Vercel)

| Переменная | Обязательно | Описание |
|------------|--------------|----------|
| `BOT_TOKEN` | да | Токен бота |
| `NEXT_PUBLIC_APP_URL` | да (prod) | Полный HTTPS URL приложения, например `https://your-app.vercel.app` — нужен для **Web App** и кнопок |
| `WEBHOOK_SECRET` | нет | Если задан при `setWebhook`, Telegram шлёт заголовок `X-Telegram-Bot-Api-Secret-Token`; должно совпадать |

`VERCEL_URL` подставляется Vercel автоматически, но для Mini App нужен именно **`NEXT_PUBLIC_APP_URL`** без редиректов.

---

## Шаги: GitHub → Vercel

1. **Репозиторий на GitHub**  
   - Создайте репозиторий без README (или добавьте этот код).  
   - В каталоге проекта:
   ```bash
   git init
   git add .
   git commit -m "feat: Linella bot + web app MVP"
   git branch -M main
   git remote add origin https://github.com/<user>/<repo>.git
   git push -u origin main
   ```

2. **Vercel**  
   - [vercel.com](https://vercel.com) → New Project → Import Git repository.  
   - Framework: Next.js (определится автоматически).  
   - Укажите **Environment Variables**: `BOT_TOKEN`, `NEXT_PUBLIC_APP_URL`, при необходимости `WEBHOOK_SECRET`.

3. **После успешного деплоя**  
   Скопируйте домен вида `https://xxxx.vercel.app` и добавьте в `NEXT_PUBLIC_APP_URL` на Vercel → Redeploy.

---

## Webhook Telegram (BotFather + API)

Подставьте:

- `<TOKEN>` — ваш `BOT_TOKEN`
- `<URL>` — `https://<ваш-домен-vercel>/api/webhook`
- `<SECRET>` — случайная строка (равна `WEBHOOK_SECRET` в Vercel)

### Вариант A: браузер

Откройте в браузере (GET):

```
https://api.telegram.org/bot<TOKEN>/setWebhook?url=<URL>&secret_token=<SECRET>
```

Не забудьте URL-encode параметров если нужно.

### Вариант B: curl (PowerShell / bash)

```bash
curl "https://api.telegram.org/bot<TOKEN>/setWebhook" ^
  -d "url=<URL>" ^
  -d "secret_token=<SECRET>"
```

После этого в Vercel задайте `WEBHOOK_SECRET=<SECRET>` (уже указанному в запросе), иначе `POST /api/webhook` вернёт `401`.

### Проверка

```
https://api.telegram.org/bot<TOKEN>/getWebhookInfo
```

В ответе `url` должен совпадать с вашим `.../api/webhook`.

### Локальная разработка с туннелем

1. `ngrok http 3000` (или аналог).  
2. `NEXT_PUBLIC_APP_URL=https://<ngrok>.ngrok.io`  
3. `setWebhook` на `https://<ngrok>.ngrok.io/api/webhook`

---

## Функции бота (mock / без внешних AI API)

- `/start` — welcome `public/welcome.png`, выбор языка, Bento inline-меню (каталог Web App, рецепты, сканер, умный список).  
- **Нейро-рецепты** — случайный рецепт из `lib/recipes.ts`, кнопка Web App.  
- **Сканер чека** — фото → пауза 2 с → билет и ссылка на мини-игру.  
- **Умный список** — текст через запятую → поиск по `data/products.json` → кнопка оформления в Web App (`/checkout?ids=`).  

Состояние языка и режима списка хранится в **памяти процесса** (для serverless может сбрасываться между инвоками; для продакшена имеет смысл Redis / DB).

## Web App

- `/` — каталог с `data/products.json`, стекло / бенто.  
- `/game` — мини-игра «Ловец скидок» (canvas scratch), промокод **LINELLA5** (−5%) + условие чека от 300 lei.  
- `/checkout` — mock оформления по `ids` из бота.

---

## Лицензия

Демо для Linella; бренд и ассортимент — моки.
