---
name: ponytail-review
description: >
  Code review focused on over-engineering. Finds what to delete: reinvented
  stdlib, unneeded deps, speculative abstractions. One line per finding.
  Triggers: /ponytail-review, review for over-engineering, what can we delete.
license: MIT
compatibility: cursor
metadata:
  author: hub
  upstream: DietrichGebert/ponytail
---

# Ponytail review

Review diffs for unnecessary complexity. One line per finding: location, what
to cut, what replaces it. Best outcome: shorter diff.

## Format

`path:L12-38: tag: ...`

Tags: `delete:` | `stdlib:` | `native:` | `yagni:` | `shrink:`

## Examples

- `L12-38: stdlib: 27-line validator. "@" in email is enough; real check is confirmation mail.`
- `L4: native: moment.js for one format. Intl.DateTimeFormat, 0 deps.`
- `repo.py:L88: yagni: AbstractRepository with one impl. Inline until a second exists.`

End with `net: -N lines possible.` Nothing to cut: `Lean already. Ship.`

## Boundaries

Over-engineering only. Correctness/security/perf → normal review. Do not apply
fixes. Do not flag a single assert/self-check as bloat.
