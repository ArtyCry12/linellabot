# Project security — curated skill routes

Use when securing **this repository**, **CI/CD**, **cloud/IaC**, **containers**, or **the running app** — not full red-team / DFIR unless the user explicitly authorizes offensive work.

Library path pattern:

`library/Anthropic-Cybersecurity-Skills-main/skills/<skill-name>/SKILL.md`

Discover more: `node scripts/find-skill.mjs <keywords>`

## Secure development & CI/CD (DevSecOps)

| Skill | Load when |
|-------|-----------|
| [implementing-devsecops-security-scanning](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-devsecops-security-scanning/SKILL.md) | DevSecOps gates, shift-left scanning overview |
| [building-devsecops-pipeline-with-gitlab-ci](library/Anthropic-Cybersecurity-Skills-main/skills/building-devsecops-pipeline-with-gitlab-ci/SKILL.md) | GitLab CI security stages |
| [integrating-sast-into-github-actions-pipeline](library/Anthropic-Cybersecurity-Skills-main/skills/integrating-sast-into-github-actions-pipeline/SKILL.md) | SAST in GitHub Actions |
| [implementing-github-advanced-security-for-code-scanning](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-github-advanced-security-for-code-scanning/SKILL.md) | GitHub Advanced Security / CodeQL |
| [securing-github-actions-workflows](library/Anthropic-Cybersecurity-Skills-main/skills/securing-github-actions-workflows/SKILL.md) | Workflow hardening, OIDC, supply chain |
| [implementing-secrets-scanning-in-ci-cd](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-secrets-scanning-in-ci-cd/SKILL.md) | Secret leaks in pipelines |
| [implementing-secret-scanning-with-gitleaks](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-secret-scanning-with-gitleaks/SKILL.md) | Gitleaks in repo/CI |
| [performing-sca-dependency-scanning-with-snyk](library/Anthropic-Cybersecurity-Skills-main/skills/performing-sca-dependency-scanning-with-snyk/SKILL.md) | Dependency / SCA |
| [analyzing-sbom-for-supply-chain-vulnerabilities](library/Anthropic-Cybersecurity-Skills-main/skills/analyzing-sbom-for-supply-chain-vulnerabilities/SKILL.md) | SBOM review |
| [implementing-infrastructure-as-code-security-scanning](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-infrastructure-as-code-security-scanning/SKILL.md) | IaC scanning (Checkov, etc.) |
| [auditing-terraform-infrastructure-for-security](library/Anthropic-Cybersecurity-Skills-main/skills/auditing-terraform-infrastructure-for-security/SKILL.md) | Terraform misconfigs |

## Application & API security

| Skill | Load when |
|-------|-----------|
| [testing-api-security-with-owasp-top-10](library/Anthropic-Cybersecurity-Skills-main/skills/testing-api-security-with-owasp-top-10/SKILL.md) | API OWASP Top 10 |
| [conducting-api-security-testing](library/Anthropic-Cybersecurity-Skills-main/skills/conducting-api-security-testing/SKILL.md) | API test workflow |
| [integrating-dast-with-owasp-zap-in-pipeline](library/Anthropic-Cybersecurity-Skills-main/skills/integrating-dast-with-owasp-zap-in-pipeline/SKILL.md) | DAST in CI |
| [performing-web-application-vulnerability-triage](library/Anthropic-Cybersecurity-Skills-main/skills/performing-web-application-vulnerability-triage/SKILL.md) | Triage scanner findings |
| [performing-threat-modeling-with-owasp-threat-dragon](library/Anthropic-Cybersecurity-Skills-main/skills/performing-threat-modeling-with-owasp-threat-dragon/SKILL.md) | Threat modeling |
| [exploiting-insecure-deserialization](library/Anthropic-Cybersecurity-Skills-main/skills/exploiting-insecure-deserialization/SKILL.md) | Deserialization risks (defensive review) |

## Containers & Kubernetes

| Skill | Load when |
|-------|-----------|
| [hardening-docker-containers-for-production](library/Anthropic-Cybersecurity-Skills-main/skills/hardening-docker-containers-for-production/SKILL.md) | Docker hardening |
| [implementing-aqua-security-for-container-scanning](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-aqua-security-for-container-scanning/SKILL.md) | Image scanning |
| [auditing-kubernetes-cluster-rbac](library/Anthropic-Cybersecurity-Skills-main/skills/auditing-kubernetes-cluster-rbac/SKILL.md) | K8s RBAC audit |
| [implementing-kubernetes-pod-security-standards](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-kubernetes-pod-security-standards/SKILL.md) | PSS / pod security |
| [performing-kubernetes-cis-benchmark-with-kube-bench](library/Anthropic-Cybersecurity-Skills-main/skills/performing-kubernetes-cis-benchmark-with-kube-bench/SKILL.md) | CIS kube-bench |

## Vulnerability & compliance posture

| Skill | Load when |
|-------|-----------|
| [building-vulnerability-scanning-workflow](library/Anthropic-Cybersecurity-Skills-main/skills/building-vulnerability-scanning-workflow/SKILL.md) | VM program / scanning cadence |
| [implementing-epss-score-for-vulnerability-prioritization](library/Anthropic-Cybersecurity-Skills-main/skills/implementing-epss-score-for-vulnerability-prioritization/SKILL.md) | Prioritize CVEs |
| [auditing-cloud-with-cis-benchmarks](library/Anthropic-Cybersecurity-Skills-main/skills/auditing-cloud-with-cis-benchmarks/SKILL.md) | Cloud CIS |
| [auditing-aws-s3-bucket-permissions](library/Anthropic-Cybersecurity-Skills-main/skills/auditing-aws-s3-bucket-permissions/SKILL.md) | S3 exposure |
| [auditing-gcp-iam-permissions](library/Anthropic-Cybersecurity-Skills-main/skills/auditing-gcp-iam-permissions/SKILL.md) | GCP IAM |

## Incident-ready (read-only / defensive)

| Skill | Load when |
|-------|-----------|
| [analyzing-indicators-of-compromise](library/Anthropic-Cybersecurity-Skills-main/skills/analyzing-indicators-of-compromise/SKILL.md) | IOC triage from alerts |
| [analyzing-kubernetes-audit-logs](library/Anthropic-Cybersecurity-Skills-main/skills/analyzing-kubernetes-audit-logs/SKILL.md) | K8s audit forensics |

## Default project-security chain

1. Scope: repo stack (language, CI, cloud, k8s, auth).
2. Pick **2–4 skills** from tables above (smallest set that covers the ask).
3. Run `find-skill.mjs` if no table row fits.
4. Deliver: findings by severity, file/line or config path, remediation, verification step from each skill's **Verification** section.

**Authorization:** Do not run exploitation, phishing, or active scanning against systems the user does not own or lacks written permission to test.
