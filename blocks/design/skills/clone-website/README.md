# clone-website (AI Website Cloner)

Глобальный скилл Cursor для клонирования сайтов в Next.js 16 + shadcn + Tailwind v4.

## Быстрый старт

1. Откройте **любую папку** в Cursor (пустую или существующий Next-проект).
2. В чате: `@clone-website https://example.com` или `/clone-website https://example.com`.
3. Если папка пустая — агент (или вы) запускаете:

```bash
node C:/Users/Asus/.cursor/skills/clone-website/scripts/init-clone-project.mjs .
cd .
npm install
npm run build
```

4. Нужен **cursor-ide-browser** MCP (включён в Cursor).

## Структура

| Путь | Назначение |
|------|------------|
| `SKILL.md` | Инструкции агента (читается автоматически по триггеру) |
| `template/` | Полный шаблон репозитория [ai-website-cloner-template](https://github.com/JCodesMore/ai-website-cloner-template) |
| `scripts/init-clone-project.mjs` | Копирует `template/` в целевую директорию |

## CLI agents

Копия скилла: `C:/Users/Asus/.agents/skills/clone-website/SKILL.md`

## Обновление skill из template

```bash
node C:/Users/Asus/.cursor/skills/clone-website/template/scripts/sync-skills.mjs
```

Источник правды: `template/.claude/skills/clone-website/SKILL.md` (синхронизируется с `SKILL.md` в корне скилла).
