---
name: security-hub
description: >
  Orchestrates project security: AI diff review, secrets/SAST/SCA/IaC scans,
  and authorized DAST/recon (ZAP, Nuclei, httpx, subfinder). Routes to
  cybersecurity library playbooks; runs hub CLI adapters. Triggers: security
  audit, security hub, @security-hub, gitleaks, semgrep, trivy, checkov, zap,
  nuclei, dast, recon. Decline unauthorized offensive scanning of third parties.
argument-hint: "[tier|goal e.g. secrets | dast https://lab.example]"
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  phase: "1"
when_to_use: security_audit, dast, recon, sast, sca, secrets_scan
---

# Security Hub

Front door for hub security work. Does **not** vendor Metasploit/sqlmap/etc.
Phase 1: defensive CI + authorized DAST/recon. Offensive/lab → Phase 2.

| Resource | Path |
|----------|------|
| Tool matrix | [tool-matrix.json](tool-matrix.json) |
| Findings schema | [findings.schema.json](findings.schema.json) |
| Auth gate | [references/auth-gate.md](references/auth-gate.md) |
| Orchestration patterns | [references/orchestration-patterns.md](references/orchestration-patterns.md) |
| Diff AI prompts | [prompts/](prompts/) |
| Ensure tools | `commands/ensure-security-tools.ps1` |
| Scan runner | `commands/security-scan.ps1` |
| CI templates | `templates/security-ci/` |
| Library | `skills/cybersecurity/` + `project-security-index.md` |

## Workflow

1. **Classify** intent: `diff-ai` | `secrets` | `sast` | `sca` | `iac` | `dast` | `recon` | `baseline` (multi).
2. **Auth gate** for `dast` / `recon`: read [auth-gate.md](references/auth-gate.md). Stop if unauthorized.
3. **Pick skills**: 1 primary + ≤2 supporting from cybersecurity index / `find-skill.mjs`.
4. **Run tools** (if on PATH): `powershell -File commands/security-scan.ps1 -Tier <tier> ...`
5. **Normalize** output to findings schema; severity-sort; handoff.

## Diff AI review

For PR/branch/uncommitted security review:

1. Load [prompts/audit.md](prompts/audit.md) + [prompts/false-positive-filter.md](prompts/false-positive-filter.md).
2. Prefer `skills-cursor/review-security` subagent; pass Custom Instructions pointing at those prompts.
3. Apply hard FP exclusions from false-positive-filter before reporting.

## Default chains

| Goal | Order |
|------|-------|
| New repo baseline | secrets → sast → sca → (iac if terraform/k8s) |
| PR security | diff-ai → secrets on changed files |
| Authorized web target | dast (ZAP) → optional nuclei; browser smoke via Playwright MCP |
| Recon (owned domain) | subfinder → httpx → nuclei (gated) |

## Commands (agent)

```powershell
powershell -File commands/ensure-security-tools.ps1
powershell -File commands/security-scan.ps1 -Tier secrets
powershell -File commands/security-scan.ps1 -Tier sast
powershell -File commands/security-scan.ps1 -Tier sca
powershell -File commands/security-scan.ps1 -Tier iac
# DAST / recon REQUIRE -Authorized
powershell -File commands/security-scan.ps1 -Tier dast -TargetUrl "https://lab.example" -Authorized
powershell -File commands/security-scan.ps1 -Tier recon -TargetHost "example.com" -Authorized
```

Missing binaries → report from health JSON; do not invent scan results.

## Safety

- No third-party host scanning without explicit user authorization in-session.
- No exploit PoCs, Metasploit, sqlmap in Phase 1.
- AI PR review on untrusted forks: warn about prompt injection; recommend maintainer approval before workflow run.
- Findings/reports live in the **user project** or `.cache/security-hub/`, not inside this skill folder as secrets.

## Handoff summary

Objective, tier(s), findings by severity, evidence paths under `.cache/security-hub/`, missing tools, next skill from cybersecurity library.
