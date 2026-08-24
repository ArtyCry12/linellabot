# Target architecture draft — PENDING APPROVAL

**Status:** APPROVED 2026-08-24 (Boss config lock — see `APPROVED-2026-08-24.md`).  
**Date:** 2026-08-24  
**Inputs:** MASTER PROMPT · phase1-db · hub-load keep-list · CURRENT-ARCHITECTURE-MAP.md  
**Overrides:** Track A only; Graphify researched first; permanent agent = Ecosystem Architect only; no auto-Squad.

---

## Design thesis

Keep the **load-optimized hub** (profiles, ignore, slim index, hooks).  
Add a **governance plane** so skills/MCP/agents stop re-accumulating chaos.  
Do **not** replace Task Router / Squad / MarkItDown / RTK / GitNexus / memory.

Compact > maximal. One strong source per job > many overlapping repos.

---

## Target layers

```
SYSTEM LAYER (global)
  Ecosystem Architect (sole permanent governance subagent)
  Always-on rules (≤8, current set as baseline)
  Hooks pipeline (router, markitdown, rtk, coach, autopilot, repo-intake)
  MCP core profile: memory + gitnexus
  MCP profiles: design | qa | docs | ops | full
  Graph: GitNexus (code) + Ecosystem Registry (entities) — hybrid, not a second heavy indexer by default
  Quarantine/Trash plane (move, don’t delete)

BLOCK LAYER (examples)
  Orchestration · Memory/Graph · Token · Design · SEO-GEO-AIO · Security · Squad · Integrations

SUB-BLOCK
  e.g. SEO-GEO-AIO → research | on-page | GEO/AIO | content-engine | local-MD/EU/US signals
```

### Skill categories (mandatory taxonomy)

| Tier | Meaning | Disk location idea |
|------|---------|-------------------|
| CORE | Always eligible via router | `skills/` active index |
| SECONDARY | On route / @tag | `skills/` or block folder |
| FALLBACK | One alt per job max | `skills/_fallback/` |
| EXPERIMENTAL | Time-boxed | `skills/_experimental/` |
| DEPRECATED / QUARANTINE | Not routed | `skills/_quarantine/` |

Target active set (CORE+SECONDARY+FALLBACK): **~200–400**, not 1800.

### Subagents

- **Permanent:** only `ecosystem-architect` (+ existing Squad roles for project work — Squad is project execution, not ecosystem governance).
- **Ephemeral:** Architect may spawn Task workers; no new permanent zoo.
- Plugin agents: stay inside plugins; not promoted to hub unless CORE need proven.

### MCP

| Plane | Policy |
|-------|--------|
| User mcp.json | Profiles only; core default after sessions; design when design work |
| Store | Keep full catalog; **fix GitNexus heap in store to 1536** so full restore stays safe |
| Plugin MCP | Explicit UI allowlist; document in registry; Sentry = on-demand profile, not always-on |
| Sentry | Install when approved; wire into `ops` or `qa` profile, never core |

### Graph

1. Keep **GitNexus** for code impact/context (already required by AGENTS.md).  
2. Add lightweight **Ecosystem Registry** JSON/MD (skills, rules, hooks, MCP, blocks, quarantine status) updated by Architect + refresh scripts — **not** a second full code graph unless GitNexus proven insufficient for entity routing.  
3. Graphify = research alternative only; default = extend registry + GitNexus.

### SEO + GEO + AIO Engine (new BLOCK)

Single block charter replacing “agency-by-hope”:

- Skills: one CORE pack (`seo-geo` + selected marketing skills), agency personas as SECONDARY via squad-growth.  
- Commands: existing seo-audit / gsc / pagespeed stay.  
- Research: Exa + browser; local MD / EU / US source lists in block docs.  
- Content engine: scalable pipeline design (semantics → briefs → batch articles) — **capability**, not mandatory 1000-run.  
- Monitoring: Architect health + weekly digest already in hub — extend with SEO signals later.

### Notion video ideas

Separate workstream after governance skeleton:

- Read Notion folders «идеи» / «соц. идеи»  
- Transcribe/analyze **video content** (Agent-Reach / existing transcribe)  
- Brief schema: video → summary → core idea → mechanism → hook → implementation → source → relevance → adaptation  
- Promote to knowledge only when Architect marks relevance ≥ threshold  

### Security split

1. **Project security** — continuous (Aikido, security-hub, adversarial review on substantial changes).  
2. **Ecosystem security** — Architect watches MCP/plugins/skills provenance, quarantine, secrets hygiene, OpenRouter guardrails reminders.

### Monitoring report (Boss format)

Сущность → Бриф → Проблемы → Решение → Работа → Результат. Prefer Telegram when channel ready; until then `ai-tracking/ecosystem-governance/reports/`.

---

## Implementation waves (after approval)

| Wave | Scope | Gate |
|------|-------|------|
| **W0** | Baseline commit + freeze do-not-touch | Boss OK to commit hub docs |
| **W1** | Docs truth: checklist, registry, store heap 1536, settings labels | Non-destructive |
| **W2** | Quarantine tree + skill classifier (CORE…DEPRECATED) dry-run report | Approval on move list |
| **W3** | Ecosystem Architect agent + health/monitor skeleton | Approval on agent file |
| **W4** | Apply safe Phase2 candidates (logs, orphans, migrate copies) | Per-item delete approval |
| **W5** | SEO-GEO-AIO block charter + router routes | Approval |
| **W6** | External research: greptile / gstack / ruflo / Sentry — decide one each | Approval before install |
| **W7** | Notion video pipeline pilot (small N) | Approval |
| **W8** | Cool-down adversarial + mini-project validation + health | DoD |

Phase2-candidates mapped into W1/W4; MASTER extras into W3/W5–W7.

---

## Explicit non-goals (unless Boss overrides)

- Blind import of large skill monorepos  
- Deleting Squad or collapsing n8n/SEO routes  
- Replacing GitNexus on faith  
- Always-on Sentry / always-on full MCP  
- Physical delete of quarantine without second pass  

---

## Approval checklist (Boss)

Reply with one line per item: **YES / NO / LATER**

1. Accept hybrid graph (GitNexus + Ecosystem Registry), not Graphify-first.  
2. Accept single Ecosystem Architect + keep Squad for projects.  
3. Accept quarantine-before-delete for skills.  
4. Allow W1 docs/store-heap fixes without further ask.  
5. Deletes (npm-cache, CursorMigrate, logs): need separate YES each.  
6. SEO-GEO-AIO as first new BLOCK after governance skeleton.  
7. Install Sentry into ops/qa profile (not core) when we reach W6.  
8. Commit policy: agent may commit hub governance docs after W0; no push unless asked.
