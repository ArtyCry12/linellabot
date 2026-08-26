# Плагины Cursor — выключить вручную

Cursor не даёт надёжно выключить плагин файлом на диске. Сделай в UI.

## Почему тосты в правом нижнем (2026-08-16)

Живой `mcp.json` — **профиль** (`core` = memory+gitnexus; часто `design` = +open-design/stitch/21st/context7). Тосты после Reload идут в основном **не от него**, а от **plugin MCP**.

После Reload Cursor параллельно поднимает **~20 plugin MCP**. Они не успевают за 30 секунд, пишут `Timeout waiting for EverythingProvider` и **сразу пробуют снова**. В логе за сегодня сотни таких ошибок. Плюс `An unknown error occurred`, когда нет DNS на `api2.cursor.sh`.

## Что выключить (шум)

Settings → Cursor Settings → Plugins (`Ctrl+Shift+J` → Plugins). Enabled = off:

- Canva, Postman, Webflow, HuggingFace, Braintrust, Firebase, Browse
- Cloudflare (builds / docs / bindings / observability) — четыре MCP сразу
- Resend, Figma, Apify, Notion — если не нужны сегодня
- Zapier, GitLab, Harness (если ещё включены)

## Что оставить

- **Exa**
- **Vercel** / **Supabase**, если пользуешься
- **Aikido**, если нужен скан кода
- **Superpowers** (skills, без MCP) — SECONDARY, не OS. Обновить в marketplace до 6.3.0. Не клонировать git.

Потом Reload Window. Кэш `plugins/cache/` не удалять.

Галочка: напиши «плагины выключены».
