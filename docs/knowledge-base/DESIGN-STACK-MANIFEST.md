# Design stack manifest (REQ-042–045)

Canonical dependency list for **new** React/Next selling sites and clones.

## Core CSS

| Package | Role |
|---------|------|
| tailwindcss | Utility CSS |
| postcss | Pipeline |
| autoprefixer | Vendor prefixes |
| class-variance-authority | Variant components |
| clsx + tailwind-merge | `cn()` helper |

## UI primitives

| Package | Role |
|---------|------|
| shadcn/ui | Radix + Tailwind components (via CLI/MCP) |
| lucide-react | Default icon set (shadcn default) |

## Optional extensions

| Package | When |
|---------|------|
| daisyUI | Rapid themed components |
| framer-motion | Motion / hero animations |
| react-icons | Legacy sets |
| @iconify/react + @iconify-json/* | Offline Iconify |

## Fonts (self-hosted REQ-044)

```bash
npm i @fontsource-variable/inter @fontsource-variable/manrope
# geist: @fontsource-variable/geist-sans or next/font local
```

## Init sequence

```bash
npx create-next-app@latest  # or clone-website template
npx shadcn@latest init
# MCP: search registry BEFORE custom components
```

## Registry priority

1. 21st.dev / shadcn registry (MCP)
2. context7 docs
3. Project existing components
4. Custom code (last)

Skill: `skills/design-stack/SKILL.md`
