# Auth gate (DAST / recon)

Phase 1 Security Hub **must not** scan hosts the user does not own or explicitly authorize.

## Required before any dast/recon CLI

All of the following:

1. User states a concrete target (`https://...` or hostname).
2. User confirms authorization in the same session with clear language, e.g. `authorized`, `это мой стенд`, `-Authorized` on the scan command.
3. Agent records in the reply (and optionally user-memory): target + that authorization was given.

## Hard deny

- Public random domains, competitors, “just check this site”, third-party SaaS without written permission.
- Missing `-Authorized` on `security-scan.ps1 -Tier dast|recon` → script exits non-zero.
- Private IP / localhost allowed only with authorization (local lab still needs the switch).

## Allowlist (optional)

File: `ai-tracking/security-auth-allowlist.json` (gitignored patterns OK):

```json
{
  "hosts": ["lab.local", "juice.example"],
  "urls": ["https://staging.myapp.example"]
}
```

If allowlist exists and target matches → still require `-Authorized` once per session for clarity, but agent may treat match as supporting evidence.

## After gate passes

Proceed with ZAP baseline / nuclei / subfinder+httpx only against that target. Cap scope: no blanket internet-wide scans.
