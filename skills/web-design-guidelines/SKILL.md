---
name: web-design-guidelines
description: >-
  Hub wrapper for Vercel Web Interface Guidelines review. Use when auditing UI,
  accessibility, UX review, or compliance with web best practices. Triggers:
  web guidelines, review my UI, audit design, @web-design-guidelines.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  source: vercel-labs/agent-skills
  upstream: "~/.agents/skills/web-design-guidelines"
when_to_use: ui_audit, accessibility_review, web_guidelines
---

# Web Design Guidelines (hub wrapper)

Upstream (do not fork): `C:/Users/Asus/.agents/skills/web-design-guidelines/SKILL.md`

## Read first

1. This wrapper (routing)
2. Full upstream SKILL

## When

| Situation | Action |
|-----------|--------|
| Review UI / a11y / UX against guidelines | Load upstream |
| Web build from scratch | Prefer `frontend-design` + `design-taste-frontend`; guidelines for audit pass |

## Do not

- Replace `frontend-design` anti-slop gate
- Edit upstream copies in `~/.agents/skills/`
