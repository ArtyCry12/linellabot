# Domain: Prompt Systems

**Scope:** structured prompts, skills as protocols, prompt engineering systems, cache-aware layout.

## Findings summary (Sprint 4)

1. **Prompts = engineered artifacts** — composable sections, version control (PromptKit, agent-skills pattern).
2. **Progressive disclosure** — skill registry with paths/triggers, not inlined mega-instructions (production prompt architecture).
3. **Cache-aware structure** — static prefix head, dynamic tail; matches Sprint 3 optimization findings.
4. **Hub stack IS the prompt system:** User Rules → .mdc → skills → agents/*.md → corpus layers — no separate prompt monolith.
5. **Slash-command lifecycle** (/spec→/ship) maps to Squad phases + dev-os sub-skills; verification gates required.

## Sources

| ID | Title | Confidence |
|----|-------|------------|
| 2026-microsoft-promptkit | PromptKit | high |
| 2026-agentpatterns-production-prompts | Production prompt arch | high |
| 2026-addyosmani-agent-skills | agent-skills | high |
| 2026-hub-prompt-stack | Hub stack audit | high |
