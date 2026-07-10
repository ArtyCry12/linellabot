---
source_id: 2026-production-memory-frameworks
title: Production Memory Frameworks Comparison
url: https://jatinbansal.com/ai-engineering/production-memory-frameworks/
source_class: D
domain: memory-systems
date_reviewed: 2026-07-01
confidence: medium
---

# Source extraction card

## Summary

Compares Letta (hierarchical core/recall/archival), mem0 (distill-at-write vector), Zep/Graphiti (bi-temporal graph). Tradeoffs: write cost, read latency, bi-temporal audit, multi-tenancy.

## Applicable to Cursor Dev OS?

Decision matrix for when hub should stay file-based vs adopt external memory service

## Why built this way

No one-size-fits-all — substrate choice follows read/write profile and audit needs
