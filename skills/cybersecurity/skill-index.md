# Cybersecurity skill index (754 skills)

Library root: `C:/Users/Asus/.cursor/skills/cybersecurity/library/Anthropic-Cybersecurity-Skills-main/`

Path pattern: `library/Anthropic-Cybersecurity-Skills-main/skills/<name>/SKILL.md`

**Project / repo security (default for app codebases):** [project-security-index.md](project-security-index.md)

**Search all skills:** `node C:/Users/Asus/.cursor/skills/cybersecurity/scripts/find-skill.mjs <keywords>`

**Machine index:** `library/Anthropic-Cybersecurity-Skills-main/index.json`

## Domains (from pack README)

| Domain | ~Skills | Example skill names (grep / find-skill) |
|--------|---------|----------------------------------------|
| Cloud Security | 60 | `auditing-aws-s3-bucket-permissions`, `analyzing-azure-activity-logs-for-threats` |
| Threat Hunting | 55 | `hunting-for-lolbas-execution`, `detecting-lateral-movement` |
| Threat Intelligence | 50 | `analyzing-indicators-of-compromise`, STIX/MISP skills |
| Web Application Security | 42 | `performing-web-application-vulnerability-triage`, OWASP skills |
| Network Security | 40 | `analyzing-network-traffic-for-incidents` |
| Malware Analysis | 39 | `analyzing-malware-behavior-with-cuckoo-sandbox` |
| Digital Forensics | 37 | `performing-memory-forensics-with-volatility3` |
| Security Operations | 36 | SIEM / log correlation skills |
| Identity & Access Management | 35 | Kerberos, AD, IAM policy skills |
| SOC Operations | 33 | playbooks, tabletop, metrics |
| Container Security | 30 | `hardening-docker-containers-for-production` |
| OT/ICS Security | 28 | Modbus, SCADA, IEC skills |
| API Security | 28 | `testing-api-security-with-owasp-top-10` |
| Vulnerability Management | 25 | `building-vulnerability-scanning-workflow` |
| Incident Response | 25 | ransomware / breach response |
| Red Teaming | 24 | **authorized engagements only** |
| Penetration Testing | 23 | **authorized engagements only** |
| Endpoint Security | 17 | EDR, persistence hunting |
| DevSecOps | 17 | `implementing-devsecops-security-scanning` |
| Phishing Defense | 16 | email auth, BEC |
| Cryptography | 14 | TLS, cert transparency |
| Zero Trust | 13 | microsegmentation, BeyondCorp |
| Mobile Security | 12 | Android/iOS analysis |
| Ransomware Defense | 7 | precursor detection, recovery |
| Compliance & Governance | 5 | CIS, SOC 2 |
| Deception Technology | 2 | honeytokens |

## How to pick a skill

1. If the user says **project security**, **secure this repo**, **CI/CD**, **dependencies**, **Terraform**, **K8s** → start at [project-security-index.md](project-security-index.md).
2. Else match **domain** from the table, then run `find-skill.mjs` with 2–4 keywords.
3. Read **only** the chosen skill's `SKILL.md` (frontmatter + workflow). Load `references/` when that file points there.
4. Map results to MITRE / NIST using each skill's `references/standards.md` when reporting to stakeholders.

## Framework assets

| Asset | Path |
|-------|------|
| ATT&CK Navigator layer | `library/.../mappings/attack-navigator-layer.json` |
| OWASP mappings | `library/.../mappings/owasp/` |
| NIST CSF | `library/.../mappings/nist-csf/` |
| Coverage doc | `library/.../ATTACK_COVERAGE.md` |

## License

Apache-2.0 — community pack by [mukul975/Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills). Not affiliated with Anthropic PBC.
