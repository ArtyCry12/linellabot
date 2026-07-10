---
source_id: 2026-zylos-prompt-caching-agents
title: Prompt Caching and KV Cache for Long-Running Agents
url: https://zylos.ai/research/2026-03-27-prompt-caching-kv-cache-optimization-long-running-ai-agents
source_class: D
domain: optimization
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Stable system prompt prefixes enable 50–90% cached token cost reduction and 65–85% lower TTFT. Dynamic content before first static block breaks cache. Compress at ~75% context utilization; preserve last 3–5 turns verbatim.

## Applicable to Cursor Dev OS?

Hub: keep always-on rules minimal (00-orchestrator only); static skill frontmatter patterns; avoid timestamps in always-on layers.

## Why built this way

Caching is prefix correctness — not optional perf tweak for 24/7 agents.
