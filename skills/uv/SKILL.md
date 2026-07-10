---
name: uv
description: >-
  Fast Python package and project management with uv (replaces pip, pip-tools, pipx, poetry, pyenv,
  virtualenv for most workflows). Use when installing Python deps, creating venvs, running scripts,
  managing pyproject.toml projects, uvx tools, pinning Python versions, lockfiles, CI/Docker Python
  setup, migrating from pip/poetry, or when the user mentions uv, быстрая работа терминала, or
  wants faster terminal Python commands on Windows/macOS/Linux.
---

# uv — fast Python in the terminal

[uv](https://docs.astral.sh/uv/) is Astral's Rust-based Python package manager. Prefer it over `pip` / `poetry` / manual `venv` when speed, lockfiles, or unified tooling matter.

**Before running commands:** confirm `uv` is on PATH (`uv --version`). If missing, install (see [reference.md](reference.md#install)).

## Decision tree

| Goal | Command |
|------|---------|
| New app/library with `pyproject.toml` | `uv init` → `uv add <pkg>` → `uv run …` |
| Run a one-off script (deps in metadata or none) | `uv run script.py` |
| Run a CLI tool without installing globally | `uvx <tool>` (alias: `uv tool run`) |
| Install a global CLI from PyPI | `uv tool install <pkg>` |
| Legacy pip workflow / requirements.txt | `uv pip install` / `uv pip compile` / `uv pip sync` |
| Only need a venv | `uv venv` (optionally `--python 3.12`) |
| Pin or install Python versions | `uv python pin` / `uv python install` |
| Reproducible env from lockfile | `uv sync` (in a uv project) |

## Project workflow (default for repos)

Assumes a directory with `pyproject.toml` (create with `uv init`).

```bash
uv init myapp && cd myapp
uv add requests ruff --dev
uv run python main.py
uv run ruff check .
uv lock          # refresh uv.lock
uv sync          # install per lockfile into .venv
```

- First `uv run` / `uv sync` / `uv lock` creates `.venv` and `uv.lock`.
- `.python-version` pins the interpreter; edit or use `uv python pin 3.12`.
- **Do not** mix `pip install` inside `.venv` for project deps — use `uv add` / `uv sync`.

## Scripts (single files)

```bash
uv run analysis.py
uv run analysis.py -- arg1 arg2
echo 'print("hi")' | uv run -
```

Declare deps inline (PEP 723) or add via CLI:

```bash
uv add --script analysis.py pandas
```

Inside a **project** directory, `uv run other.py` may install the project first; use `--no-project` if the script must stay isolated.

## Tools (`uvx`)

```bash
uvx ruff check .
uvx pycowsay hello
uv tool install ruff
```

Use `uv run pytest` (not `uvx pytest`) when tests need the **current project** installed.

## pip-compatible interface (migrations)

Drop-in speedup for existing `requirements.in` / `requirements.txt` flows:

```bash
uv venv
uv pip compile requirements.in -o requirements.txt
uv pip sync requirements.txt
uv pip install -r requirements.txt
```

On Windows, activate `.venv\Scripts\activate` before tools that expect an active venv, or prefer `uv run` / `uv pip` without activation.

## Python versions

```bash
uv python install 3.12 3.13
uv python pin 3.12
uv venv --python 3.12
uv run --python 3.11 script.py
```

## Agent terminal rules

1. **Prefer `uv run`** over `python` when the repo has `pyproject.toml` or script metadata — correct env without manual activation.
2. **Prefer `uv add`** over editing `pyproject.toml` by hand unless the user asked for manual edits.
3. **Commit `uv.lock`** for applications; libraries may omit lockfile per team policy (see uv docs on libraries).
4. **Cache:** avoid `--no-cache` unless debugging cache corruption; use `uv cache clean` if needed.
5. **Windows:** use PowerShell install one-liner from reference; paths use `.venv\Scripts\python.exe`.
6. **CI:** `uv sync --frozen` fails if lockfile out of date (good guardrail).
7. **Unknown flags:** `uv help <command>` — faster than guessing pip equivalents.

## Anti-patterns

- `pip install` into a uv-managed project `.venv` (desyncs lockfile).
- `python -m pip` when `uv add` / `uv sync` applies.
- Creating `venv` manually then `pip install -e .` when `uv sync` suffices.
- `uvx pytest` in a src-layout package that must be installed.

## Deep reference

- Command cheat sheet: [reference.md](reference.md)
- Upstream docs: https://docs.astral.sh/uv/
- CLI help: `uv help`, `uv help run`
