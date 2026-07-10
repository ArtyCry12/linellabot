# Domain: Security

**Scope:** LLM/agent security, prompt injection, sandbox, hub safety gates.

## Findings summary (Sprint 3)

1. **Prompt injection (#1 OWASP LLM risk)** — untrusted content (web, issues, tool output) must not imply user approval or bypass gates.
2. **Execution-layer > prompt-only** — kernel/policy sandbox (agentsh pattern) for high-risk ops; Cursor relies on sandbox + user rules + ship gates.
3. **Autonomy cannot override security** — DEC-005 escalates only security/data-loss/architecture; conflict priority safety first.
4. **Hub stack** — cybersecurity skill, git safety, mcp.json gitignored, Zapier write confirm, Squad ship gated (class E).
5. **No new security agents in Sprint 3** — use squad-review + cybersecurity skill + security-review subagent on demand.

## Sources

| ID | Title | URL | Confidence |
|----|-------|-----|------------|
| 2025-owasp-llm-top10 | OWASP LLM Top 10 | https://owasp.org/www-project-top-10-for-large-language-model-applications/ | high |
| 2025-owasp-llm01-prompt-injection | LLM01 Prompt Injection | https://genai.owasp.org/llmrisk/llm01-prompt-injection/ | high |
| 2026-agentsh-secure-sandbox | agentsh sandbox | https://www.agentsh.org/docs/secure-sandbox/ | high |
| 2026-hub-security-stack | Hub security audit | file://rules/cybersecurity.mdc | high |
