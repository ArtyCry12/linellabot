# Hermes → Cursor mapping

## Tools

| Hermes tool / feature | Cursor equivalent | Notes |
|----------------------|-------------------|-------|
| `terminal` | `Shell` | Hermes uses bundled Git Bash on Windows |
| `read_file` / `write_file` / `patch` | `Read` / `Write` / `StrReplace` | |
| `delegate_task` | `Task` | Pass **full** task text; don't make subagent read plan file |
| `web_search` | Firecrawl / Exa / Tavily MCP | Per workspace MCP routing |
| `browser` | `cursor-ide-browser` MCP | |
| `skill_manage` | `@create-skill` | Procedural memory |
| `session_search` | `@recall` (agentmemory) | Or Hermes FTS5 when CLI installed |
| `cronjob` | `@automate` / external cron | |
| `kanban_*` | Parallel `Task` + shared markdown board | Or Hermes kanban CLI |
| MCP tools | `CallMcpTool` | `hermes mcp add` for Hermes CLI |

## Commands

| Hermes slash / CLI | Cursor |
|--------------------|--------|
| `/skill name` | `@name` after `install-cursor-skills.mjs` |
| `/personality` | Edit `SOUL.md` or scoped rule |
| `/model` | User selects model in Cursor UI |
| `/new`, `/reset` | New chat |
| `/compress` | Summarize in-thread or start fresh chat |
| `hermes -w` | `git worktree` |
| `hermes -p PROFILE` | Separate profile dir or worktree + SOUL |
| `hermes -s SKILL` | Pre-read skill file into context |
| `hermes acp` | Cursor native (you are already here) |

## Spawn patterns

### Quick subtask (minutes)

Hermes: `delegate_task(goal=..., context=...)`

Cursor: single `Task` with complete context; await result before next step.

### Parallel independent tasks

Hermes: `delegate_task(tasks=[...])`

Cursor: multiple `Task` calls in **one message**; collect all results before merge.

### Long-running autonomous (hours)

Hermes: `hermes chat -q "..."` or tmux + interactive `hermes`

Cursor: `Task` with `run_in_background: true`, or terminal `hermes chat -q` if CLI installed.

### Fire-and-forget background shell

Hermes: `terminal(background=True)`

Cursor: `Shell` with `block_until_ms: 0` or background Task.

## Prompt caching note

Hermes avoids mid-session tool/skill changes to preserve cache. Cursor analogy: don't swap large rule sets or skill loads mid-task — start a new chat for a clean context.

## Security parallels

| Hermes | Cursor |
|--------|--------|
| `approvals.mode: manual` | User approves terminal commands |
| `--yolo` | `"all"` permissions (discouraged) |
| `security.redact_secrets` | Never commit `.env`; warn on secrets in diffs |
| DM pairing (gateway) | N/A in Cursor |
