# Domain: AI Dev Environments

**Scope:** Cursor, VSCode AI extensions, IDE workflows, rules/skills/subagents.

## Findings summary (Sprint 2)

1. **Three-layer customization:** rules (static/always or triggered), skills (dynamic procedures), MCP (external tools) — official Cursor model matches Dev OS hub stack.
2. **Token-native platform design:** Cursor 2.4 lazy-loads MCP JSON; warns against rule bloat; built-in subagents isolate explore/bash/browser context — platform validates Sprint 1 context-engineering findings.
3. **Rule modes matter:** Always Apply vs Apply Intelligently vs Manual (@mention) vs path globs — hub should keep Dev OS rule **manual/on-demand** only.
4. **Skills discovery is multi-path:** `.cursor/skills/`, global `~/.cursor/skills/`, nested monorepo scoping — Dev OS sub-skills pattern is native.
5. **AGENTS.md + .mdc coexist:** simple projects use AGENTS.md; rich routing uses `.mdc` frontmatter — hub uses both.

## Comparative notes

| Approach | Pros | Cons | When |
|----------|------|------|------|
| Always-on rules | Consistent behavior | Context cost, over-engineering risk | 1–2 hub-wide orchestrator rules only |
| On-demand rules/skills | Token efficient | Needs routing | Dev OS, domain skills |
| Built-in subagents | Free context isolation | Less customizable | Explore/bash/browser |
| Custom subagents | Specialized roles | Roster sprawl if ungated | Squad + dev-os-research |
| CLI via rules | No MCP needed | Shell risk | gh, git, node scripts |

## Open gaps

- Windsurf/Continue comparative card (deferred — low priority for Cursor-native hub)
- Cursor Cloud subagents vs local MCP (team config at cursor.com/agents)

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2026-cursor-customizing-agents | Customizing Agents | https://cursor.com/learn/customizing-agents | high |
| 2026-cursor-rules-docs | Rules Docs | https://cursor.com/docs/rules | high |
| 2026-cursor-skills-docs | Skills Help | https://cursor.com/help/customization/skills | high |
| 2026-cursor-changelog-2-4 | Changelog 2.4 | https://cursor.com/changelog/2-4 | high |
