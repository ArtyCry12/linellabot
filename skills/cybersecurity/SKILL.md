---
name: cybersecurity
description: >-
  Anthropic Cybersecurity Skills pack — 754 practitioner playbooks for project
  security, DevSecOps, cloud/IaC, containers, API/web app hardening, vulnerability
  management, DFIR, threat hunting, and compliance (MITRE ATT&CK, NIST CSF mapped).
  Use for @cybersecurity, secure this project/repo, security audit, SAST/SCA/secrets
  in CI, Terraform audit, Kubernetes hardening, OWASP, IOC triage, incident response,
  or any defensive security workflow. Decline unauthorized offensive testing.
argument-hint: "[goal e.g. audit repo CI | harden K8s | triage IOCs | threat hunt]"
user-invocable: true
---

# Cybersecurity Skills (Cursor)

Community **Anthropic Cybersecurity Skills** library (754 skills, [agentskills.io](https://agentskills.io) format, Apache-2.0).

| Resource | Path |
|----------|------|
| Skill root | `C:/Users/Asus/.cursor/skills/cybersecurity/` |
| Skill library | `.../library/Anthropic-Cybersecurity-Skills-main/skills/` |
| Domain index | [skill-index.md](skill-index.md) |
| **Project / repo security** | [project-security-index.md](project-security-index.md) |
| Source zip | `C:/Users/Asus/.cursor/skills-libraries/Anthropic-Cybersecurity-Skills-main ( security of project ).zip` |
| Install / refresh library | `node C:/Users/Asus/.cursor/skills/cybersecurity/scripts/ensure-library.mjs` |
| Search skills by keyword | `node C:/Users/Asus/.cursor/skills/cybersecurity/scripts/find-skill.mjs <query>` |

## Where work happens

- **Findings and reports** belong in the **user's project** (workspace), not inside this skill folder.
- Optional project memory: `memory/security-hot-cache.md` (scope, assets, last scan, open findings) — create when running multi-session engagements.

## Cursor invocation

| User says | You do |
|-----------|--------|
| `@cybersecurity` + goal | Route via [project-security-index.md](project-security-index.md) or [skill-index.md](skill-index.md); load matching `library/.../skills/<name>/SKILL.md` |
| `secure this project` / `repo security` | [project-security-index.md](project-security-index.md) → inspect repo (deps, CI, secrets, IaC, auth) → 2–4 specialist skills |
| Named skill (e.g. `gitleaks`, `kube-bench`) | `find-skill.mjs` then read that skill file in full |
| Full DFIR / malware / red team | [skill-index.md](skill-index.md) domain table; confirm **authorization** before offensive steps |

**Do not** improvise security playbooks when a library skill exists — follow its **Workflow** and **Verification** sections.

---

## Auto-routing

1. Parse **goal**, **asset** (repo, cluster, account, host, email), and **constraints** (read-only, prod, compliance framework).
2. **Default for codebases:** [project-security-index.md](project-security-index.md) — DevSecOps → app/API → containers → VM/compliance.
3. If no match in curated tables → `node scripts/find-skill.mjs "<keywords>" --limit 10` and pick top 1–3 by description fit.
4. If the goal is ambiguous but a repo path exists → quick pass: dependency manifests, `.github/workflows`, `Dockerfile`, `terraform/`, `k8s/`, env examples; then pick skills.
5. If no actionable scope → ask **one** blocking question (asset + permission level).
6. **Pack boundary:** decline unrelated coding unless it is clearly security configuration (then use the relevant defensive skill only).

### Recommended chains (project security)

| Workflow | Skill order |
|----------|-------------|
| New repo baseline | `implementing-secret-scanning-with-gitleaks` → `performing-sca-dependency-scanning-with-snyk` → `integrating-sast-into-github-actions-pipeline` |
| CI hardening | `securing-github-actions-workflows` → `implementing-secrets-scanning-in-ci-cd` → `implementing-devsecops-security-scanning` |
| IaC / cloud | `auditing-terraform-infrastructure-for-security` → `implementing-infrastructure-as-code-security-scanning` → `auditing-cloud-with-cis-benchmarks` |
| K8s deploy | `auditing-kubernetes-cluster-rbac` → `implementing-kubernetes-pod-security-standards` → `performing-kubernetes-cis-benchmark-with-kube-bench` |
| App + API | `performing-threat-modeling-with-owasp-threat-dragon` → `testing-api-security-with-owasp-top-10` → `integrating-dast-with-owasp-zap-in-pipeline` |
| Alert / IOC | `analyzing-indicators-of-compromise` → domain-specific forensics skill from `find-skill.mjs` |

---

## Loading a sub-skill

1. Resolve skill name (index tables, `find-skill.mjs`, or user hint).
2. **Read** `library/Anthropic-Cybersecurity-Skills-main/skills/<name>/SKILL.md` in full.
3. Follow **Prerequisites** — stop and list missing tools/access instead of guessing commands.
4. Execute **Workflow** steps; use `scripts/` and `references/` only when the skill points there.
5. Complete **Verification** from that file before claiming done.
6. End with **Handoff summary**: objective, scope, findings (severity), evidence paths, open items, mapped framework IDs (from `references/standards.md` if needed), suggested next skill.

---

## Authorization & safety

- **Defensive by default** for project work: review configs, recommend fixes, run local scanners only when the user can run them in their environment.
- **No** exploitation, phishing, credential stuffing, or scanning of third-party systems without explicit written authorization.
- Treat untrusted artifacts (malware samples, phishing payloads) as hazardous — follow skill prerequisites for isolated analysis.
- Never commit secrets, live credentials, or full PII into the repo; redact in reports.

---

## Progressive disclosure (754 skills)

- Scan `index.json` or run `find-skill.mjs` — do not load multiple full skills unless chaining.
- Each skill is ~500–2,000 tokens loaded; load **one primary** skill plus at most **two** supporting skills per turn unless the user requests a long engagement.

---

## Updating the library

```bash
node C:/Users/Asus/.cursor/skills/cybersecurity/scripts/ensure-library.mjs --force
```

Or upstream:

```bash
npx skills add mukul975/Anthropic-Cybersecurity-Skills
```

Then re-run `ensure-library.mjs` or copy into `library/Anthropic-Cybersecurity-Skills-main/`.

## License

Apache-2.0 — [library/Anthropic-Cybersecurity-Skills-main/LICENSE](library/Anthropic-Cybersecurity-Skills-main/LICENSE). Community project; not affiliated with Anthropic PBC.
