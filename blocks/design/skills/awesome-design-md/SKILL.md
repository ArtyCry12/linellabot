---
name: awesome-design-md
description: >-
  Applies curated Google Stitch–format DESIGN.md design systems from real
  product sites (Stripe, Linear, Vercel, Apple, etc.). Use when the user wants
  UI that looks like a known brand, mentions DESIGN.md, design tokens, design
  system from a website, "build like X", pixel-perfect brand styling, or tags
  @awesome-design-md, @design-md, getdesign.md. Complements clone-website
  (layout copy) and huashu-design (original HTML prototypes)—this skill supplies
  the visual spec, not page structure extraction.
---

# Awesome DESIGN.md

71 ready-to-use `DESIGN.md` files (VoltAgent [awesome-design-md](https://github.com/VoltAgent/awesome-design-md)) live in this skill at `library/<slug>/DESIGN.md`. Each file is a plain-text design system: YAML tokens (colors, typography, components) plus markdown sections (overview, do's/don'ts, responsive rules, agent prompts).

**Library root:** `C:/Users/Asus/.cursor/skills/awesome-design-md/library/`

**Brand index:** [catalog.md](catalog.md) — pick a slug before reading a file.

## When to use

| User intent | Action |
|-------------|--------|
| "Make it look like Stripe / Linear / …" | Load `library/<slug>/DESIGN.md` |
| "Use DESIGN.md" / design system doc | Copy spec into project or implement inline |
| Vague "modern SaaS" | Offer 2–3 slugs from catalog (e.g. linear.app, vercel, stripe); user picks one |
| Clone existing URL layout | Use **clone-website** for structure; use **this skill** only for look-and-feel if brand is in catalog |

## Workflow

```
1. Resolve brand → slug (catalog.md or fuzzy match on company name)
2. Read library/<slug>/DESIGN.md (full file — YAML + markdown)
3. Decide delivery mode (see below)
4. Implement UI using tokens exactly; respect Do's and Don'ts
5. If project has AGENTS.md / Tailwind — map semantic tokens, don't invent hex values
```

### 1. Resolve slug

- Exact: `stripe` → `library/stripe/DESIGN.md`
- Domain-style: `linear.app`, `mistral.ai`, `x.ai` — folder names match repo
- Aliases: "OpenAI-style" → not in library; suggest closest (e.g. `claude`, `x.ai`) or ask

If no match: say which brands exist in [catalog.md](catalog.md); do not fabricate a DESIGN.md.

### 2. Read the spec

Each `DESIGN.md` has:

1. **YAML frontmatter** — `colors`, `typography`, `spacing`, `rounded`, `components` (with `{token}` references)
2. **Markdown body** — atmosphere, palette roles, typography table, components, layout, elevation, do/don't, responsive, agent prompt snippets

Read **both**. Implementation values come from YAML; rationale and guardrails from markdown.

### 3. Delivery mode

| Mode | When | Steps |
|------|------|--------|
| **A. Project DESIGN.md** | Greenfield or user wants persistent spec | Copy `library/<slug>/DESIGN.md` → project root `DESIGN.md`; implement against it |
| **B. Inline implementation** | One-off page/component | Keep file in skill path; apply tokens directly in code |
| **C. Theme extension** | Next.js + Tailwind/shadcn | Map `colors.*` → CSS variables / `@theme`; map `typography.*` → text utilities; map `components.*` → component variants |

Default: **A** for multi-file apps, **B** for a single component unless user says otherwise.

### 4. Implementation rules

- **Token fidelity:** Use hex/spacing/radius from YAML; do not substitute "similar" colors.
- **Single accent discipline:** Many brands allow only one filled CTA hue — check markdown "Key Characteristics" and Do's/Don'ts.
- **Typography:** Load named font stacks from spec; use stated weights and letter-spacing.
- **Components:** Prefer named keys (`button-primary`, `card-marketing`, …) over ad-hoc classes.
- **Dark vs light:** Infer from `colors.canvas` / copy; some brands are dark-first (vercel marketing is light; spotify is dark).
- **No generic AI slop:** If spec says pill buttons, no radius-8 defaults; if spec forbids purple gradients, don't add them.

### 5. Verification

Before claiming done:

- [ ] Primary CTA matches spec role (usually one accent)
- [ ] Body text uses `ink` / `body` / `mute` roles, not pure gray guesses
- [ ] Spacing uses scale from `spacing:` block
- [ ] At least one markdown "Don't" was explicitly avoided

## Slug quick reference

Full list: [catalog.md](catalog.md). Common picks:

| Slug | Vibe |
|------|------|
| `stripe` | Indigo gradient mesh, Sohne 300, pill CTAs |
| `linear.app` | Ultra-minimal, purple accent, engineer SaaS |
| `vercel` | Black/white, Geist, mesh gradient heroes |
| `notion` | Warm minimal, soft surfaces |
| `apple` | White space, SF Pro, cinematic imagery |
| `supabase` | Dark emerald, developer docs |
| `claude` | Terracotta, editorial warmth |
| `figma` | Multi-color playful professional |
| `shopify` | Dark cinematic, neon green |
| `airbnb` | Coral, photography, rounded UI |

## Conflicts with other skills

- **clone-website:** Structure/assets from target URL; optionally layer a catalog slug if user wants a *different* brand skin.
- **huashu-design:** Original HTML prototypes and motion; use awesome-design-md when the reference is an existing product aesthetic.
- **ui-ux-pro-max:** Generic UX heuristics; prefer this skill when a named brand spec exists in `library/`.

## Updating the library

Source zip: `skills-libraries/awesome-design-md-main ( design ).zip`. Refresh:

```powershell
robocopy "<extracted>/design-md" "C:\Users\Asus\.cursor\skills\awesome-design-md\library" *.md /S
```

Upstream: https://github.com/VoltAgent/awesome-design-md
