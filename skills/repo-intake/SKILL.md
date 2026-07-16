---
name: repo-intake
description: >-
  Auto-analyze dropped repos (GitHub URL, zip, local path). Scout, classify,
  propose 3 actions — user picks. No repeated "what to do with repo" questions.
  Triggers: github.com link, @path to repo, .zip, "репозиторий", /repo.
argument-hint: "[path or URL]"
user-invocable: true
---

# Repo Intake — бросил репо → разбор → выбор

**Не спрашивай** «что сделать с репозиторием?» — **сразу scout + меню**.

## Триггеры

- `https://github.com/...` / `gitlab.com` / `.git`
- `@C:\path\to\repo` или `@./folder`
- `.zip` архив с кодом
- Слова: «репозиторий», «repo», «этот проект» + путь/URL
- `/repo` slash

## Алгоритм (всегда)

### 1. Scout (2–5 мин, без правок)

| Что | Как |
|-----|-----|
| README, AGENTS.md, SKILL.md | Read |
| Стек | package.json, pyproject.toml, go.mod, Cargo.toml |
| Тип | skill / app / hub-tool / template / docs-only / unknown |
| Риск | secrets, huge node_modules, binary junk |

Subagent `squad-scout` если репо большое.

### 2. Классификация

| Тип | Сигналы |
|-----|---------|
| **skill-candidate** | SKILL.md, .cursor/skills, agentskills |
| **hub-integrate** | MCP, cursor rules, orchestration |
| **client-app** | Next.js, Vite, app/ src/ |
| **clone-template** | clone-website, website template |
| **knowledge-extract** | awesome-list, docs, patterns only |
| **run-as-is** | готовый продукт, docker-compose |

### 3. Меню — всегда 3 варианта

Шаблон: `templates/repo-intake/MENU-TEMPLATE.md`

- **A (рекомендую)** — лучший вариант по scout
- **B** — альтернатива
- **C** — минимум (только знания / пропустить)

**Жди выбор:** `A`, `B`, `C` или «делай A».

Исключение: пользователь уже написал `!auto` + репо → выполни **A** без вопросов, если confidence **high**.

### 4. После выбора

| Выбор | Действие |
|-------|----------|
| A skill | `skills/<name>/`, index, task-router route |
| A hub | rules + registry + mcp.json.example note |
| A client | `C:\Users\Asus\projects\`, PM extension, отдельный workspace |
| A knowledge | `docs/knowledge-base/` или `ai-tracking/dev-os/research/sources/` |
| C skip | краткий summary в чат, без файлов |

`Register-CoachMilestone -Label "repo-intake: <name>"` после крупной интеграции.

## Анти-паттерны

- «Что вы хотите сделать?» без scout
- Копировать весь репо в `.cursor/skills/` без классификации
- Коммит без выбора пользователя (кроме `!auto` + high confidence)

## Связи

- `agents/squad-scout.md` · `skills/project-squad/`
- `docs/knowledge-base/FOUNDATION-REPOS.md`
- `commands/install-agency-agents.ps1` — паттерн для массовых personas
