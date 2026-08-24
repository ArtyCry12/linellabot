# Phase 1 Customize DB — boss summary (delivered 2026-08-24)

Chat 66e654e8 died before this reached the UI. Disk artifacts were already complete 2026-08-17.

## Counts

| Layer | Count |
|-------|------:|
| Plugins (cache inventory) | 44 (20 started in MCP logs; UI on/off unknown) |
| Skills SKILL.md on disk | 1806 |
| Live MCP | 6 = profile **design** |
| MCP store | 21 |
| Subagents | 45 |
| Rules | 147 |
| Commands | 166 |
| Hooks entries | 10 |
| Git repos under Users\artyo (paths) | 24 / ~13 names |
| Junk candidates | 21 |

## Skills by bucket

hub-top 897 · plugin 376 · od-repo 277 · agents 149 · archive 76 · skills-cursor 20 · codex 11

## Live MCP ids

memory · gitnexus · open-design · stitch · 21st · context7 (heap 1536)

## Top junk (approval required to delete)

1. npm-cache ~5080 MB  
2. .venv-markitdown ~311 MB  
3. .cache / security-hub cache ~266 MB  
4. plugins/cache ~195 MB  
5. Cursor logs ~106 MB  
6. open-design/repo ~92 MB (not delete without design plan)  
7. OneDrive CursorMigrate copies (repos)  

## Stop gate

**Phase 1 applied zero deletes / profile flips / commits.**  
Next = approval on `phase2-candidates.json` and/or MASTER target architecture.

Canonical files: `INDEX.md` · `architecture.md` · `phase2-candidates.json` · `verify-log.md`
