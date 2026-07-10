# FlowMetrics — Full Skill Mix Proof (3-Page Landing)

**Stitch project:** `17152691140235890532` · [Open in Stitch](https://stitch.withgoogle.com)

## Instrument status

| Tool | Status | Evidence |
|------|--------|----------|
| **Stitch API** | ✅ WORKS (CLI proxy) | Project created, 3 screens generating |
| **Stitch Cursor MCP** | ⚠️ Timeout in agent | Reload Window after `ensure-stitch.ps1` |
| **ui-ux-pro-max** | ✅ | `--design-system -p FlowMetrics Pro` |
| **huashu-design** | ✅ | Three.js hero + motion + glass in `site/` |
| **21st-design** | ✅ (catalog) | `hero-section-dark` mapped in tokens |
| **copywriting** | ✅ | `marketing/COPY-RATIONALE.md` |
| **seo-audit** | ✅ | `seo/SEO-PACKAGE.md` + JSON-LD |
| **product-marketing** | ✅ | `marketing/product-marketing.md` |
| **Figma MCP** | ❌ NOT CONNECTED | See `FIGMA-BLOCKER.md` |

## Stitch → Code symbiosis

| Stitch token | Hex | CSS var | Used in |
|--------------|-----|---------|---------|
| surface-container-lowest | #0A0E17 | `--fm-bg` | all pages |
| overridePrimaryColor | #0A84FF | `--fm-primary` | hero, metrics |
| overrideSecondaryColor | #F59E0B | `--fm-cta` | buttons |
| Hanken Grotesk | display | `--font-display` | headlines |
| JetBrains Mono | data | `--fm-mono` | stat cards |

**Home screen:** `9759c45e202a474cb390a545cc624935`  
**HTML ref:** `stitch-output/home-stitch.html`  
**Screenshot:** see `stitch-output/STITCH-REFS.md`

## Live demo (open in browser)

```
docs/squad/demo-flowmetrics/site/index.html      ← 3D hero + scroll
docs/squad/demo-flowmetrics/site/features.html   ← bento (Stitch-aligned)
docs/squad/demo-flowmetrics/site/pricing.html    ← conversion + FAQ + schema
```

## Skill combination map

```
product-marketing (ICP, positioning)
        ↓
copywriting (headlines, CTAs, FAQ)
        ↓
ui-ux-pro-max (design system tokens)
        ↓
Stitch MCP (3 desktop screens) ──→ stitch-output/*.html
        ↓
huashu-design (3D crystal, scroll parallax, reduced-motion)
        ↓
seo-audit (meta, canonical, JSON-LD, keyword map)
        ↓
site/*.html (integrated deliverable)
        ↓
[Figma MCP when connected] → design/FIGMA-HANDOFF-SPEC.md
```

## What makes this NOT single-skill

- Copy says **4h → 15min** (copywriting specificity), not generic "save time"
- Colors from **ui-ux search**, layout from **Stitch bento**, motion from **huashu**
- SEO titles target **DORA metrics** keyword per page
- Pricing uses **marketing objection handling** in FAQ

## Next when you say "Figma работает"

1. `generate_figma_design` from `site/index.html` screenshot
2. Variable sync from symbiosis table
3. Code Connect optional
