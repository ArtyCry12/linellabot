# Naming / structure — wave applied 2026-08-26 (Boss YES)

**Policy was:** dry-run then implement after yes. **Status:** commands/docs Asus→artyo wave **done**. Mass prose rewrite inside every `blocks/design/skills/*` body — still optional later.

## Done this wave

| Area | Change |
|------|--------|
| clone-website.md, seo-geo.md, foundation-refresh.md, stitch-mcp.md, repo.md, n8n-mcp.md | artyo / blocks paths |
| install-agency-agents, hub-supply-scan, bumblebee-scan, cursor-system-cleanup, cursor-system-audit, hub-archive-to-github | dynamic USERPROFILE / HubRoot |
| prompt-lesson-tts | no huashu voiceover fallback |
| markitdown-test sample path | artyo |
| hub-safe-cleanup / cleanup | match Asus **and** artyo temp/project folder names |

## Still intentional

| Item | Why |
|------|-----|
| `@huashu` alias + shim `huashu-sync-…` | compat |
| `migrate-*` / RESTORE docs saying Asus→artyo | migration history |
| Folder names `projects/c-Users-Asus-cursor-*` on disk | real legacy folder ids |
| Prose “huashu” inside many design skill bodies | optional later pass |

## Cache T0 Apply (same Boss YES)

Ran `cache-auto-sweep.ps1 -Tier T0 -Apply` — freed ~4.7 MB; report in `cache-sweep-last.json`.
