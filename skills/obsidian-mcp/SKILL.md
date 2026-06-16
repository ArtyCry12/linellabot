---
name: obsidian-mcp
description: >-
  Optional Obsidian vault PKM when user requests @obsidian or vault export.
  Primary memory is user-memory + AGENTS.md (Project Squad squad-memory).
  On-demand rule obsidian-mcp.mdc. Triggers: @obsidian, vault, PKM archive.
---

# Obsidian MCP — optional PKM

**Not the default memory layer.** Use when user explicitly wants vault notes or PKM export.

Primary stack (Project Squad): `user-memory` → `AGENTS.md` → `ai-tracking/`.

## When to use Obsidian

```
Работа в коде/чате
    → search vault (тема / проект / папка)
    → read если заметка есть
    → create | update | append | move | tag | link
    → (редко) delete дубликатов
    → 1 строка в ответе: что изменено в vault
```

## Структура заметок (defaults)

| Тип | Путь | Содержимое |
|-----|------|------------|
| Проект | `Projects/<имя>.md` или папка проекта в vault | Статус, стек, решения |
| Сессия / лог | `ai-tracking/YYYY-MM-DD.md` | Краткий changelog |
| Runbook | `Runbooks/<topic>.md` | MCP, деплой, env |
| Решение | секция в проектной заметке | Контекст → решение |

Если в vault уже есть структура — **следуй ей**.

## Автозахват — обязательно

- Решения, багфиксы, настройки MCP/skills/env (без секретов)
- Команды, ветки, деплои, «где остановились»

## Автозахват — не писать

- Пустой чат; API keys и пароли — **никогда**

## CRUD без спроса

Create / Update / Append / Move / Tag — **автоматически**. Delete — дубликаты и stubs; массовое удаление — **спросить**.

## Подключение (Cursor)

```json
"obsidian": {
  "url": "http://127.0.0.1:27123/mcp/",
  "headers": {
    "Authorization": "Bearer <API_KEY>"
  }
}
```

Ключ: Obsidian → Settings → Community plugins → **Local REST API** → API Key.

Проверка: `curl http://127.0.0.1:27123/` с заголовком `Authorization: Bearer <key>` → `"status": "OK"`.

## Workflow агента

1. Obsidian запущен — иначе один раз сообщи, догоняй sync позже.
2. Прочитай дескриптор MCP-инструмента перед вызовом.
3. **Read before write** — всегда перед update/delete.
4. **Не спрашивай** «сохранить в Obsidian?» — сохраняй сам после содержательной работы.
5. Пути — **vault-relative** (`Folder/Note.md`).
6. В конце ответа — 1 строка: что изменено в vault.

## Категории возможностей

### Заметки (CRUD)

- Чтение markdown + frontmatter + metadata
- Создание с защитой от перезаписи
- Обновление (replace / append)
- Удаление
- Информация о заметке (размер, слова, ссылки) без полного текста

### Поиск и навигация

- Полнотекстовый поиск (Obsidian query syntax)
- Поиск по тегам (`tag:project`)
- Поиск по пути (`path:Daily/`)
- По дате создания/изменения
- Список заметок и папок (рекурсивно)

### Организация

- Создание папок (включая вложенные)
- Перемещение заметок и папок
- Теги: list vault-wide, add/remove/update на заметке

### Ссылки

- Backlinks с контекстом
- Исходящие ссылки
- Поиск битых ссылок

### Obsidian UI и команды

- Открыть файл в Obsidian (`/open/{path}`)
- Выполнить command palette command (`/commands/{id}`)
- Periodic notes (daily/weekly) — если плагин настроен

### REST (если MCP-обёртки нет)

Базовый URL: `http://127.0.0.1:27123` + Bearer. OpenAPI: `https://127.0.0.1:27124/openapi.yaml`.

## Типовые сценарии

| Запрос пользователя | Действие |
|-------------------|----------|
| «Найди в заметках про X» | `search` / query tools |
| «Создай daily note» | periodic / create note в Daily/ |
| «Добавь тег #project» | read → update tags |
| «Что ссылается на эту заметку?» | backlinks |
| «Открой в Obsidian» | open command |
| «Сохрани итог чата в vault» | create_note в нужной папке |

## Ограничения (честно)

- Только **локальный** Obsidian; sync/web — отдельные продукты.
- Некоторые команды могут быть отключены в Settings → Local REST API (dangerous commands, blocklist).
- Self-signed HTTPS (27124) — в Cursor предпочтителен HTTP (27123).
- Большие vault: поиск/листинг могут занимать секунды — батчь запросы.

## Связанные правила

- `rules/obsidian-mcp.mdc` — always-on
- `rules/00-agent-orchestrator.mdc` — Obsidian в таблице MCP
- `rules/mcp-routing.mdc` — приоритет над memory/grep для vault
