# Content engine skeleton (SEO+GEO+AIO)

Capability target: programs of **1000+** supporting articles. This file is the **skeleton only**.

## Pipeline

```
seed topics / products
  → semantic clusters (keyword-research + content-gap)
  → brief per URL (intent, entities, internal links, GEO angle)
  → draft (seo-content-writer)
  → GEO pass (geo-content-optimizer + entity-optimizer)
  → publish gate (meta + schema + quality auditor)
  → index & monitor
```

## Artifacts (per project, not hub)

| Path idea | Content |
|-----------|---------|
| `seo/clusters.json` | cluster → keywords → priority |
| `seo/briefs/<slug>.md` | one brief |
| `seo/drafts/` | drafts |
| `seo/publish-queue.json` | status machine |
| `seo/monitor/` | snapshots |

## Hub bootstrap

```text
node skills/seo-geo/scripts/init-seo-geo-memory.mjs <project-root>
```

## Batch controls

- Max parallel drafts: Architect/squad-growth sets (default 1–3)
- Human gate before publish on client domains
- Moldova locale defaults in briefs unless overridden

## Scale note

Mass generation is **opt-in per campaign**, not automatic on hub install.
