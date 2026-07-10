---
source_id: 2026-cursor-subagents-docs
title: Cursor Subagents Documentation
url: https://cursor.com/docs/subagents
source_class: E
domain: multi-agent
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Cursor native subagents: markdown in `.cursor/agents/` with YAML frontmatter (name, description, model, readonly, is_background). Parent delegates via Task; subagents get isolated context.

## Architectural patterns observed

- Foreground vs background subagents
- Project vs user scope
- Model per subagent (inherit or explicit ID)
- Description-driven auto-delegation

## Roles / agents

Parent Agent (Boss), custom subagents as files not code

## Common failure modes

Vague descriptions → no delegation; too many generic agents; context not passed in prompt

## Orchestration approach

Parent includes subagents in tool set; parallel Task calls for independent work

## Why built this way

File-based agents = versionable, team-shareable, no runtime server; fits IDE workflow

## Applicable to Cursor Dev OS?

**Primary platform pattern.** Hub already uses `agents/squad-*.md`. Dev OS gate should govern *when* to add files, not ban Squad during bootstrap.

## Conflicts with other sources

Dev OS spec says dynamic emergence; Cursor encourages explicit custom subagent files — resolved via meta-layer gate + provisional Squad label
