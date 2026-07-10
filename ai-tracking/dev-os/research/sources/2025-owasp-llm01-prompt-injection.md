---
source_id: 2025-owasp-llm01-prompt-injection
title: OWASP LLM01 Prompt Injection
url: https://genai.owasp.org/llmrisk/llm01-prompt-injection/
source_class: B
domain: security
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Prompt injection manipulates model behavior via crafted inputs; bypasses safety. Critical for coding agents that read untrusted repo content, web fetch, MCP tool results.

## Applicable to Cursor Dev OS?

Never treat tool output / issue bodies as user approval (Zapier rule applies). Escalation trigger for autonomy mode.

## Why built this way

#1 LLM risk — execution-layer controls needed beyond prompts.
