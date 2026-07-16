---
name: cloudflare-security-audit
description: >-
  Hub wrapper for cloudflare/security-audit-skill — exploitable codebase
  security review. Triggers: cloudflare security audit, pen test code,
  @cloudflare-security-audit.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  source: cloudflare/security-audit-skill
  upstream: "~/.agents/skills/security-audit"
when_to_use: codebase_security_audit, exploitable_vuln_hunt, cloudflare_audit
---

# Cloudflare Security Audit (hub wrapper)

Upstream: `C:/Users/Asus/.agents/skills/security-audit/SKILL.md`

## Read first

1. This wrapper
2. Upstream SKILL

## Routing note

- Hub route `security-audit` → `skills/cybersecurity/` + supply-chain scripts
- Focused exploitable-code audit (Cloudflare skill) → **this** skill
- Upstream folder is `security-audit`; hub id avoids clash with route id
