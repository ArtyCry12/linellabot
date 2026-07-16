# User-memory protocol (enhanced)

**MCP:** `memory` always-on · **Skill:** agentmemory `remember`/`recall` when available

## Entity types

| Type | Example |
|------|---------|
| `preference` | plain Russian, questions before start |
| `project` | okara.ai, hub phase |
| `decision` | DEC-057 router |
| `blocker` | needs Tavily API key |
| `handoff` | session stop state |

## Prune policy

- Max 40 active entities per project in hot cache
- Archive stale (>90d) to `ai-tracking/memory-archive/`
- Never store secrets in memory MCP

## Handoff template

```
Project: …
Done: …
Next: …
Blockers: …
Profile refs: automationPrefs, topFix
```

## ECC instincts

Load top 6 from `ai-tracking/instincts/active-instincts.json` (confidence ≥0.7) into session context via `squad-memory` triggers.

## Squad-memory triggers (from quiz)

- After substantive hub work → remember profile deltas
- After marketing deliverable → entity `project` + landing URL
- After MCP stack change → entity `decision`
