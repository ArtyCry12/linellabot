---
name: dev-os-research
description: >-
  Dev OS Phase 1–3 research protocol — source classes A–G, extraction cards,
  comparative analysis. Use when @dev-os research, global research, knowledge
  extraction, or domain study for Cursor AI Dev OS bootstrap.
---

# Dev OS — Research Protocol

Parent: [../SKILL.md](../SKILL.md) · Corpus: `ai-tracking/dev-os/`

## Phase 1 — Global Research

### Source classes

| Class | Target | Hub tooling |
|-------|--------|-------------|
| A OSS | GitHub, GitLab, HF, awesome lists | Exa + shallow `git clone` → `ai-tracking/dev-os/repos/` |
| B Production | AI products, IDEs, frameworks | Exa + fetch docs |
| C Papers | arXiv, lab publications | Exa `site:arxiv.org` |
| D Engineering | Blogs, system design | Exa |
| E Ecosystems | Cursor, MCP, N8N | Local audit + SYSTEM-REGISTRY |
| F Community | HN, Reddit, GH discussions | Exa |
| G Creative | Design/motion/UI gen | huashu-design, stitch, figma on-demand |

**Rule:** one web provider per research thread (Exa primary).

### Per-domain target

- **5–8** high-signal sources
- **≥3** required before comparative analysis

### Sprint priority

1. multi-agent, context-engineering, memory-systems  
2. ai-dev-environments, mcp-ecosystem  
3. optimization, security  
4. automation, prompt-systems  
5. creative-systems  

## Phase 2 — Knowledge Extraction

For each source:

1. Copy `research/sources/_template.md` → `research/sources/YYYY-MM-DD-slug.md`
2. Fill all sections — emphasize **why built this way**
3. Set `confidence: low|medium|high`
4. Append row to domain `research/domains/<domain>/findings.md`

### Extraction checklist

- [ ] Architectural patterns
- [ ] Roles observed
- [ ] Failure modes
- [ ] Limits / tradeoffs
- [ ] Scaling characteristics
- [ ] Memory / context / state
- [ ] Orchestration model
- [ ] Complexity control

## Phase 3 — Comparative Analysis

When domain has ≥3 cards:

1. Update `layers/knowledge-map.md` compare matrix
2. Promote stable patterns → `layers/best-practices.md`
3. Promote failures → `layers/anti-patterns.md`
4. Promote new signals → `layers/emerging-trends.md`
5. Update `index.md` domain coverage table

## Domain folders

```
ai-tracking/dev-os/research/domains/
  multi-agent/
  context-engineering/
  memory-systems/
  ai-dev-environments/
  mcp-ecosystem/
  automation/
  security/
  prompt-systems/
  creative-systems/
  optimization/
```

## Output discipline

- Do **not** propose final Dev OS architecture during Phase 1–3
- Do **not** create new agents while gate closed
- Update `synthesis/understanding.md` only as **provisional hypothesis** with evidence links

## Seed anchors (verify, do not trust blindly)

| Domain | Starting points |
|--------|-----------------|
| multi-agent | LangGraph, CrewAI, AutoGen, Cursor subagents, Anthropic multi-agent |
| context-engineering | Anthropic context engineering, RAG patterns, prompt structure |
| memory-systems | MCP memory server, mem0, Letta, seo-geo HOT/WARM tiers |
