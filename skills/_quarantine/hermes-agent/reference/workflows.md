# Hermes workflows in Cursor

## 1. Plan → implement (writing-plans + subagent-driven-development)

1. User describes feature
2. Load `@writing-plans` (or Read skill after install)
3. Write plan to `docs/plans/<feature>.md` — user approves
4. Load `@subagent-driven-development`
5. Parent extracts **all** tasks from plan into todos
6. For each task:
   - `Task(prompt=full task text + files + TDD steps + return format)`
   - Review output (spec, then quality)
   - Mark todo complete
7. Final verification: lint/test/build per project norms

**Anti-pattern:** subagent reads plan file itself — context fragmentation.

## 2. Debug (systematic-debugging)

1. Load `@systematic-debugging`
2. Reproduce with exact command
3. Minimize — smallest failing case
4. Hypothesis → instrument → fix → regression test
5. Do not patch symptoms before reproduction

## 3. TDD feature (test-driven-development)

1. Load `@test-driven-development`
2. Red: failing test
3. Green: minimal implementation
4. Refactor: only with green tests
5. User asked for commits? commit. Otherwise stop at green tests.

## 4. Personalized session start

1. Read `SOUL.md`
2. Read `AGENTS.md` learned sections
3. Optional: `@recall` for cross-session context
4. Confirm persona still matches user intent if first message is vague

## 5. Save learning as skill (self-improving loop)

After a non-trivial solved workflow:

1. Ask user: "Save this as a reusable Cursor skill?"
2. If yes → `@create-skill` with triggers and concise steps
3. Append durable fact to `AGENTS.md` if workspace-specific

Hermes CLI equivalent: agent creates skill under `~/.hermes/skills/` + curator tracks usage.

## 6. Multi-profile parallel coding

1. `git worktree add ../repo-coder -b agent/coder`
2. `git worktree add ../repo-review -b agent/reviewer`
3. Bootstrap each: `init-hermes-workspace.mjs` with different `SOUL.md`
4. Open two Cursor windows; parallel `Task` per worktree
5. Merge via normal git flow when user approves
