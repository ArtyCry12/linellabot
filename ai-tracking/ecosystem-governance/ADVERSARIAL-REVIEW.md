# Adversarial review checklist (substantial changes)

Run for each substantial hub or project change (Architect or squad-review).

## Hunt

1. How can this break under unexpected input?
2. How can it be misused / bypassed?
3. Edge cases and race conditions?
4. Conflicts with existing hooks/rules/MCP profiles?
5. Hidden dependencies / stale docs paths?
6. Secrets leakage / logging PII?
7. Privilege / destructive path without gate?
8. Architectural coupling that blocks quarantine?

## Record

Short note in PR/commit body or `ai-tracking/ecosystem-governance/reports/`:

```text
Adversarial: <change>
Risks found: …
Mitigations: …
Residual: …
```

## Automation

- Aikido / security-hub for code scans when code changes
- This checklist is mandatory **process**, not a new always-on agent
