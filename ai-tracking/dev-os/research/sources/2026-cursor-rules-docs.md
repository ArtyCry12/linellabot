---
source_id: 2026-cursor-rules-docs
title: Cursor Rules Documentation
url: https://cursor.com/docs/rules
source_class: E
domain: ai-dev-environments
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Four rule types: Project Rules (`.mdc` in `.cursor/rules/`), User Rules, Team Rules, AGENTS.md. Application modes: Always Apply, Apply Intelligently, Apply to Specific Files, Apply Manually (@mention). Precedence: Team → Project → User.

## Architectural patterns observed

- `.mdc` required for project rules (plain `.md` in rules folder ignored)
- AGENTS.md as simpler alternative in project root + nested subdirs
- Team rules for org-wide enforcement (Enterprise)

## Why built this way

Layered precedence resolves conflicts; path-scoped and manual rules reduce token load vs always-on.

## Applicable to Cursor Dev OS?

Hub uses on-demand `.mdc` + AGENTS.md stack. **Do not** add always-on dev-os rule — Apply Manually matches Phase 3 decision.

## Conflicts with other sources

None
