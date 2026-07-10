---
source_id: 2026-letta-memfs
title: Letta Code Memory (MemFS)
url: https://docs.letta.com/letta-code/memory/
source_class: B
domain: memory-systems
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Letta: git-backed MemFS projects memory as markdown files with YAML frontmatter; system/ always in prompt, other paths loaded on demand; agent self-edits memory.

## Architectural patterns observed

- Memory filesystem (versioned, inspectable)
- Tiered prompt inclusion (system/ vs lazy load)
- Memory subagents (dream/doctor) with git worktrees
- Skills stored in agent memory (portable)

## Why built this way

Git gives audit trail + human editability; hierarchy controls context window bloat

## Applicable to Cursor Dev OS?

Strong pattern for ai-tracking/dev-os/ + promotion to skills/; aligns with Obsidian optional PKM

## Conflicts with other sources

Mem0 prefers opaque managed store — Letta prefers transparent files
