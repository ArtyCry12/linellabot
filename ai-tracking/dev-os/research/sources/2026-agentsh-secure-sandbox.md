---
source_id: 2026-agentsh-secure-sandbox
title: agentsh Secure Sandbox (execution-layer security)
url: https://www.agentsh.org/docs/secure-sandbox/
source_class: A
domain: security
date_reviewed: 2026-07-01
confidence: high
---

# Source extraction card

## Summary

Kernel-level policy enforcement (seccomp, Landlock, network proxy) below LLM — blocks exfiltration/SSH read even under prompt injection. Contrasts with prompt-only guardrails.

## Applicable to Cursor Dev OS?

Cursor sandbox + user git safety rules; deploy/ship gates; no force push without explicit user ask.

## Why built this way

Model compliance insufficient; deterministic policy on syscalls/network.
