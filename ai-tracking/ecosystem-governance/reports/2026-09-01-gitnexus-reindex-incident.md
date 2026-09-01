# GitNexus reindex incident — 2026-09-01

**Status:** mitigated (skip + ignore canon). Read-only archive.  
**Hub:** `C:\Users\artyo\.cursor`  
**Gate:** `commands/gitnexus-test.ps1` (run before any reindex decision)  
**Reindex:** `commands/gitnexus-reindex.ps1` (only if test reports stale)

## Failed runs (2026-09-01)

| Run | Exit | Cause |
|-----|------|--------|
| 113863 | 1 | Parse phase: worker timeout on `impeccable/scripts/lib/surface-briefs.mjs`, `target-args.mjs`; circuit breaker |
| 113864 | 3221226505 | Same family on `template-extensions.mjs`, `live-accept.mjs`; process crash |
| 113867 / 113869 | shell timeout | `status` OK; wrapper marked failed |
| 113870 | shell timeout | analyze succeeded ~188s; wrapper marked failed |

## Root cause

Parser hang on `blocks/design/skills/impeccable/scripts/` — worker cumulative timeout on a few `.mjs` files in that subtree. The graph itself is fine; the wrapper reports failure when the parse phase exceeds the shell timeout budget.

## Note on shell `error` vs index corruption

Cursor shell may mark long jobs `error` while `analyze` actually succeeds (run 113867–113870). That is **not** index corruption. Always verify with `commands/gitnexus-test.ps1` — it parses `node .gitnexus/run.cjs status` and compares indexed commit vs `HEAD`. Do not infer corruption from the wrapper exit code alone.

## Current `.gitnexusignore` exclusions (canon)

| Path | Rationale |
|------|-----------|
| `blocks/design/skills/impeccable/scripts/` | Parser hang 2026-09-01 — worker cumulative timeout on `.mjs` files |
| `skills/_quarantine/` | Quarantine — not hub logic |
| `skills/skills-main-top-coding/` | External skill pack, not hub logic |
| `skills/open-design/repo/` · `blocks/design/skills/open-design/repo/` | Vendored upstream — not authored here |
| `skills/_archive/` | Archive — not indexed |
| `plugins/cache/` · `lib/ecc-src/` · `projects/` · `.venv*` · `ai-tracking/` · `plans/` · `.cache/` · `node_modules/` · `.gitnexus/` · `extensions/` · `**/*.db` | Standard noise |

Do **not** remove the impeccable / quarantine / top-coding lines without documenting the new hang file here first.

## Mitigation already on disk

- `.gitnexusignore` excludes the three problem subtrees.
- Index was up-to-date at commit `7db6b88` after the skip.
- `commands/gitnexus-test.ps1` is now the gate before any reindex decision.

## Reproduce / verify

```powershell
powershell -NoProfile -File commands/gitnexus-test.ps1
```

Exit 0 = fresh + ignore canon OK. Exit 1 = stale or ignore drift; follow the printed hint.

## Related

- Plan: `ai-tracking/ecosystem-governance/reports/2026-09-01-gitnexus-fixes-pipeplan.md`
- Matt adapters cross-ref: `ai-tracking/ecosystem-governance/reports/2026-09-01-mattpocock-adapters-plan.md` (Remediation closeout, finding 3)
