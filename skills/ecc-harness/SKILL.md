---
name: ecc-harness
description: >-
  ECC (Everything Claude Code) patterns adapted for Cursor hub — instincts,
  session caps, security bridge, research-first. Triggers: ecc, instincts,
  harness, affaan-m/ECC. Install: commands/ensure-ecc.ps1.
argument-hint: "[status | sync-instincts]"
user-invocable: true
---

# ECC harness (Cursor adaptation)

Source repo: [affaan-m/ECC](https://github.com/affaan-m/ECC) — shallow clone at `lib/ecc-src/` (gitignored).

## Hub mapping

| ECC concept | Hub artifact |
|-------------|--------------|
| Instincts | `ai-tracking/instincts/` + seed |
| Session caps | `docs/knowledge-base/TOKEN-MEMORY-POLICY.md` |
| Skills/hooks | this skill + `commands/ensure-ecc.ps1` |
| Security | `rules/cybersecurity.mdc` |
| Research-first | `skills/dev-os/` |

## When to use

- User asks about ECC or agent harness patterns
- After `ensure-ecc.ps1` — sync instincts from ECC docs if newer patterns found
- Long sessions — enforce token/memory caps from policy doc

## Commands

- `commands/ensure-ecc.ps1` — clone/update ecc-src, verify instincts
- `commands/mcp-health.ps1` — stack health (includes ECC status)

## Do not

- Blind fork entire ECC into hub rules
- Inject more than 6 instincts per session
