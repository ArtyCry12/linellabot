---
source_id: 2026-anthropic-harness-long-running
title: Harness Design for Long-Running Application Development
url: https://www.anthropic.com/engineering/harness-design-long-running-apps
source_class: C
domain: context-engineering
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Long tasks need harness design: context resets vs compaction, specialized agents (planner/builder), file-based handoffs, model-specific context anxiety behaviors.

## Architectural patterns observed

- Context reset with structured handoff artifact
- In-place compaction (continuity, anxiety persists)
- Multi-agent via files not shared chat
- Re-examine harness when new models ship

## Common failure modes

Compaction alone insufficient for context anxiety; premature wrap-up near perceived limit

## Applicable to Cursor Dev OS?

Supports Dev OS lifecycle (Explore→Learn), background subagents, ai-tracking handoff files

## Why built this way

Model behavior changes — harness must be empirical not static
