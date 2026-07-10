---
name: markitdown
description: Converts PDF, Office, HTML, audio, images, ZIP, EPUB, and more to token-efficient Markdown using Microsoft MarkItDown before LLM analysis. Use when the user attaches binary documents, asks to read/extract/summarize PDFs or Office files, mentions markitdown, markdown conversion, or token economy (экономия токенов). Prefer converted .md over raw binaries in context.
disable-model-invocation: false
---

# MarkItDown (token-efficient document intake)

Convert files to Markdown **before** loading content into the conversation. Markdown preserves structure (headings, lists, tables) with fewer tokens than raw Office/PDF payloads or base64.

## When to use

- User shares `.pdf`, `.docx`, `.pptx`, `.xlsx`, `.html`, `.epub`, `.msg`, images, audio, or ZIP archives
- Task is summarize, extract, compare, or QA on document content
- User mentions **markitdown**, **convert to markdown**, or **экономия токенов**

## Default workflow

1. **Convert** with the bundled script (do not paste binary into chat):

```bash
python scripts/convert_to_md.py "path/to/file.pdf" -o .cache/markitdown
```

Multiple files:

```bash
python scripts/convert_to_md.py report.pdf deck.pptx data.xlsx -o .cache/markitdown
```

2. **Read** the emitted `.md` paths with the Read tool. For large outputs, use `offset`/`limit` or `Grep` on the `.md` file instead of loading the whole file at once.

3. **Answer** from the Markdown text. Cite the source filename; do not re-embed the original binary.

## Setup (once per machine)

**Requires Python 3.10+** (not 3.8/3.9). On Windows, install e.g. [python.org 3.12](https://www.python.org/downloads/) then:

```bash
py -3.12 -m pip install "markitdown[all]"
py -3.12 scripts/convert_to_md.py file.pdf -o .cache/markitdown
```

Or with a single `python` on PATH:

```bash
pip install "markitdown[all]"
```

For minimal installs (smaller env), see [reference.md](reference.md) optional extras.

**Local source** (optional, from your library zip):

```bash
pip install -e "C:/Users/Asus/.cursor/skills-libraries/markitdown-main-extracted/markitdown-main/packages/markitdown[all]"
```

## CLI alternative

```bash
markitdown "path/to/file.pdf" -o .cache/markitdown/file.md
```

Stdin pipe: `markitdown < file.pdf > out.md`

## Token rules

| Do | Don't |
|----|--------|
| Convert → read `.md` in chunks | Read PDF/DOCX as binary in context |
| Keep outputs under `.cache/markitdown/` or `tmp/` | Dump full conversion to the user message |
| `Grep` / partial Read on huge `.md` | Load 500+ page `.md` in one shot |
| One conversion per source file | Re-convert unchanged files every turn |

## Security

- Untrusted uploads: use `convert_local` only (the script does this). Do not pass user-controlled URLs to `convert()` without validation.
- Prefer narrow APIs: local files → script/CLI; avoid `--use-plugins` unless needed.
- MCP `markitdown-mcp` is for **localhost / trusted** use only.

## Cloud / OCR (only if user asks)

- Azure Document Intelligence: `markitdown file.pdf -d -e "<endpoint>"`
- Azure Content Understanding: `--use-cu --cu-endpoint "<endpoint>"`
- OCR in embedded images: `markitdown-ocr` plugin + `llm_client` (extra cost)

## MCP (optional)

`pip install markitdown-mcp` — tool `convert_to_markdown(uri)` for `file:`, `http:`, `https:`. Bind to localhost only.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `UnsupportedFormatException` | Install extra: `pip install "markitdown[pdf]"` etc. — see reference.md |
| Empty / garbled text | Scanned PDF → try `-d` Document Intelligence or `markitdown-ocr` |
| Script not found | Run from skill dir or pass absolute path to `scripts/convert_to_md.py` |

## More detail

- Format matrix and optional deps: [reference.md](reference.md)
