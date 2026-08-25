# uv command reference (agent cheat sheet)

Official docs: https://docs.astral.sh/uv/

## Install {#install}

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**PyPI:** `pip install uv` or `pipx install uv`

**Self-update (standalone install):** `uv self update`

## Projects

| Task | Command |
|------|---------|
| New project | `uv init [name]` |
| Add dependency | `uv add pkg` / `uv add --dev pkg` |
| Remove | `uv remove pkg` |
| Run command in project env | `uv run <cmd>` / `uv run python file.py` |
| Update lockfile | `uv lock` |
| Install from lockfile | `uv sync` |
| CI strict | `uv sync --frozen` |
| Dependency tree | `uv tree` |
| Export lock | `uv export` |
| Format | `uv format` |
| Version bump | `uv version` |

## Scripts

| Task | Command |
|------|---------|
| Run script | `uv run script.py [args]` |
| Add deps to script metadata | `uv add --script script.py pkg` |
| Skip project install | `uv run --no-project script.py` |
| Stdin | `uv run -` |

## Tools

| Task | Command |
|------|---------|
| Ephemeral run | `uvx tool [args]` |
| Same | `uv tool run tool [args]` |
| Install globally | `uv tool install tool` |
| List installed | `uv tool list` |
| Upgrade tool | `uv tool upgrade tool` |

## Python

| Task | Command |
|------|---------|
| Install interpreters | `uv python install 3.12 3.13` |
| List | `uv python list` |
| Pin for project | `uv python pin 3.12` |
| Find executable | `uv python find` |

## venv & pip interface

| Task | Command |
|------|---------|
| Create venv | `uv venv` / `uv venv --python 3.12` |
| pip install | `uv pip install pkg` |
| Compile requirements | `uv pip compile in.in -o requirements.txt` |
| Sync requirements | `uv pip sync requirements.txt` |
| pip freeze style | `uv pip freeze` |

## Cache & config

| Task | Command |
|------|---------|
| Clear cache | `uv cache clean` |
| Cache dir | `uv cache dir` |
| No cache (debug) | `--no-cache` / `UV_NO_CACHE=1` |
| Config in project | `[tool.uv]` in `pyproject.toml` |

## Build & publish

| Task | Command |
|------|---------|
| Build wheel/sdist | `uv build` |
| Publish | `uv publish` |

## Environment variables (common)

| Variable | Effect |
|----------|--------|
| `UV_NO_CACHE` | Disable cache for one operation |
| `UV_CACHE_DIR` | Override cache location |
| `UV_PYTHON_DOWNLOADS` | `never` disables auto Python download |
| `UV_LINK_MODE` | e.g. `copy` on Windows when hardlinks fail |

## pip → uv mapping

| pip / poetry habit | uv |
|--------------------|-----|
| `python -m venv .venv` | `uv venv` |
| `pip install -e .` | `uv sync` (project) |
| `pip install pkg` | `uv add pkg` or `uv pip install pkg` |
| `pip-tools compile` | `uv pip compile` |
| `pip-tools sync` | `uv pip sync` |
| `poetry add` | `uv add` |
| `poetry run` | `uv run` |
| `pipx run` | `uvx` |

## Help

```bash
uv --help
uv help run
uv help add
```
