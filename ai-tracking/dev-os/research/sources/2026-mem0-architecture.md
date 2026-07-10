---
source_id: 2026-mem0-architecture
title: Mem0 Platform Architecture
url: https://github.com/mem0ai/mem0/blob/HEAD/skills/mem0/references/architecture.md
source_class: A
domain: memory-systems
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Mem0: managed memory layer — add/search API, vector + entity stores, ADD-only extraction v3, multi-tenant scoping (user/session/agent/run).

## Architectural patterns observed

- Write path: LLM extraction + dedup + entity linking
- Read path: multi-signal fusion (semantic, BM25, entity)
- Session vs user memory layers

## Limits

External dependency; async write delay; LLM cost on every add

## Why built this way

Raw vector DB lacks extraction/dedup; chat history unbounded and not cross-session

## Applicable to Cursor Dev OS?

Compare to user-memory MCP + ai-tracking tiers; candidate for external LTM if hub outgrows file corpus
