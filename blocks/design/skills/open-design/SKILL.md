---
name: open-design
description: >-
  Open Design (nexu-io/open-design) — open-source Claude Design alternative.
  HTML prototypes, decks (PPTX/PDF), dashboards, mobile frames, motion/HyperFrames
  (MP4), images, DESIGN.md brand systems. Triggers: @open-design, @od, @huashu
  (legacy alias), prototype, deck, pptx, motion, infographic, landing mockup,
  HTML demo, design direction, design critique. Replaces huashu-design as the
  hub primary for non-React visual HTML pipelines. Not for production Next.js
  apps (use frontend-design + design-stack).
argument-hint: "[prototype|deck|dashboard|mobile|motion|critique] [brief]"
user-invocable: true
---

# Open Design

Ты — design engine поверх каталога **Open Design** (не «общий веб-кодер»).
Медиум = артефакт (прототип / deck / motion), HTML — инструмент.

**Upstream:** https://github.com/nexu-io/open-design  
**Локальный каталог:** `skills/open-design/repo/`  
**Обновление:** `powershell -File commands/ensure-open-design.ps1`

## Когда читать что

1. Прочитай **этот** SKILL.md (router).
2. Выбери **один** design-template или functional skill ниже и **прочитай его `SKILL.md` целиком** перед генерацией.
3. Если есть бренд — найди/создай `DESIGN.md` (см. `awesome-design-md` или `repo/design-systems` если подтянут полный клон). Без бренда — спроси или возьми starter `default` / `warm-editorial` из upstream README.

| Задача | Читать (относительно `repo/`) |
|--------|-------------------------------|
| Лендинг / marketing page / mockup | `design-templates/web-prototype/SKILL.md` |
| SaaS landing | `design-templates/saas-landing/SKILL.md` |
| Dashboard / KPI | `design-templates/dashboard/SKILL.md` или `live-dashboard` |
| Mobile / iPhone flow | `design-templates/mobile-app/SKILL.md` или `mobile-onboarding` |
| Deck / слайды / PPTX | `design-templates/guizang-ppt/SKILL.md` (default) или `html-ppt-*` |
| Motion → MP4 | `design-templates/hyperframes/SKILL.md` · skill `skills/video-hyperframes` |
| CSS motion loop | `design-templates/motion-frames/SKILL.md` |
| Самокритика 5 измерений | `design-templates/critique/SKILL.md` |
| Brand extract | `skills/brand-extract/SKILL.md` |
| Протокол каталога | `docs/skills-protocol.md` |

Корень шаблона: `C:/Users/artyo/.cursor/skills/open-design/repo/`.

## Workflow (кратко)

1. **Факты** — если задача про конкретный продукт/бренд: `WebSearch` / Exa до генерации (не выдумывай launch/specs).
2. **Шаблон** — скопируй seed из `assets/` выбранного template, не пиши CSS с нуля.
3. **DESIGN.md** — маппь токены в `:root` / seed variables.
4. **Один артефакт** — self-contained HTML (или HyperFrames composition → MP4).
5. **Critique** — перед сдачей прогон по checklist шаблона или `critique`.

## MCP / desktop

- **Installed:** `C:\Users\artyo\AppData\Local\Programs\OpenDesign\` · Start Menu «Open Design»
- **CLI:** `od` → `~\.local\bin\od.cmd` (Electron-as-Node)
- **Cursor MCP:** `open-design` in `~/.cursor/mcp.json` (`od mcp install cursor`)
- Daemon поднимается headless при первом MCP-вызове; UI: запусти Open Design из меню

Без daemon агент всё равно работает filesystem-only через templates в `repo/`.

## Не путать

| Нужно | Куда |
|-------|------|
| Production React/Next UI | `frontend-design` + `design-stack` / shadcn |
| Клон чужого сайта 1:1 | `clone-website` |
| React-блок из 21st.dev | `21st-design` |
| Только DESIGN.md бренда | `awesome-design-md` |

## Legacy

`@huashu` / «huashu» → этот скилл. Архив: `skills/_archive/huashu-design/`.
