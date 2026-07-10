# P3 — Manual test playbook

**Цель:** система **построена** — вам остаётся пройти чеклисты и подтвердить, что всё работает в реальности.

**Автопроверка перед стартом:**

```powershell
powershell -File commands/p3-ready-check.ps1
```

Ожидается: **0 FAIL** в `ai-tracking/P3-READY-*.md`.

---

## 0. Pre-flight (10 мин)

| # | Действие | Pass |
|---|----------|------|
| 0.1 | **Reload Window** в Cursor | [ ] |
| 0.2 | MCP: Apify + Magnific — Connect при первом вызове | [ ] |
| 0.3 | Project Manager: сохранить `C:\Users\Asus\.cursor` как `hub` | [ ] |
| 0.4 | `p3-system-test.ps1` — 0 failures | [ ] |

---

## 1. MCP & инфра (15 мин)

| # | Тест | Как | Pass |
|---|------|-----|------|
| 1.1 | Notion | Любой fetch страницы через MCP | [ ] |
| 1.2 | context7 | Запрос доки по библиотеке в чате | [ ] |
| 1.3 | PageSpeed | `pagespeed-audit.ps1 -Url https://okara.ai/` | [ ] |
| 1.4 | Browser | Открыть localhost или okara в side panel → snapshot | [ ] |
| 1.5 | Autopilot | `!auto тест` — hook добавляет AUTOPILOT context | [ ] |
| 1.6 | Magnificent | Один video prompt через MCP | [ ] |

---

## 2. Production Studio — unified live+AI (30–45 мин)

**Решение DEC-056:** один pipeline, модули `shared` / `ai-lvm` / `live-action`.

| # | Тест | Как | Pass |
|---|------|-----|------|
| 2.1 | Архитектура | Прочитать `production-studio/ARCHITECTURE.md` | [ ] |
| 2.2 | Brief | Скопировать `templates/production-studio/project-brief.md` в свою папку | [ ] |
| 2.3 | Script | `@production-studio` + REF-16 (hybrid live) | [ ] |
| 2.4 | Segments | Заполнить `segment-manifest.json` (track: hybrid) | [ ] |
| 2.5 | Transcribe | 10s клип → `transcribe-video.ps1` → SRT/txt | [ ] |
| 2.6 | Storyboard | `/storyboard` + SRT → dual prompts | [ ] |
| 2.7 | Live brief | `live-shoot-brief.md` для seg с track live/hybrid | [ ] |
| 2.8 | AI gen | Один сегмент → Magnificent или gemini (1 попытка) | [ ] |
| 2.9 | QC | `qc-gate.md` — отметить pass/fail | [ ] |

**Не обязательно для pass:** финальный рендер в DaVinci — только цепочка до QC.

---

## 3. Selling sites — CRO verify (20 мин)

| # | Тест | Как | Pass |
|---|------|-----|------|
| 3.1 | Чеклист | `docs/knowledge-base/SELLING-SITE-MANUAL-CHECKLIST.md` | [ ] |
| 3.2 | Lighthouse | `seo-audit.ps1 -Url <ваш или demo URL>` | [ ] |
| 3.3 | Browser | Snapshot hero + CTA после `npm run dev` | [ ] |
| 3.4 | design-stack | `@design-stack cro-review` на одной секции | [ ] |

**Demo URL (если нет своего):** `https://okara.ai/pricing` — только CRO-чтение, не клон.

---

## 4. SEO & hooks (10 мин)

| # | Тест | Pass |
|---|------|------|
| 4.1 | `seo-audit.ps1` отчёт создан | [ ] |
| 4.2 | `/autopilot сделай X` — slash работает | [ ] |
| 4.3 | PROMPT-HOOKS — фраза «P3 test» → `p3-system-test` | [ ] |

---

## 5. Squad & handoff (5 мин)

| # | Тест | Pass |
|---|------|------|
| 5.1 | Заполнить `templates/squad-handoff.md` для тестовой задачи | [ ] |
| 5.2 | `/project-squad` — 10 агентов, без agency spam | [ ] |

---

## 6. REQ-077 — integrity pass (15 мин)

| Область | Вопрос | OK |
|---------|--------|-----|
| SSOT | Нет дублирующих правил без sync | [ ] |
| MCP | mcp.json без секретов в git | [ ] |
| Skills | production-studio + design-stack открываются | [ ] |
| DEC-004 | Squad = 10 agents | [ ] |
| P1 tails | Google lite, не сломан hub | [ ] |
| P2 tails | 5 rules на месте | [ ] |
| P3 | Этот playbook + templates | [ ] |

---

## 7. Опционально (не блокирует P3)

| Item | Когда |
|------|-------|
| USER-*.md viral scripts | Когда загрузите |
| Full Google Trio / GSC | `ensure-google-mcp.ps1` |
| Реальный проект Okara | URL на homepage |
| LVM batch >3 segments | После первого успешного gen |

---

## Закрытие P3

Когда секции **0–6** отмечены:

1. Напишите в чат: **«P3 manual pass»** или отметьте в Notion.
2. Агент обновит `NOTION-EXECUTION-STATUS.md` → P3 closed.

**Артефакты:** сохраните заполненные brief/manifest/qc в **своей** папке проекта (не в hub git).
