# Domain: Automation

**Scope:** n8n, event-driven workflows, MCP automation bridges, HITL gates.

## Findings summary (Sprint 4)

1. **Dual automation stack:** offline `n8n-workflow` skill (authoring) + instance `n8n-mcp` (build/run/validate when connected).
2. **Official n8n MCP** generates TypeScript-then-compile workflows — prefer over raw JSON from LLM alone.
3. **Start narrow:** expose tested workflows first; separate run vs edit permissions; HITL for money/PII/production (aligns with DEC-005 security escalation).
4. **Known failure modes:** over-engineered Code nodes, wrong node selection, complex branching — steer explicitly.
5. **Bidirectional MCP:** n8n can also consume external MCP via Client node — future pattern, not required for hub meta-layer.

## Sources

| ID | Title | Confidence |
|----|-------|------------|
| 2026-n8n-mcp-build-workflows | n8n blog MCP build | high |
| 2026-uibakery-n8n-mcp-guide | UI Bakery guide | medium |
| 2026-hub-n8n-workflow-skill | Hub offline skill | high |
| 2026-hub-n8n-instance-mcp | Hub instance MCP | high |
