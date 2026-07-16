---
name: secret-scanning
description: >-
  Hub wrapper for GitHub secret scanning — push protection, custom patterns,
  alert remediation. Triggers: secret scanning, gitleaks, leaked secrets,
  @secret-scanning.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  upstream: "~/.agents/skills/secret-scanning"
when_to_use: github_secret_scanning, push_protection, secret_alert_triage
---

# Secret Scanning (hub wrapper)

Upstream: `C:/Users/Asus/.agents/skills/secret-scanning/SKILL.md`

## Read first

1. This wrapper
2. Upstream SKILL

## Routing note

- Hub supply-chain scan scripts → route `security-audit` commands
- GitHub secret scanning config → **this** skill
