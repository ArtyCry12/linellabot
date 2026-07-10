---
source_id: 2026-cursor-skills-docs
title: Cursor Skills Help
url: https://cursor.com/help/customization/skills
source_class: E
domain: ai-dev-environments
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Skills = multi-step reusable workflows in `SKILL.md`. Discovery paths: `.cursor/skills/`, `~/.cursor/skills/`, `.agents/skills/`, nested monorepo dirs, Claude/Codex compat paths. Invoke via `/name` or `@`. `/migrate-to-skills` converts eligible rules (not alwaysApply/globs).

## Architectural patterns observed

- Skills scoped by directory in monorepos (auto surface when working in subtree)
- Rules vs skills: short constraints vs long procedures
- Built-in `/create-skill` scaffolding

## Why built this way

Procedural knowledge shouldn't bloat every session; nested discovery matches repo structure.

## Applicable to Cursor Dev OS?

Hub pattern: `skills/dev-os/` with sub-skills (research, decision, memory, emergence). Global skills in `~/.agents/skills/`. Matches Cursor native discovery.

## Conflicts with other sources

None
