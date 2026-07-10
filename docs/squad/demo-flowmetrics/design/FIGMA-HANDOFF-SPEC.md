# Figma Handoff Spec — FlowMetrics (ready when MCP connects)

## File structure (3 pages)

| Frame | Size | Content |
|-------|------|---------|
| 01 Home Hero | 1440×900 | 3D hero zone right, copy left, 4 stat cards |
| 02 Features Bento | 1440×2400 | 6-card bento + Git CTA strip |
| 03 Pricing | 1440×2000 | 3 tiers + FAQ |

## Variables (from Stitch + ui-ux symbiosis)

```
fm/bg          #0A0E17
fm/primary     #0A84FF
fm/secondary   #5AC8FA
fm/cta         #F59E0B
fm/text        #E2E8F0
fm/muted       #94A3B8
fm/glass       rgba(28,28,30,0.72)
```

## Typography

- Display: Hanken Grotesk 700–800
- Data: JetBrains Mono 500–700

## Components to create in Figma

- `Button/Primary` — amber pill
- `Button/Ghost` — glass border
- `Card/Glass` — blur + 1px border
- `Metric/Stat` — mono value + label
- `Nav/Bar` — fixed blur

## Import path from Stitch

When `get_screen` returns HTML for project `17152691140235890532`:
1. Screenshot → Figma reference layer
2. Extract spacing → auto-layout frames
3. Code Connect map → `HeroSection.demo.tsx` (optional)

## generate_figma_design prompt (when MCP live)

```
FlowMetrics SaaS analytics landing — 3 desktop frames matching site/index.html hero:
dark OLED, glass bento cards, electric blue 3D crystal motif, amber CTAs.
Use design tokens from fm/* variables above.
```
