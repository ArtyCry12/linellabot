---
name: ponytail-debt
description: >
  Harvest every ponytail: comment into a debt ledger so deferred shortcuts
  stay tracked. Triggers: /ponytail-debt, ponytail ledger, what did we defer.
license: MIT
compatibility: cursor
metadata:
  author: hub
  upstream: DietrichGebert/ponytail
---

# Ponytail debt

Scan for comment markers (skip node_modules, .git, build output):

```text
# ponytail: ...
// ponytail: ...
```

One row per hit: file, line, ceiling, upgrade trigger. Tag `no-trigger` if the
comment names no upgrade path.

End with `N markers, M with no trigger.` None: `No ponytail: debt. Clean ledger.`

Read-only unless user asks to write `PONYTAIL-DEBT.md`.
