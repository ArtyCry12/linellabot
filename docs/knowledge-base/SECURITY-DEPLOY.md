# Security & deploy awareness (REQ-066)

Complements `rules/ai-coding-security.mdc` and `skills/cybersecurity/`.

## Deploy checklist

- [ ] No secrets in git (mcp.json gitignored, secrets.local.json gitignored)
- [ ] `.env` never committed
- [ ] Preview deploy before production
- [ ] HTTPS only for auth callbacks
- [ ] Rate limits on public APIs

## AI coding blindspots (REQ-067–068)

| Risk | Mitigation |
|------|------------|
| SQLi | Parameterized queries only |
| XSS | Escape output; CSP headers |
| Leaked keys | grep pre-commit; rotate if exposed |
| Half-implemented API | Typecheck + integration test |
| Type drift | strict TypeScript |

## Hub-specific

- Apify: APIFY-POLICY cost gates
- OAuth files: `ai-tracking/google-oauth-client.json` only local
- Zapier writes: confirm before execute

## Notes attachment (Notion)

If `Notes_260706` security PDF arrives — drop summary in `ai-tracking/security-notes-import.md` for agent context.
