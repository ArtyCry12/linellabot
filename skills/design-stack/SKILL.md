---
name: design-stack
description: >-
  Hub design stack — Tailwind, shadcn/ui, Iconify, fontsource, motion, CRO for
  selling sites. Registry-first; no copy-paste components. Triggers design stack,
  shadcn, landing page, selling site, daisyUI, framer-motion.
argument-hint: "[init | shadcn-add | cro-review | icons]"
user-invocable: true
---

# Design Stack (Cursor Hub)

**REQ:** 042–046 · Manifest: `docs/knowledge-base/DESIGN-STACK-MANIFEST.md`

## Base dependencies (new Next/React project)

```bash
npm i tailwindcss postcss autoprefixer class-variance-authority clsx tailwind-merge
npm i framer-motion lucide-react
npm i -D @fontsource-variable/inter @fontsource-variable/manrope
# optional: daisyUI, @iconify/react + JSON icon packs offline
```

Init shadcn: `npx shadcn@latest init` — then **always** search registry before custom UI.

## Registry-first workflow (REQ-045)

1. `context7` — confirm API for target lib version
2. `@21st-dev/magic` or shadcn plugin — `browse` / `search` registries
3. Install block via MCP URL (`shadcn add https://21st.dev/r/...`)
4. Adapt tokens to project `globals.css` — minimal diff

## Iconify (REQ-043)

- MCP: `iconify` → search by keyword
- Offline: `@iconify/react` + `@iconify-json/*` packs for production

## Selling-site CRO (REQ-046)

Structure independent of aesthetics:

| Element | Rule |
|---------|------|
| Hero | One promise + one primary CTA above fold |
| Social proof | Before pricing |
| Objections | FAQ or comparison before final CTA |
| Urgency | Honest only — no fake timers |
| Mobile | CTA thumb-reachable; tap targets ≥44px |

Review with `ui-ux-pro-max` or `awesome-design-md` when polish needed.

## Out of scope

- Full brand identity (use huashu-design)
- P3 selling sites lesson — `docs/knowledge-base/SELLING-SITES-LEARNING.md` (REQ-047–048)
