# 21st.dev — reference

## Component file shape (registry authors)

```
component-name/
  code.tsx              # Reusable component only
  tailwind.config.js    # Optional
  globals.css           # Optional
  demos/
    default/
      code.demo.tsx     # Demo / marketing content
```

- **code.tsx** — logic and UI reusable across projects; no marketing copy hardcoded.
- **code.demo.tsx** — showcases props; content lives here.

## Quality bar (featured components)

1. **Visual** — polished, real utility, modern UX.
2. **Structure** — shadcn split: component vs demo.
3. **Theme** — CSS variables from shadcn (`globals.css`), light + dark, `hsl(var(--token))`.

## Review states

| State | Meaning |
|-------|---------|
| `on_review` | Direct link only |
| `posted` | On author profile |
| `featured` | Homepage / public listings |

## Install URL pattern

```
https://21st.dev/r/<username>/<component-slug>
```

Example:

```bash
npx.cmd shadcn@latest add "https://21st.dev/r/serafimcloud/animated-hero"
```

## CDN source URLs

Registry entries may include:

- `component_data.code` — direct `.tsx` on `cdn.21st.dev`
- `preview_url` / `video_url` — visual reference for matching layout

## Magic MCP (AI generation)

- Console: https://21st.dev/magic/console  
- Docs: https://github.com/21st-dev/magic-mcp  
- User prompt convention: `/ui <description>`  
- MCP server id: `@21st-dev/magic`  
- Env: `API_KEY`

Magic writes only component-related files and follows the host project’s conventions.

## Conflicts with other design skills

| Skill | Role |
|-------|------|
| **21st-design** | Concrete React components from 21st.dev / Magic |
| **ui-ux-pro-max** | Palettes, typography, UX rules, stack-agnostic design intelligence |
| **huashu-design** | HTML prototypes, motion demos, decks — not shadcn install |

Use **21st-design** when the deliverable is **shippable React UI in the repo**, not a standalone HTML artifact.
