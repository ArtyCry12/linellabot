---
name: ponytail-audit
description: >
  Whole-repo audit for over-engineering. Ranked delete/simplify list vs
  stdlib/native. Triggers: /ponytail-audit, audit for over-engineering, find bloat.
license: MIT
compatibility: cursor
metadata:
  author: hub
  upstream: DietrichGebert/ponytail
---

# Ponytail audit

Repo-wide ponytail-review. Rank biggest cuts first.

Tags: `delete:` | `stdlib:` | `native:` | `yagni:` | `shrink:`

Hunt: deps the platform already ships, single-impl interfaces, factories with
one product, wrappers that only delegate, dead flags, hand-rolled stdlib.

Output: one line per finding, ranked. End with `net: -N lines, -D deps possible.`
Nothing: `Lean already. Ship.`

Lists only — does not apply fixes. Correctness/security out of scope.
