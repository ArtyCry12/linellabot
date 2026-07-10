# Selling site — manual CRO checklist (REQ-047–048)

Use with `seo-audit.ps1` + browser snapshot. One page = one pass.

## Above the fold

- [ ] One clear promise (not two competing headlines)
- [ ] Primary CTA visible without scroll
- [ ] CTA verb = action (Start, Get, Book — not vague "Learn more" alone)
- [ ] Hero image/video supports promise (not decorative stock)

## Trust

- [ ] Social proof before pricing
- [ ] Logos, quotes, or numbers with source
- [ ] No fake urgency (countdown, "only 2 left") unless real

## Structure

- [ ] Objections addressed (FAQ or comparison) before final CTA
- [ ] One primary CTA color; secondary visually weaker
- [ ] Mobile: CTA in thumb zone (bottom 40% or sticky bar)
- [ ] Tap targets ≥ 44px

## AI blindspot fixes (REQ-048)

- [ ] Browser snapshot taken — agent or you verified layout
- [ ] Max 2 display font sizes in hero
- [ ] One accent color (+ neutrals)
- [ ] Lighthouse accessibility ≥ 90 OR issues listed

## SEO minimum

- [ ] Title + meta description unique
- [ ] One H1
- [ ] Images have alt text on key visuals

## Sign-off

| URL tested | Date | Pass / Revise |
|------------|------|---------------|
| | | |

**Revise loop:** fix → `npm run dev` → snapshot → re-check failed rows only.
