# Project Squad — model map (token economy)

| Tier | Model slug | Use for |
|------|------------|---------|
| **Boss** | `claude-4.6-sonnet-medium-thinking` | Orchestration, conflict resolution, final synthesis |
| **Heavy** | `gpt-5.3-codex-high-fast` | Non-trivial code, refactors, multi-file TS/React |
| **Standard** | `claude-4.6-sonnet-medium-thinking` | Design decisions, SEO plan, deploy strategy |
| **Fast** | `composer-2.5-fast` | Lint/build runs, cleanup lists, shell, memory sync |
| **Scout** | `claude-4.5-haiku-thinking` | Repo scan summaries, file inventory, grep-style audit |

Rules:
- Parent (Boss) stays on **Standard** unless user asks for opus-level review.
- Never spawn two **Heavy** agents in parallel on the same files.
- Use **graphify** + **markitdown** before reading large PDFs/docs (Boss instructs Scout).
- **uv** for Python installs/scripts; **npx.cmd** on Windows for Node.
