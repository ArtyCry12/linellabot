---
name: code-review-pro
description: >-
  Hub wrapper for onewave-ai code-review-pro — security, performance, refactor
  depth. Triggers: deep code review, code audit, @code-review-pro.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  source: onewave-ai/claude-skills
  upstream: "~/.agents/skills/code-review-pro"
when_to_use: deep_code_review, security_performance_audit, refactor_opportunities
---

# Code Review Pro (hub wrapper)

Upstream: `C:/Users/Asus/.agents/skills/code-review-pro/SKILL.md`

## Read first

1. This wrapper
2. Upstream SKILL

## Routing note

- GitHub PR confidence scoring → `skills/pr-review/` + route `pr-review`
- Ad-hoc / local deep review → **this** skill
