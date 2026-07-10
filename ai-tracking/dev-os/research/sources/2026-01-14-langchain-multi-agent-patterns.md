---
source_id: 2026-01-14-langchain-multi-agent-patterns
title: Choosing the Right Multi-Agent Architecture
url: https://www.langchain.com/blog/choosing-the-right-multi-agent-architecture
source_class: B
domain: multi-agent
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

LangChain identifies four foundational patterns: subagents, skills, handoffs, routers — each for different decomposition problems.

## Architectural patterns observed

- Subagents (delegated specialists)
- Skills (packaged capability modules)
- Handoffs (explicit responsibility transfer)
- Routers (classification → path)

## Why built this way

Modular vocabulary lets teams pick minimal pattern instead of defaulting to full orchestration framework

## Applicable to Cursor Dev OS?

Maps directly: Cursor subagents = subagents pattern; skills/ = skills pattern; Dev OS research = router to domain modules

## Conflicts with other sources

Overlaps LangGraph supervisor — complementary (LangChain = taxonomy, LangGraph = runtime)
