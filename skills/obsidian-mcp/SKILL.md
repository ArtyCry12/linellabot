---
name: obsidian-mcp
description: >-
  Управление Obsidian vault через встроенный MCP Local REST API — чтение/запись
  заметок, поиск, теги, ссылки, команды, открытие в UI. Триггеры: @obsidian,
  vault, заметки, PKM, knowledge base, Obsidian. Always-on вместе с
  rules/obsidian-mcp.mdc. Требует запущенный Obsidian Desktop.
---

# Obsidian MCP

Прямое взаимодействие с **Obsidian Desktop** через плагин **Local REST API with MCP** (не веб-версия).

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

1. Убедись, что Obsidian запущен.
2. Прочитай дескриптор инструмента из `projects/.../mcps/<obsidian-server>/tools/*.json`.
3. Для правки заметки: **сначала прочитай** текущий контент, потом обновляй (избегай полной перезаписи без чтения).
4. После создания/изменения важных заметок — при необходимости вызови open в UI для проверки пользователем.
5. Имена путей — **vault-relative** (`Folder/Note.md`), без абсолютных путей Windows.

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
