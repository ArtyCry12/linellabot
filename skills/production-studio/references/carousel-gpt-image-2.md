# Carousel — GPT Image 2 template (Production Studio)

**Use for:** Instagram/LinkedIn carousel slides (1080x1350 or 1080x1080).

## Slide spec (copy to brief)

| Field | Value |
|-------|-------|
| Format | 4:5 portrait (1080x1350) or 1:1 |
| Slides | 5-7 |
| Style lock | From `references/style-lock.md` |
| Text on slide | Max 12 words headline + optional 1 line sub |

## Per-slide JSON (`templates/production-studio/carousel-slide-spec.json`)

Use one object per slide; batch in array for full carousel.

## GPT Image 2 prompt formula

```
[STYLE LOCK] + [Slide N/total] + [Headline text exactly] + [Visual metaphor] + [Background] + [No clutter, readable typography area top-third]
```

### Example (slide 2/6)

```
Minimal dark tech carousel slide 2 of 6. Headline text: "Task Router on every prompt".
Visual: abstract flow diagram nodes, accent blue on charcoal. Clean sans-serif typography in upper third.
Portrait 4:5, high contrast, no watermark, no extra text beyond headline.
```

## Workflow

1. Script hooks in `modules/shared` brief
2. Fill `carousel-slide-spec.json` per slide
3. Generate images (GPT Image 2 / DALL-E / external)
4. QC: text readable, brand colors, slide order
5. Assembly in editor (CapCut/Canva/Figma) — not auto-published

## Crew handoff

Marketing crew step `copy` can output slide headlines; production crew `storyboard` maps visuals.
