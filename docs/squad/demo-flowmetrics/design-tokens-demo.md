# FlowMetrics — Skill Mix Symbiosis (Demo)

Quick demo: SaaS analytics hero without user naming any skills.

## Sources merged

| Layer | Skill / tool | Contribution |
|-------|--------------|--------------|
| Design system | **ui-ux-pro-max** `--design-system -p FlowMetrics` | Bento grid pattern, Dark OLED style, palette, Fira Code/Sans |
| Layout ref | **Stitch MCP** ✅ | Project `17152691140235890532`, 3 screens — see `stitch-output/` |
| Motion + anti-slop | **huashu-design** | `hero-motion-ref.html` — orbs, stagger, reduced-motion |
| Production block | **21st-design** | `kinfe123/hero-section-dark` registry install |

## ui-ux-pro-max → tokens

| Token | Value | CSS var | Usage |
|-------|-------|---------|-------|
| primary | `#1E40AF` | `--fm-primary` | headlines accent |
| secondary | `#3B82F6` | `--fm-secondary` | links, chart lines |
| cta | `#F59E0B` | `--fm-cta` | primary button |
| background | `#0A0E17` | `--fm-bg` | hero (OLED, adjusted from light spec) |
| surface | `#111827` | `--fm-surface` | bento cards |
| text | `#E2E8F0` | `--fm-text` | body |
| text-muted | `#94A3B8` | `--fm-muted` | subcopy |
| glow | `0 0 24px rgba(59,130,246,0.35)` | — | hero headline (ui-ux effect) |

**Typography:** Fira Code (display metrics), Fira Sans (body) — from ui-ux search.

## Stitch brief (fallback when MCP unavailable)

```
Desktop hero, FlowMetrics SaaS analytics:
- Left: headline "See what your team ships", subcopy, amber CTA + ghost secondary
- Right: bento grid 2×2 mini cards (Active users, Deploy freq, Error rate, Uptime)
- Deep navy OLED bg #0A0E17, glass cards white/8 blur, blue data accents
- No stock illustrations — use abstract chart shapes only
```

When Stitch MCP is healthy: `generate_screen_from_text` with this prompt + tokens above → port rows into this table.

## 21st → component

| Registry | Install |
|----------|---------|
| `kinfe123/hero-section-dark` | `pnpm dlx shadcn@latest add "https://21st.dev/r/kinfe123/hero-section-dark"` |

Adapt: map `--fm-*` vars into shadcn CSS variables; keep 21st layout shell.

## huashu → motion

From `hero-motion-ref.html`:
- Floating orbs: 18s / 22s ease-in-out (not linear)
- Card stagger: 80ms between bento cells
- `prefers-reduced-motion`: disable orbs, instant reveal

## Build handoff

1. Install 21st hero-section-dark
2. Override colors with `--fm-*` in `globals.css`
3. Inject bento mini-stats from Stitch ref (or fallback grid in demo TSX)
4. Add motion classes from huashu ref (CSS only, no new deps)
