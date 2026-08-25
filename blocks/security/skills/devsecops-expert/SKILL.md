---
name: devsecops-expert
description: >-
  Hub wrapper for martinholovsky devsecops-expert — secure CI/CD, SAST/DAST,
  container and supply-chain gates. Triggers: devsecops, secure pipeline,
  @devsecops-expert.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  source: martinholovsky/claude-skills-generator
  upstream: "~/.agents/skills/devsecops-expert"
when_to_use: devsecops_pipeline, security_gates_cicd, container_scanning
---

# DevSecOps Expert (hub wrapper)

Upstream: `C:/Users/Asus/.agents/skills/devsecops-expert/SKILL.md`

## Read first

1. This wrapper
2. Upstream SKILL

## Routing note

- CI failure triage → route `ci-debug`
- Pipeline security design → **this** skill
