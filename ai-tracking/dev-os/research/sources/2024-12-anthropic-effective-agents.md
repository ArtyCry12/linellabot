---
source_id: 2024-12-anthropic-effective-agents
title: Building Effective AI Agents (Anthropic)
url: https://www.anthropic.com/research/building-effective-agents
source_class: C
domain: multi-agent
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Anthropic recommends simplest solution first; increase complexity only when needed. Favor workflows over autonomous multi-agent when possible.

## Architectural patterns observed

- Prompt chaining, routing, parallelization, orchestrator-workers, evaluator-optimizer
- Single LLM + tools often sufficient

## Common failure modes

Over-engineering multi-agent; unclear tool boundaries; compounding error rates across agents

## Why built this way

Each agent hop adds failure surface; simplicity improves reliability and debuggability

## Applicable to Cursor Dev OS?

**Anti-premature-architecture anchor.** Research gate aligns: do not fix Squad/roster until evidence shows need

## Conflicts with other sources

LangGraph/LangChain push multi-agent patterns — use when measured complexity requires it
