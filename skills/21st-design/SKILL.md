---
name: 21st-design
description: >-
  Integrates 21st.dev React UI components (Tailwind + Radix + shadcn pattern) into
  the user's project. Uses Magic MCP for AI generation, shadcn CLI for registry
  installs, and a local catalog index. Triggers on @21st, 21st.dev, Magic MCP,
  /ui component request, 21st component, shadcn add from 21st, hero/pricing/navbar
  from 21st registry. Not for pure HTML prototypes (use huashu-design) or abstract
  design tokens only (use ui-ux-pro-max).
disable-model-invocation: true
argument-hint: "[component description or 21st.dev URL]"
user-invocable: true
---

# 21st Design (21st.dev)

Use **21st.dev** as a curated registry of production-ready React components (shadcn/ui pattern, Tailwind, Radix). Prefer real registry components over inventing UI from scratch.

## Resources (global)

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/21st-design/` |
| Local catalog | `C:/Users/Asus/.cursor/lib/21st/search_results.json` |
| Source archive | `C:/Users/Asus/.cursor/skills-libraries/21st-main ( design ).zip` |
| Platform notes | `C:/Users/Asus/.cursor/lib/21st/PLATFORM_README.md` |
| Quality reference | [reference.md](reference.md) |

Refresh the catalog if missing:

```bash
node C:/Users/Asus/.cursor/skills/21st-design/scripts/ensure-library.mjs
```

Search the local index (hero, pricing, navbar, etc.):

```bash
node C:/Users/Asus/.cursor/skills/21st-design/scripts/search-catalog.mjs hero
```

## When to use

| Use 21st-design | Use something else |
|-----------------|-------------------|
| Add/adapt a **React** UI block from 21st.dev | HTML-only prototype → `huashu-design` |
| Install via `shadcn add https://21st.dev/r/...` | Color/type/spacing systems only → `ui-ux-pro-max` |
| Generate new UI with **Magic MCP** (`/ui …`) | Pixel-perfect clone of a live site → `clone-website` |

## Decision flow

1. **User gave a 21st.dev URL** (`https://21st.dev/...` or `https://21st.dev/r/user/slug`)  
   → Extract `user/slug`, run shadcn install (below), adapt files to the project.

2. **User described a component** (e.g. “animated hero with two CTAs”)  
   - If **Magic MCP** is healthy: read one tool schema under `projects/.../mcps/user-21st-devmagic/tools/`, then call MCP (user prompt style: `/ui …`).  
   - Else: `search-catalog.mjs <keywords>` → pick best match → install from `install_command` in JSON.

3. **User tagged `@21st` on existing code**  
   → Open matching registry source (install command or `component_data.code` URL), align structure/props/theme with the reference; do not rewrite unrelated files.

## Magic MCP setup

Configured in `C:/Users/Asus/.cursor/mcp.json` as `@21st-dev/magic` with `API_KEY`.

If the server errors:

1. Create a key at https://21st.dev/magic/console  
2. Reinstall: `npx.cmd @21st-dev/cli@latest install cursor --api-key <key>`  
3. Or set `API_KEY` in `mcp.json` and restart MCP in Cursor Settings.

In chat, Magic is invoked with **`/ui`** + a clear component description. Let MCP write component files, then align imports and theme with the project.

## Install from registry (default path)

Requires **shadcn/ui** already initialized in the target project (`components.json`).

```bash
npx.cmd shadcn@latest add "https://21st.dev/r/<username>/<component-slug>"
```

Use the project’s package manager if it differs (`pnpm dlx`, `yarn dlx`). After install:

- Map imports to the project’s alias (`@/components`, etc.).
- Merge `globals.css` / CSS variables if the block adds theme tokens.
- Replace demo-only copy with the user’s real content; keep layout and motion.
- Use `motion/react` if the source uses Motion: `import { motion } from "motion/react"`.

## Adaptation rules (consumer project)

- Match **existing** stack: Next.js App Router, Tailwind v3/v4, shadcn paths — do not fork a second UI system.
- **No index barrel files** unless the project already uses them.
- Prefer **server components**; add `"use client"` only where hooks, motion, or browser APIs require it.
- Theme: `hsl(var(--background))` and shadcn CSS variables; support light/dark if the project does.
- Minimize `useEffect`; use the project’s data-fetch pattern (`useQuery`, server fetch, etc.).

## Local catalog workflow

`search_results.json` lists popular demos with `install_command`, preview URLs, and source links.

For each candidate:

1. Read `component_data.description` and `usage_count`.
2. Prefer the install command that matches the project package manager.
3. If install fails, fetch `component_data.code` (CDN `.tsx` URL) and integrate manually with attribution in a comment.

## Handoff checklist

- [ ] Component renders in target route/story without console errors
- [ ] Theme matches project (no orphan hardcoded hex unless in the original)
- [ ] Responsive at mobile / tablet / desktop
- [ ] Accessible labels, focus states, reduced-motion respected
- [ ] User content swapped in; no lorem from the demo left in production paths

## Additional detail

- Publishing/quality rules for authors: [reference.md](reference.md)
- Upstream monorepo (platform only, not required for consumers): extract zip to a temp folder only when debugging registry behavior
