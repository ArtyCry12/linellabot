---
name: llm-council
description: >-
  Ephemeral three-stage review for consequential architecture and trade-offs:
  independent opinions, anonymized cross-review, chairman synthesis.
  Maximum three workers, no nested spawning, no automatic implementation.
---

# LLM Council

Use only when a decision has meaningful competing approaches, high impact, or
the user explicitly asks for several independent opinions. Skip routine edits
and decisions already fixed by the user.

## Limits

- Maximum three ephemeral workers.
- Workers never spawn more workers.
- Never use `inherit`; use the model routing policy active in the hub.
- Council is advisory. It does not edit files or start implementation.
- Do not restore Project Squad or create a permanent council agent.

## Stage 1 — independent opinions

Run up to three independent prompts in parallel. Give every worker the same:

- decision to make;
- verified facts and constraints;
- options already considered;
- success criteria;
- requested report contract.

Each worker returns:

```text
GOAL:
EVIDENCE:
DECISION:
RISKS:
FILES: none
NEXT_ACTION:
```

## Stage 2 — anonymized cross-review

Remove model/worker names. Ask one reviewer to rank the opinions against the
facts and constraints. The reviewer must call out unsupported assumptions and
may combine compatible parts.

## Stage 3 — chairman synthesis

The parent produces one compact result:

1. chosen option and why;
2. rejected options and decisive trade-offs;
3. residual risks;
4. evidence still missing;
5. next required preflight stage.

Record a receipt only for stages that actually ran. A route echo without the
three-stage evidence is not a completed council.
