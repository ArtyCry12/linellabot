# Adversarial pipeplan — hub closeout 2026-08-25

**Auditor:** `agents/adversarial-hub-auditor.md`  
**Model:** `cursor-grok-4.6-high`  
**Edits:** none. Index paths. List findings. Stop.

## Pass 1 — plan lock (before/at start of execute)

Read the locked closeout (chat plan Hub closeout lock 2026-08-25). Check:

- [ ] Sequence: auditor → maps → canon-docs → dups → squad archive → blocks → library-index → index-1 → MCP core → test-1 → gh rename → research → install-on-yes → index-2 → auditor-2
- [ ] Hub vs 8 blocks roster complete; remotion only in media
- [ ] scan_blocks: no SKILL.md stubs; product boundary hooks.json/mcp.json stay at `.cursor`
- [ ] `.cursor` folder NOT renamed; GitHub target `cursor-hub-artyom`
- [ ] Squad archive not delete; routes strip squad-*; keep-list docs updated in same wave
- [ ] Sentry = plugin only, no URL in ops/qa
- [ ] Nested libraries indexed not discovered
- [ ] Graphify not a focus
- [ ] Dual research targets hub|blocks/<id>

Go deeper if the plan contradicts disk or Cursor product constraints.

## Pass 2 — disk (after index-pass-2)

Verify on disk:

| Check | Path / command |
|-------|----------------|
| 8 block dirs exist | `blocks/{seo-geo-aio,design,security,integrations,agency,media,qa,dev-os}/` |
| Hub skills remain in `skills/` | no domain dumps |
| 23 dups gone | no `skills/<name>` if also `_quarantine/<name>` for the locked list |
| Squad archived | `agents/squad-*.md` absent; archive present |
| routes.json | no `"subagent": ["squad-*"]` |
| LIBRARY-INDEX | each block with library |
| `_INDEX.md` | includes `blocks/*/skills` root SKILL.md, not library |
| mcp.json live | profile core; no sentry URL |
| ops/qa json | no sentry id |
| remote | `cursor-hub-artyom` or residual documented |
| test-gate reports | gate 1 and gate 2 with exit codes |
| User Rules / AGENTS / LOCKED | Squad not in keep-list as live |

## Out of scope for implementer blame

- Boss Reload Window
- OAuth in browser after plugin already authed
- Mass skill install without Ask-once shortlist Да
