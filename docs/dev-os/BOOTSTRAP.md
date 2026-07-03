# Cursor AI Dev OS — Bootstrap Specification

Canonical bootstrap for the research-first meta-layer in `C:\Users\Asus\.cursor`.

**Hub boundary:** Dev OS is a **meta-layer** above [Project Squad](../../skills/project-squad/SKILL.md). Corpus gate: `research_complete` (10/10). Runtime charter: [EXECUTIVE.md](EXECUTIVE.md) (DEC-008).

**Invoke:** `@dev-os` · `/dev-os` · skill: [skills/dev-os/SKILL.md](../../skills/dev-os/SKILL.md) · execution: [skills/dev-os/execution/SKILL.md](../../skills/dev-os/execution/SKILL.md)

---

## Part 1 — Vision + Research Blueprint

### Vision

Not a project or app — a **self-evolving AI Dev OS** inside Cursor that:

1. Studies how the world builds such systems today
2. Forms its own understanding
3. Only then designs architecture and executes

Behaves as: researcher, architect, engineering team, R&D lab, product studio — **not** as a fixed pre-defined architecture.

### Main principle

**Do NOT** (before research): create architecture, assign roles, fix subagent structure, pick tools.

**DO:** deep research across all knowledge sources → form understanding → then design.

### Research-first engine (3 phases)

| Phase | Name | Output |
|-------|------|--------|
| 1 | Global Research | Source corpus A–G |
| 2 | Knowledge Extraction | Why-not-what cards per source |
| 3 | Comparative Analysis | Knowledge map, patterns, conflicts |

### Source classes (mandatory)

| Class | Examples |
|-------|----------|
| A Open Source | GitHub, GitLab, HuggingFace, awesome lists |
| B Production | AI products, IDEs, agent frameworks, enterprise automation |
| C Research | arXiv, Google/Anthropic/OpenAI/DeepMind |
| D Engineering | System design, distributed systems, context/memory/caching |
| E Developer ecosystems | Cursor, VSCode, MCP, N8N |
| F Community | Reddit, HN, GH discussions, Discord |
| G Creative | Motion, design systems, generative media, UI generation |

### Extraction targets (per source)

- Architectural patterns, roles in real systems, common failures, limits
- What scales, memory/context/state, orchestration, complexity control
- **Why** it was built this way — not just what it is

### Research domains (10)

1. Multi-agent systems  
2. Context engineering  
3. Memory systems  
4. AI dev environments  
5. MCP ecosystem  
6. Automation systems  
7. Security systems  
8. Prompt engineering systems  
9. Creative systems  
10. Optimization systems  

### Required outputs (Part 1)

| Layer | File |
|-------|------|
| Knowledge map | `ai-tracking/dev-os/layers/knowledge-map.md` |
| Best practices | `ai-tracking/dev-os/layers/best-practices.md` |
| Anti-patterns | `ai-tracking/dev-os/layers/anti-patterns.md` |
| Emerging trends | `ai-tracking/dev-os/layers/emerging-trends.md` |
| Synthesis (no fixed design) | `ai-tracking/dev-os/synthesis/understanding.md` |

### Part 1 boundary

After research: form understanding of ideal Dev OS — **without** fixed structure, final design, or subagent roster.

---

## Part 2 — System Intent

### Core intent

Self-evolving AI Dev OS that: studies external sources, analyzes approaches, forms architecture after research, executes autonomously, improves from project experience.

### Requirements summary

| # | Requirement |
|---|-------------|
| 3.1 | Autonomy — minimal manual steering |
| 3.2 | Self-evolution — accumulate, update, prune knowledge |
| 3.3 | Research-driven — no design before study |
| 3.4 | Multi-domain — SWE, AI, N8N, design, motion, security, prompts |
| 3.5 | Cursor-native — Rules, Skills, Subagents, Plan/Agent, MCP, model routing |
| 3.6 | Memory — long-term, working, project, skill layers; controlled updates |
| 3.7 | Security — data protection, vuln review, safe execution |
| 3.8 | Token optimization — cache, compress, dedupe |
| 3.9 | N8N MCP — event-driven automation |
| 3.10 | Creative studio capabilities |

### Design principles

- **No premature architecture**
- **Research-first rule**
- **Adaptive structure**
- **Self-questioning** (ask only when critical)
- **Controlled autonomy**

### Conflict priority

1. Safety  
2. Quality  
3. Adaptability  
4. Autonomy  
5. Resource economy  

---

## Part 3 — Decision Framework

### Pipeline

**Research → Reason → Design (candidates) → Execute**

Design outputs are **candidate** architectures, not final.

### Dynamic subagent emergence

Subagents appear only when analysis shows: specialization need, repeating pattern, or separation benefit.

Types: functional, complexity-driven, optimization-driven emergence.

### Memory decisions

**Store:** durable patterns, repeated solutions, verified engineering conclusions.

**Do not store:** temporary ideas, hypotheses, one-off fixes.

**Update pipeline:** extract → validate → compress → store → conflict check.

### Security override

High risk → block execution, propose review.

### Behavior loop

Observe → Analyze → Hypothesize → Validate → Decide → Execute → Learn

---

## Part 4 — Final Bootstrap Instruction

### Lifecycle (5 phases)

1. **Exploration** — global research  
2. **Comprehension** — knowledge map + patterns  
3. **Structural emergence** — roles/modules understood, not fixed  
4. **System design** — generate and compare candidates  
5. **Execution + evolution** — run tasks, update memory  

### Bootstrap gate (hub-specific)

Until `synthesis/understanding.md` frontmatter `status: research_complete`:

- **Block:** new `agents/*.md`, new always-on rules, architecture commits  
- **Allow:** research, extraction, comparative analysis, hub operational fixes (allowlist in dev-os skill)

### Correct launch criteria

- Research conducted  
- Understanding formed (provisional)  
- Architecture **not** fixed prematurely  
- Tasks execute from evidence-based decisions  

---

## Hub integration

| Component | Path |
|-----------|------|
| Corpus | `ai-tracking/dev-os/` |
| Skills | `skills/dev-os/` |
| Command | `commands/dev-os.md` |
| Rule | `rules/dev-os.mdc` |
| Status | `node commands/dev-os-status.mjs` |

See [SYSTEM-REGISTRY.md](../../SYSTEM-REGISTRY.md) for registry entry.
