# Security — AI coding & deploy (REQ-066–068)

Synthesized from `cybersecurity` skill + Notion mega-prompt blindspot list.  
Full playbooks: `skills/cybersecurity/project-security-index.md`

---

## Deploy checklist

- [ ] Secrets only in env / `secrets.local.json` (gitignored)
- [ ] HTTPS enforced; HSTS on production
- [ ] Dependencies scanned (`npm audit` / cybersecurity skill)
- [ ] Rate limits on auth and write endpoints
- [ ] CORS restricted to known origins

## AI-specific risks (REQ-067–068)

| Risk | Prevention |
|------|------------|
| Invented API methods | context7 or official docs before code |
| Half-implemented auth | Test login/logout in squad-qa |
| SQL string concat | ORM or parameterized queries |
| XSS in `dangerouslySetInnerHTML` | Sanitize or avoid |
| Leaked keys in commits | pre-commit secret scan; never commit mcp.json |

## Hub files (never commit)

- `mcp.json`
- `ai-tracking/secrets.local.json`
- `ai-tracking/google-oauth-client.json`
- `ai-tracking/tools/ffmpeg.exe`

## Rule

`rules/ai-coding-security.mdc` — load for auth/API/DB tasks.

## Notion Notes_260706

Fetch attachment via Notion MCP when hardening deploy pipeline — store findings in `ai-tracking/security-notes/` (on demand).

*P2 · 2026-07-10*
