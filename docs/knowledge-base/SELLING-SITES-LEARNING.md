# Selling sites — one-session learning plan (REQ-047–048)

**Goal:** Agent builds conversion-focused pages even when it cannot *see* the rendered result — explicit rules + verification loop.

**Skill base:** `skills/design-stack` § CRO · `@clone-website` for emulation

---

## Session outline (~90 min equivalent)

| Block | Topic | Hub artifact |
|-------|-------|--------------|
| 1 | Hook + promise above fold | design-stack CRO table |
| 2 | Social proof before price | REF patterns in marketingskills `cro` |
| 3 | Objection handling (FAQ, compare) | shadcn FAQ accordion blocks |
| 4 | CTA hierarchy (primary vs secondary) | One primary per viewport |
| 5 | Mobile thumb zone | 44px targets, sticky CTA |
| 6 | AI blindspot fixes (REQ-048) | Screenshot verify + browser MCP |

---

## REQ-048 — AI design blindspots

| Problem | Fix |
|---------|-----|
| Agent can't see output | `cursor-ide-browser` snapshot after build |
| Generic gradients | Registry-first blocks from 21st/shadcn |
| Weak hierarchy | Limit 2 font sizes in hero; one accent color |
| Fake urgency | Ban countdown unless real offer |
| Inaccessible contrast | Check with Lighthouse accessibility score |

**Verification loop:** `npm run dev` → browser snapshot → CRO checklist pass/fail.

---

## Curated references (study, don't copy)

| Source | Use for |
|--------|---------|
| `marketingskills` → cro, copywriting, signup | Hooks, CTAs |
| `seo-geo` → on-page auditor | Meta + structure |
| `ui-ux-pro-max` rule | Polish pass |
| `awesome-design-md` | Layout patterns |
| Okara landing patterns | Feed + proof structure (patterns only) |

---

## Practice task (P3 homework)

1. Pick one `REF-*` or real product URL.
2. `@design-stack` + `@21st` → hero + proof + FAQ + CTA.
3. Browser screenshot + Lighthouse SEO + CRO checklist.
4. One paragraph in Notion prompt-engineering lesson.

---

## REQ status

| REQ | Status |
|-----|--------|
| 047 | This plan ✓ |
| 048 | Blindspot table + verify loop ✓ |
