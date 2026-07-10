---
source_id: 2026-03-28-langgraph-supervisor
title: LangGraph Multi-Agent Supervisor Pattern
url: https://www.abstractalgorithms.dev/langgraph-multi-agent-supervisor-pattern
source_class: A
domain: multi-agent
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

LangGraph documents three coordination patterns: supervisor+workers (dynamic routing), agent swarm (peer handoffs via Command(goto=)), and sequential pipeline. State flows through shared channels; Command return values drive runtime routing.

## Architectural patterns observed

- Hierarchical supervisor with specialist workers
- Peer handoffs without central coordinator
- Deterministic sequential pipelines
- Subgraphs for state isolation
- Parallel fan-out via Send API

## Roles / agents in this system

Supervisor (router LLM), workers (specialists), optional subgraph encapsulation

## Common failure modes

State leakage across agents without subgraphs; serial execution when parallel Send would suffice

## Limits and tradeoffs

Supervisor adds latency per routing decision; swarm harder to debug; pipeline inflexible for branching

## What scales well

Send API parallelism; subgraph isolation; fixed compile-time edges with runtime Command routing

## Memory / context / state

Shared graph state merged on Command.update before target node runs

## Orchestration approach

Graph runtime intercepts Command.goto — edges fixed at compile time, path chosen at runtime

## Complexity management

Subgraphs wrap complex agents; three pattern tiers by decomposition type

## Why built this way (engineering rationale)

Separates routing policy (LLM) from topology (graph) so branching workflows stay traceable while remaining dynamic

## Applicable to Cursor Dev OS?

Yes — meta-layer Boss as supervisor; Squad as provisional workers; dynamic emergence maps to choosing pattern per task

## Conflicts with other sources

Anthropic recommends simplest single-agent first — multi-agent only when complexity warrants
