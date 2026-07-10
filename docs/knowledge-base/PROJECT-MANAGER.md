# Project Manager extension (REQ-061)

**Extension:** [alefragnani.project-manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)  
**Installed:** 2026-07-10 via `code --install-extension alefragnani.project-manager` (v13.1.0)

## Зачем в Cursor Hub

| Задача | Как PM помогает |
|--------|-----------------|
| Hub vs клиент vs clone | Быстрое переключение без поиска папок |
| Handoff от Squad | Абсолютный путь в избранном = меньше ошибок |
| Коммиты / push | Один проект — одно окно Cursor |

## Рекомендуемые проекты (сохранить в PM)

| Tag | Path | Назначение |
|-----|------|------------|
| `hub` | `C:\Users\Asus\.cursor` | Система, rules, skills, MCP |
| `agents` | `C:\Users\Asus\.agents` | CLI agents skills mirror |

Добавляйте клиентские репо и выходы `clone-website` по мере появления.

## Горячие клавиши (по умолчанию)

- **Project Manager: List Projects to Open** — `Ctrl+Alt+P` (может отличаться; см. Keyboard Shortcuts)
- Side bar: иконка папки с закладкой

## Agent workflow

В каждом handoff (`templates/squad-handoff.md`) указывай:

```
Project path: C:\absolute\path\to\repo
PM tag: hub | client-name
```

Агент не полагается на PM MCP — extension для **человека**; путь в handoff — SSOT для агента.

## Связанные REQ

- REQ-061 ✓ documented + extension installed
- REQ-080 — пути не дублировать в rules без sync
