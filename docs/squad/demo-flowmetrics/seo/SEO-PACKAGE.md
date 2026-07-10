# SEO Package — FlowMetrics 3-Page Demo

Applied **seo-audit** / on-page framework (crawlability → on-page → content quality).

## Keyword map

| Page | Primary keyword | Secondary | Title tag |
|------|-----------------|-----------|-----------|
| Home | engineering analytics dashboard | DORA metrics SaaS | FlowMetrics — Engineering Analytics That Ship With Your Team |
| Features | DORA metrics dashboard | deploy diff, SLA alerts | Features — FlowMetrics \| DORA Metrics, Deploy Diffs, SLA Alerts |
| Pricing | engineering analytics pricing | free trial SaaS | Pricing — FlowMetrics \| Plans from $0 to Enterprise |

## On-page checklist (implemented)

- [x] Unique `<title>` per page (50–60 chars)
- [x] Unique meta description per page (150–160 chars)
- [x] One H1 per page matching intent
- [x] Logical H2 hierarchy
- [x] Internal links: nav + footer cross-links
- [x] Canonical URLs (placeholder domain)
- [x] JSON-LD: `SoftwareApplication` (home), `Product` + `AggregateOffer` (pricing)

## Technical notes (demo)

- Static HTML — fast LCP, no JS required for content
- Three.js hero deferred — content visible without WebGL
- `prefers-reduced-motion` respected

## Not done (production next)

- [ ] `sitemap.xml` + `robots.txt` on real domain
- [ ] Search Console verification
- [ ] Core Web Vitals measure on deploy
- [ ] Schema validate via Rich Results Test (browser required per seo-audit skill)

## GEO / AI citation readiness

- FAQ section with direct answers (pricing objections)
- Specific numbers in copy (4h → 15min, 90 sec setup)
- Clear entity: FlowMetrics = engineering analytics product
