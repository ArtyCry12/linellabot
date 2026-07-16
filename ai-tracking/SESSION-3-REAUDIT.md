# Session 3 Re-Audit — Cursor Hub (post S1+S2)

> **SUPERSEDED for open gaps:** live status → [`SESSION-4-REAUDIT.md`](SESSION-4-REAUDIT.md) (2026-07-16).  
> Historical snapshot only. TODO rows below that still say open on route-echo / dual-review / digest were **closed in S3**; canvas/plan gaps closed in **S4**.

**Date:** 2026-07-16  
**Hub root:** `C:\Users\Asus\.cursor`  
**Scope:** Read-only audit after Session 1 (find-skills wire) + Session 2 (index, taxonomy, MCP tiers, wrappers, archive).  
**Not edited:** `hooks.json`, `agents/*.md` model lines, `mcp.json` secrets, `plans/hub_deep_dive_fixes_*.plan.md`.

---

## Executive summary

| Area | Status |
|------|--------|
| Skills index + find-skills wire | **DONE** |
| MCP tiers manifest + example | **DONE** |
| Task router (69 routes, tests PASS) | **DONE** |
| Route echo in agent rule | **DONE (S3)** |
| Agency off always-on | **DONE** |
| Sacred seo-geo pack | **DONE** (present, routed) |
| Hub-safe-cleanup Apply | **DONE (S3)** |
| Dual review (GPT+Sonnet fanout) | **DONE (S3)** |
| Chat digest | **DONE (S3)** |
| Full design matrix (plan P0) | **DONE (S3)** |
| Canvas ACTION_ITEMS / body sync | **DONE (S4)** — see SESSION-4 |
| Deep-dive plan file | **DONE** — `plans/hub-deep-dive-fixes.md` |

---

## 1. Skills

### 1.1 Count in `skills/_INDEX.md`

| Metric | Value | Evidence |
|--------|-------|----------|
| Total indexed skills | **120** | `skills/_INDEX.md` footer: `Total: 120 skills` |
| Generated | 2026-07-16T16:24:16Z | Same file, line 3 |
| Table rows (incl. header/separator) | 122 `\|` lines | grep count |

**Status:** **DONE** (S2 index regenerated)

### 1.2 find-skills wire (S1)

| Component | Path | Status |
|-----------|------|--------|
| Hub wrapper | `skills/find-skills/SKILL.md` | DONE |
| Upstream install | `.agents/skills/find-skills/SKILL.md` | DONE (exists) |
| On-demand rule | `rules/find-skills.mdc` (`alwaysApply: false`) | DONE |
| Route | `find-skills` in `lib/task-router/routes.json` (id at ~642) | DONE |
| CLI | `commands/find-skills.ps1` | DONE |
| Test | `commands/find-skills-test.ps1` | **PASS** (2026-07-16 run) |
| Registry | `SYSTEM-REGISTRY.md` В§ find-skills | DONE |

**Sample resolve:** `"find skill for react performance on skills.sh"` в†’ `find-skills` (score 6) вЂ” `task-router-test.ps1` PASS.

**Status:** **DONE**

### 1.3 Design stack wrappers

| Skill | Type | Route in `routes.json` | Status |
|-------|------|------------------------|--------|
| `skills/design-stack/SKILL.md` | Native hub (not upstream wrapper) | `design-stack` | DONE |
| `skills/frontend-design/SKILL.md` | Bridge / anti-slop | `frontend-design-web` | DONE |
| `skills/stitch-shadcn-ui/SKILL.md` | Hub wrapper в†’ google-labs stitch | `stitch-shadcn-ui`, `stitch-design` | DONE |
| `skills/shadcn/SKILL.md` | Hub wrapper | `shadcn-ui` | DONE |
| `skills/design-taste-frontend/SKILL.md` | Hub wrapper | `design-taste` | DONE |
| `skills/impeccable/SKILL.md` | Hub wrapper | `impeccable` | DONE |
| `skills/web-design-guidelines/SKILL.md` | Hub wrapper | (paired via design routes) | DONE |
| `skills/huashu-design/SKILL.md` | Sacred native | `huashu-design` | DONE |
| `skills/21st-design/SKILL.md` | Native | `21st-design` | DONE |
| `rules/design-stack.mdc` | On-demand rule | `alwaysApply: false` | DONE |

**Squad gate:** `agents/squad-design.md` has anti-slop checklist + `Applied: frontend-design gate` вЂ” **PARTIAL** vs full plan matrix (Stitch-primary mock, Figma-create, production-studio, humanizer row missing from squad table).

**Status:** **PARTIAL** (routes + wrappers wired; full P0 design matrix from deep-dive plan not fully encoded in `design-stack.mdc` / squad-design)

### 1.4 Other Complement / hub wrappers

**Count:** **26** skills with `Hub wrapper` in frontmatter under `skills/` (grep on `SKILL.md`).

Examples (S2 marketingskills / security / opc layer):

- `skills/seo-audit/SKILL.md`, `skills/programmatic-seo/SKILL.md`, `skills/opc-seo-geo/SKILL.md`
- `skills/playwright/SKILL.md`, `skills/playwright-visual-testing/SKILL.md`
- `skills/copywriting/SKILL.md`, `skills/content-strategy/SKILL.md`, `skills/marketing-psychology/SKILL.md`
- `skills/cloudflare-security-audit/SKILL.md`, `skills/firebase-security-rules-auditor/SKILL.md`, etc.

**Complement routing notes in `routes.json`:**

- `opc-seo-geo` в†’ `"Complement to skills/seo-geo/ library"`
- `seo-audit-ms` в†’ deep audits defer to `seo-geo` route

**Status:** **DONE** (S2 wrapper wave)

### 1.5 `_archive`

| Item | Evidence | Status |
|------|----------|--------|
| Folder | `skills/_archive/` | DONE |
| Contents | `game-studios-multiagent/` (+ README) | DONE |
| Index visibility | Still listed in `_INDEX.md` (archived skill row) | Expected |
| Policy | `skills/_archive/README.md` вЂ” restore by move back | DONE |

**Status:** **DONE**

### 1.6 Sacred `seo-geo` still present

| Check | Path | Status |
|-------|------|--------|
| Hub skill | `skills/seo-geo/SKILL.md` | Present |
| Library tree | `skills/seo-geo/library/` (223+ files) | Present |
| Route | `seo-geo` id in `routes.json` | DONE |
| Taxonomy sacred list | `ai-tracking/skills-taxonomy-s2.md` line 5 | DONE |

**Status:** **DONE**

---

## 2. MCP tiers

### 2.1 `lib/mcp-router/McpTier.ps1`

| Tier | IDs (count) | Evidence |
|------|-------------|----------|
| **alwaysOn** | `memory`, `gitnexus` (**2**) | lines 10вЂ“12 |
| **onDemand** | **26** servers (markitdown-mcp, exa, fetch, firecrawl, playwright, chrome-devtools, cursor-ide-browser, stitch, figma, context7, n8n, notion, iconify, 21st-magic, magnific, gemini, apify, prompts.chat, google-workspace, google-maps, vercel, supabase, zapier, apify-plugin, shadcn, aikido) | lines 14вЂ“25 |
| **disableArchive** | **5** (`obsidian`, `tavily`, `plugin-tavily-tavily`, `browse`, `plugin-browse-browser`) | lines 37вЂ“41 |
| Browser routing | e2eв†’playwright, debugв†’chrome-devtools, smokeв†’cursor-ide-browser | lines 42вЂ“46 |
| Web routing | researchв†’Exa, singleUrlв†’fetch, crawlв†’firecrawl | lines 47вЂ“51 |
| Health helper | `Get-McpHealthReport` | lines 72вЂ“101 |

**Doc mirror:** `ai-tracking/mcp-plugin-tiers-s2.md`  
**Taxonomy pointer:** `SYSTEM-TAXONOMY.md` В§ Skill lifecycle (Session 2)

**Status:** **DONE**

### 2.2 `mcp.json.example` (no live secrets)

| Check | Result |
|-------|--------|
| File exists | `mcp.json.example` (2302 bytes) |
| Placeholder secrets | `YOUR_*` keys only (21st, stitch, gemini, n8n JWT) |
| Obsidian removed | **Not present** in example (aligns with DEC-009 / S2) |
| Tavily/browse | **Not present** in example |

**Status:** **DONE**

---

## 3. Routes (`lib/task-router/routes.json`)

### 3.1 Count

| Metric | Value |
|--------|-------|
| Route objects (`"id":`) | **69** |
| Hook | `hooks/task-router.ps1` в†’ `Resolve-TaskRoute.ps1` |
| Injected block prefix | `[TASK ROUTE]` (see `Format-TaskRouteContext`) |

### 3.2 Sample resolves (live `task-router-test.ps1` 2026-07-16)

| Prompt | Primary route | Secondary | Status |
|--------|---------------|-----------|--------|
| `find skill for react performance on skills.sh` | `find-skills` (6) | вЂ” | DONE |
| `impeccable polish this landing` | `impeccable` (13) | вЂ” | DONE |
| `@seo-audit technical seo health` | `seo-audit-ms` (21) | вЂ” | DONE |
| `why not ranking indexing issues` | `seo-audit-ms` (13) | вЂ” | DONE |
| `technical seo audit why not ranking` | `seo-geo` | (keyword overlap вЂ” seo-geo wins) | **PARTIAL** (ambiguous; tag `@seo-audit` disambiguates) |
| `playwright test e2e spec login page` | `playwright-e2e` (6) | `browser-e2e` | DONE |
| `write playwright e2e test for login` | `browser-e2e` | вЂ” | **PARTIAL** (live browser wins over test-code route) |

**Batch test:** `commands/task-router-test.ps1` вЂ” **10/10 samples routed**, 0 misses.

**Status:** **DONE** (with noted ambiguities on seo/playwright phrasing)

---

## 4. Rules вЂ” route echo requirement

**File:** `rules/task-router.mdc`

| Requirement (deep-dive plan P0) | Present? |
|----------------------------------|----------|
| Honor `[TASK ROUTE]` from hook | YES (line 16) |
| Read SKILL.md / load rule / MCP / subagent | YES |
| **Agent must echo first block:** В«РџРѕРґРєР»СЋС‡РёР»: skill / MCP / subagentВ» (2вЂ“4 lines) | **NO** |

**Hook injects:** `[TASK ROUTE]` via `Format-TaskRouteContext` (`lib/task-router/Resolve-TaskRoute.ps1:108`).  
**Rule text says:** `[TASK ROUTE - auto-detected]` вЂ” **label mismatch** with hook output (`[TASK ROUTE]` only).

**Status:** **TODO** (route-echo enforcement missing; label drift)

---

## 5. Agency rules (`rules/agency/*.mdc`)

| Metric | Count | Sample |
|--------|-------|--------|
| Total agency rule files | **66** | `rules/agency/*.mdc` |
| `alwaysApply: true` | **0** | rg: no matches |
| `alwaysApply: false` | **66** | e.g. `rules/agency/content-creator.mdc:4`, `rules/agency/seo-specialist.mdc:4` |

**Status:** **DONE** (S2 вЂ” all on-demand / @tag)

---

## 6. Canvas вЂ” `projects/c-Users-Asus-cursor/canvases/hub-deep-dive-audit.canvas.tsx`

**Version:** v3.1 В· 14.07.2026 (unchanged since original audit)

### ACTION_ITEMS (all still `pending`)

| ID | Content | Post-S2 reality |
|----|---------|-----------------|
| reload | Reload Window after hooks.json | Still pending (manual) |
| sync-models | Sync agents/squad-*.md models | Still pending (trust_manual) |
| design-refs | 3 design reference sites | Still pending |
| design-gate | huashu + humanizer before build | **PARTIAL** вЂ” squad-design has frontend-design gate; humanizer not in squad table |
| route-ui | Show [TASK ROUTE] block at answer start | **TODO** вЂ” rule not written |
| ask-full | AskQuestion full list before big tasks | Policy in user-profile; canvas still pending |
| models-trim | 8вЂ“10 models ON | User done per plan; canvas **not updated** |
| deferred | cursor-system-refresh-deferred.ps1 | Still pending |

### Sections (16) вЂ” status vs S2

| Section | Label | Post-S2 |
|---------|-------|---------|
| overview | РћР±Р·РѕСЂ СЃРёСЃС‚РµРјС‹ | Open diagnosis still valid |
| models | РњРѕРґРµР»Рё LLM | User-side done; canvas stale |
| squad | РЎСѓР±Р°РіРµРЅС‚С‹ | Drift table stale |
| logic | Р›РѕРіРёРєР° Squad | Unchanged |
| markitdown | MarkItDown + С‚РѕРєРµРЅС‹ | Still accurate |
| mistakes | РћС€РёР±РєРё РІ РїСЂРѕРјРїС‚Р°С… | Still accurate |
| honest | Р§РµСЃС‚РЅС‹Р№ СЂР°Р·Р±РѕСЂ | Partially addressed (index, tiers, agency) |
| q7 | Plan + Auto + Squad | Still accurate |
| cleanup | Р§С‚Рѕ РїРѕС‡РёСЃС‚РёС‚СЊ | Script exists; Apply not refreshed post-S2 |
| why-broken | РџРѕС‡РµРјСѓ РЅРµ СЂР°Р±РѕС‚Р°РµС‚ | route-echo still open |
| memory | РџР°РјСЏС‚СЊ Рё РІРѕРїСЂРѕСЃС‹ | Open |
| about-you | Р§С‚Рѕ СЏ Р·РЅР°СЋ Рѕ С‚РµР±Рµ | Unchanged |
| partner | РџРѕРґРґР°РєРёРІР°РЅРёРµ | Open |
| skills-mcp | РЎРєРёР»Р»С‹ РЅРµ РІРёРґРЅС‹ | Improved wiring; enforcement still weak |
| auto-route | РђРІС‚РѕРїРѕРґР±РѕСЂ | Router DONE; echo TODO |
| squad-howto | РљР°Рє Р·Р°РїСѓСЃС‚РёС‚СЊ Squad | Unchanged |

**Status:** **TODO** (canvas not refreshed after S2)

---

## 7. Gaps from original `hub_deep_dive_fixes` plan

Source: `plans/hub_deep_dive_fixes_1e3f8636.plan.md` (still all todos `pending` in frontmatter)

| Gap | Plan priority | Post-S2 status | Evidence |
|-----|---------------|----------------|----------|
| **route-echo** | P0 | **TODO** | No echo clause in `rules/task-router.mdc` |
| **cleanup Apply** | P0 | **PARTIAL** | `commands/hub-safe-cleanup.ps1` exists; last report `ai-tracking/safe-cleanup-last.json` dated **2026-07-13**, `apply: true`, `freedMb: 0`, empty rows. Not re-run post-S2. **Conflict:** script line 47 deletes `.cache/markitdown` вЂ” plan says do not touch markitdown cache |
| **dual-review** | P1 | **TODO** | `skills/pr-review/SKILL.md` has parallel spawn to squad-review, no GPT+Sonnet fanout; `agents/squad-review.md` вЂ” no dual mention |
| **agency off always-on** | P2 | **DONE** | 66/66 `alwaysApply: false` |
| **chat digest** | P2 | **TODO** | No command/protocol under `commands/` or `ai-tracking/` for session `.md` digest (only canvas mention of transcript digest) |
| **design-stack.mdc sync** | P0 (matrix) | **PARTIAL** | Rule + skill aligned on shadcn-first/CRO; missing full matrix rows (Stitch primary, Figma-create, remotion, production-studio, humanizer, agency max-1) from plan В§ Design matrix |
| **design matrix in squad-design + routes** | P0 | **PARTIAL** | squad-design table covers 7 skills; routes have design-* ids; not full plan table |
| **SYSTEM-TAXONOMY ACTIVE/ON-DEMAND/ARCHIVE** | P2 | **DONE** | `ai-tracking/skills-taxonomy-s2.md` + pointer in `SYSTEM-TAXONOMY.md` |
| **Boss checklist plan file** | P1 | **TODO** | `plans/2026-07-15-hub-deep-dive-fixes.md` **missing** |
| **router-tests** | P1 | **DONE** | `task-router-test.ps1` PASS; `find-skills-test.ps1` PASS |
| **image JSON (S2 extra)** | S2 | **DONE** | `lib/lvm/image-prompt.schema.json`, `lib/lvm/image-prompt.example.json`; referenced in `skills/production-studio/SKILL.md` |

---

## 8. P0 / P1 / P2 recommendations (after S2)

### P0 вЂ” do next

| Item | Already done (S1+S2) | Still needed |
|------|----------------------|--------------|
| Design matrix gate | Routes + wrappers + squad-design partial gate | Encode **full** artifactв†’skill/MCP table in `agents/squad-design.md` + `rules/design-stack.mdc`; require `Applied: [...]` line |
| Route echo | Hook injects `[TASK ROUTE]` | Add explicit echo rule to `rules/task-router.mdc`; fix label to match hook (`[TASK ROUTE]`) |
| Safe cleanup | Script + stale Apply | Fix script to **skip** `.cache/markitdown` and venv; dry-run в†’ show report в†’ `-Apply` post-S2 |

### P1 вЂ” stability

| Item | Done | Needed |
|------|------|--------|
| Dual review | pr-review + squad-review exist | Document optional GPT+Sonnet fanout in `skills/pr-review/SKILL.md` + `agents/squad-review.md` |
| Boss/Auto guide | Canvas has BOSS_MODEL_RULES | Write `plans/2026-07-15-hub-deep-dive-fixes.md` (or parent rebuild in S3) |
| Router tests | PASS | Add regression cases for seo-audit vs seo-geo and playwright-e2e vs browser-e2e |
| Canvas update | вЂ” | Mark models-trim DONE; route-ui/design-gate in progress |

### P2 вЂ” token economy / hygiene

| Item | Done | Needed |
|------|------|--------|
| Taxonomy | skills-taxonomy-s2 + SYSTEM-TAXONOMY pointer | Periodic refresh; prune `_INDEX` dupes (e.g. duplicate `frontend-design` rows) |
| Agency always-on | 66/66 false | None вЂ” maintain |
| Chat digest | вЂ” | Add `commands/chat-digest.ps1` or protocol doc under `ai-tracking/` (no hooks.json) |
| Deferred refresh | вЂ” | User runs `commands/cursor-system-refresh-deferred.ps1` after session |

### P3 вЂ” backlog (unchanged)

Design refs (3 sites), budget cap, Notion publish, model-map в†” agents sync (trust_manual lock).

---

## 9. S1+S2 deliverables checklist

| Session | Deliverable | Status |
|---------|-------------|--------|
| S1 | find-skills upstream + wrapper + route + tests | **DONE** |
| S2 | `_INDEX.md` (120 skills) | **DONE** |
| S2 | `skills-taxonomy-s2.md` | **DONE** |
| S2 | `mcp-plugin-tiers-s2.md` + `McpTier.ps1` | **DONE** |
| S2 | 26 hub wrappers (marketing/security/design/playwright) | **DONE** |
| S2 | `_archive/game-studios-multiagent` | **DONE** |
| S2 | Agency `alwaysApply: false` | **DONE** |
| S2 | LVM image JSON schema | **DONE** |
| S2 | Full git commit | Not verified in this audit (no git ops) |
| S3 | This re-audit | **DONE** |
| S3 | Rebuild deep-dive plan | **TODO** (parent agent) |
| S3 | Canvas ACTION_ITEMS refresh | **TODO** |

---

## 10. Test log (this audit)

```
commands/find-skills-test.ps1     в†’ PASS
commands/task-router-test.ps1     в†’ PASS (10/10)
task-router-test -Prompt samples  в†’ find-skills, impeccable, seo-audit-ms, playwright-e2e OK
```

---

*Generated by Session 3 subagent В· read-only В· 2026-07-16*

