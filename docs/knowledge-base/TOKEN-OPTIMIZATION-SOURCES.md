# Token optimization sources

Справочник стратегий экономии токенов. **Runtime в hub** — только то, что реально сжимает контекст в Cursor. Остальное — ссылки для чтения по задаче.

## Установлено в hub (runtime)

| Инструмент | Зачем | Путь |
|------------|-------|------|
| **MarkItDown** | PDF/Office/HTML → md (−60–80% на документах) | `commands/ensure-markitdown.ps1`, hook `markitdown-intake.ps1` |
| **RTK** | Сжатие вывода git/test/grep в Shell | `tools/rtk/rtk.exe`, hook `rtk-cursor-hook.ps1` |
| **tiktoken** | Точный подсчёт токенов в prompt-coach | `lib/prompt-coach/count_tokens.py` |
| **GitNexus** | Код-граф вместо grep по всему репо | MCP `user-gitnexus` |
| **graphify** | Структура репо без полного листинга | `skills/graphify/` |
| **task-router** | ≤2 маршрута на промпт, on-demand rules | `lib/task-router/` |
| **prompt-coach** | Water level + метрики промптов | `lib/prompt-coach/`, `Measure-PromptWater` |
| **awesome-prompts** | Шаблоны без загрузки всего корпуса | `lib/awesome-prompts/` (index + match) |

## Уже есть — не дублировать

| Запрошенное | Уже в hub |
|-------------|-----------|
| JCodeMunch / code RAG | GitNexus + graphify |
| Context selection | task-router (35 routes) |
| Prompt trimming | prompt-coach + `Measure-PromptWater` |
| Local prompt templates | awesome-prompts (659) |

## Отложить / reference-only

| Инструмент | Почему не в hub |
|------------|-----------------|
| **LangChain, LlamaIndex** | Python app frameworks; hub = hooks/MCP/skills |
| **Microsoft Guidance** | DSL для генерации; редко в agent flow |
| **Headroom, LeanCTX, Openwolf** | Overlap с RTK + риск лишнего proxy |
| **Chroma, Milvus, Weaviate, FAISS** | Свой RAG-проект; hub использует Exa + memory |
| **PyTorch, transformers, llama.cpp** | ML inference вне scope agent-hub |

## Внешние каталоги (читать, не ставить)

| Репо | Ссылка | Использование |
|------|--------|---------------|
| awesome-llm-token-optimization | https://github.com/ahkai/awesome-llm-token-optimization | Идеи и чеклисты |
| ECC harness | https://github.com/affaan-m/ECC | Адаптировано в `TOKEN-MEMORY-POLICY.md` |
| Karpathy guidelines | `rules/karpathy-guidelines.mdc` | Минимальные диффы, verify loops |

## Порядок применения

1. **Документ в промпте** → MarkItDown hook (md, не бинарник)
2. **Shell с длинным выводом** → RTK preToolUse (уже в hooks.json)
3. **Навигация по коду** → GitNexus query/context, не массовый grep
4. **Длинный промпт** → prompt-coach water + tiktoken в метриках
5. **Исследование** → один web MCP (Exa), один SKILL.md

## Проверка

```powershell
powershell -File commands/markitdown-test.ps1
powershell -File commands/rtk-test.ps1
powershell -File commands/ensure-rtk.ps1
powershell -File commands/hub-learning-test.ps1
```

Reload Window после правок `hooks.json`.
