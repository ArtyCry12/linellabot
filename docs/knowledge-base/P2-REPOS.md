# P2 Repos — knowledge extraction (REQ-060–064)

On-demand reference. **Do not install as servers** unless noted.

---

## REQ-060 — di-sukharev/vibe

**URL:** https://github.com/di-sukharev/vibe  
**Purpose:** Vibecoding template — opinionated structure for AI-assisted app building.

| Extract for hub | Action |
|-----------------|--------|
| Folder layout for non-coder users | Mirror in `docs/squad/` project templates |
| Prompt patterns for incremental build | Add to `PROMPT-HOOKS.md` |
| Verify loops | Align with `karpathy-guidelines.mdc` |

**Hub route:** `prototype` skill + Squad scout → architect → build.  
**User note:** You don't need to read the repo — agent distributes patterns into rules/skills.

---

## REQ-061 — alefragnani/vscode-project-manager

**URL:** https://github.com/alefragnani/vscode-project-manager  
**Purpose:** Multi-project navigation in VS Code/Cursor.

| Pattern | Hub equivalent |
|---------|----------------|
| `projects.json` favorites | One Cursor window per client project |
| Tags (Personal / Work) | `ai-tracking/` per initiative + Notion project pages |
| Git/Mercurial/SVN auto-detect | `git status` in squad handoff |
| Side bar quick-open | User installs extension; agent documents paths in handoff |

**Recommendation:** Install **Project Manager** extension in Cursor. Save: `.cursor` hub, each client repo, clone-website outputs.

**Status 2026-07-10:** Installed `alefragnani.project-manager` v13.1.0 — see `docs/knowledge-base/PROJECT-MANAGER.md`.

**Agent workflow:** Handoff always includes absolute `Project path:` — mimics PM's SSOT.

---

## REQ-062 — aiksa2090/Agentic-Swarm

**URL:** https://github.com/aiksa2090/Agentic-Swarm  
**Purpose:** Offline multi-agent desktop (PySide6) — 5 agents, VRAM swap, brainstorming loops.

| Extract | Do NOT |
|---------|--------|
| Agent role specialization | Install as local server |
| Infinite loop + human gate | Copy UI wholesale |
| Dynamic VRAM / model swap | — |

**Hub mapping:** Patterns inform `subagent-guardrails.mdc` + Squad phases. DEC-004 keeps **10** Squad agents, not 5 desktop agents.

**Key lesson:** Specialized agents + orchestrator loop + human in the loop ≈ Okara Agents Feed model.

---

## REQ-063 — VoltAgent/awesome-agent-skills

**URL:** https://github.com/VoltAgent/awesome-agent-skills  
**Purpose:** Curated catalog of agent skills across Claude, Cursor, Copilot, etc.

| MVP integration | Status |
|-----------------|--------|
| Cross-check new skills before adding to hub | Use as **reference**, not bulk install |
| `npx skills add` for missing high-value skills | On-demand per task |
| Avoid duplicate of existing `skills/` + `skills-cursor/` | `SKILLS-CLEANUP.md` tiers |

**Workflow:** Before creating skill → search awesome-agent-skills → prefer official/portable spec.

---

## REQ-064 — nicobailon/visual-explainer

**URL:** https://github.com/nicobailon/visual-explainer  
**Purpose:** Agent skill — rich HTML pages / slide decks for diagrams, audits, tables, recaps.

| Hub use | Route |
|---------|-------|
| Audit deliverables | Prefer **canvas** skill for interactive; visual-explainer for static HTML export |
| Plan reviews | squad-architect output → HTML recap |
| Diff reviews | squad-review → visual summary |

**MVP:** Document pattern in hub; optional `npx skills add` when user wants HTML exports.  
**Complements:** `huashu-design` (motion/decks), `skills-cursor/canvas` (live React).

---

## Cross-links

- Foundation (P1): `FOUNDATION-REPOS.md`
- External URLs: `EXTERNAL-CATALOG.md` — add these 5 entries
- Symbiosis: `SYMBIOSIS-AUDIT.md`

*Generated: 2026-07-10 · P2*
