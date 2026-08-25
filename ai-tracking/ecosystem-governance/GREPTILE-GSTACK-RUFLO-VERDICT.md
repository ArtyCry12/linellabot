# Greptile · gstack · ruflo — install verdict

**Date:** 2026-08-25  
**Gate:** W6 external research (`TARGET-ARCHITECTURE-DRAFT.md`, `CURRENT-ARCHITECTURE-MAP.md`)  
**Policy:** No install without clear win; prefer NEITHER if overlap with Squad / Ecosystem Architect.

---

## Greptile

**What it is:** AI PR / repo code review (context-aware diffs, inline comments, CI integration).

**What hub already has:**

| Layer | Existing |
|-------|----------|
| SAST / scan | **Aikido** plugin (`aikido_full_scan`, auto-scan rule on code changes) |
| Security orchestration | **security-hub** — diff-ai prompts, secrets/SAST/SCA/IaC/DAST chains (`skills/security-hub/SKILL.md`) |
| PR / diff review | **squad-review** + **bugbot** Task + **thermo-nuclear-code-quality-review** + **pr-review** skill (≥80 confidence gate) |
| Code graph context | **GitNexus** impact/context before edits (AGENTS.md required) |

**Overlap:** Greptile duplicates the **review plane** three times over — same job as bugbot + squad-review + Aikido/security-hub, with another SaaS seat and repo webhook surface.

**Incremental value:** Only if Boss wants **always-on GitHub/App PR bot** with Greptile-specific UX and is willing to **retire** one of bugbot / Aikido auto-scan / squad-review PR mode. No such mandate exists.

### Verdict: **NO install**

Unless Boss explicitly wants to replace an existing review stack with Greptile and drop a duplicate — not a net add for this hub.

---

## gstack vs ruflo

### gstack (Garry Tan)

**What it is:** Design consultation / design-review / plan-design-review workflow (browser + critique loop).

**Hub status:** Patterns **already vendored** inside Open Design — `skills/open-design/repo/skills/design-review/`, `design-consultation/`, `plan-design-review/` cite upstream `github.com/garrytan/gstack`. Plus **open-design** MCP, **squad-design**, **design-taste**, **impeccable**, **21st**.

**Overlap:** Full duplicate of design-review path; installing gstack CLI adds a second design orchestrator next to Open Design + Squad.

### ruflo (ruvnet/ruflo)

**What it is:** Multi-agent orchestration / swarm patterns (ruvnet ecosystem).

**Hub status:** `plans/hub_phase_c-d-e_0f9feb15.plan.md` already scoped it as **patterns → squad bridge doc**, not install. Live stack: **Project Squad** (architect/build/design/qa/review/ship), **task-router**, **ecosystem-architect** (sole permanent governance agent), **crew-ai**, **babyagi**.

**Overlap:** Third orchestration layer on top of Squad + Architect + router — same «who delegates what» problem MASTER prompt already solved with Task Router + Squad guardrails.

### Pick one?

| Option | Assessment |
|--------|------------|
| **gstack** | Redundant — curated upstream already in open-design |
| **ruflo** | Redundant — Squad + Architect + crew/babyagi cover orchestration |
| **NEITHER** | **Recommended** |

### Verdict: **NEITHER — no install**

If Boss wants one artifact: extract **ruflo delegation patterns** into a short `ai-tracking/` bridge note for squad-architect (text only, no repo install). gstack adds nothing beyond existing OD skills.

---

## Summary

| Tool | Verdict | Reason (one line) |
|------|---------|-------------------|
| Greptile | **NO** | Review stack saturated (Aikido + security-hub + bugbot/squad-review) |
| gstack | **NO** | Already in open-design upstream skills |
| ruflo | **NO** | Duplicates Squad / Architect / task-router |

**Next action:** None. Revisit only on explicit Boss request or if a review tool is retired.
