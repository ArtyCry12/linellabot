# Ruflo → Squad bridge (patterns only)

**Source:** https://github.com/ruvnet/ruflo — reference patterns, not a full install.

## Patterns to borrow

| Ruflo idea | Squad mapping |
|------------|---------------|
| Multi-agent roles | `agents/squad-*.md` roster |
| Task handoff | `templates/squad-handoff.md` |
| Parallel workers | Boss spawns squad-* with model-map caps |
| Memory between runs | `user-memory` + `ai-tracking/instincts/` |

## When to read

- Designing new squad subagent
- User mentions ruflo / swarm orchestration

## Do not

- Install ruflo runtime into hub
- Duplicate squad agents with ruflo names
