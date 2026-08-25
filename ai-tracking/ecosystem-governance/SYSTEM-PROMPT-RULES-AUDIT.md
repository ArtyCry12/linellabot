# System Prompt / Rules audit (2026-08-25)

## Findings

| Surface | Issue | Action taken |
|---------|-------|----------------|
| Cursor User Rules | open-design rule pointed at legacy `huashu-design` | Updated to `skills/open-design` |
| Cursor User Rules | No governance pointer | Added rule «Ecosystem governance (hub)» |
| Hub always-on (~8) | Acceptable; do not inflate | Keep |
| Dual `rules/` + `.cursor/rules/` | Sync via huashu-sync | Keep + sync (not merge) |
| AGENTS.md | GitNexus + stack ok | Minor: ensure SEO block pointer if missing |
| `.cursorignore` | Present from phase 3 | Keep |
| System Prompt (product) | Not fully editable as single file | User Rules + AGENTS act as high-level |

## Deliberate non-changes

- Did not collapse dual rules trees
- Did not strip agency rules
- Did not rewrite all always-on into one mega-rule
