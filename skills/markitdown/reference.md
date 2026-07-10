# MarkItDown reference

## Supported inputs (common)

| Format | Extension hints | Optional pip extra |
|--------|-----------------|-------------------|
| PDF | `.pdf` | `[pdf]` |
| Word | `.docx` | `[docx]` |
| PowerPoint | `.pptx` | `[pptx]` |
| Excel | `.xlsx`, `.xls` | `[xlsx]`, `[xls]` |
| HTML | `.html`, `.htm` | (base) |
| CSV / JSON / XML | `.csv`, `.json`, `.xml` | (base) |
| Images | `.jpg`, `.png`, … | EXIF; OCR via plugins/LLM |
| Audio | `.wav`, `.mp3` | `[audio-transcription]` |
| Outlook | `.msg` | `[outlook]` |
| EPUB | `.epub` | (base) |
| ZIP | `.zip` | iterates contents |
| YouTube | URL | `[youtube-transcription]` |

Install everything: `pip install "markitdown[all]"`

## Python API (minimal)

```python
from markitdown import MarkItDown

md = MarkItDown(enable_plugins=False)
result = md.convert_local("report.pdf")
text = result.text_content  # or result.markdown
```

Untrusted local files only — avoid `convert()` with arbitrary URLs.

## Result fields

- `text_content` — plain text oriented output
- `markdown` — markdown-oriented output when available

Use whichever fits the downstream task; both are LLM-friendly.

## Why Markdown saves tokens

Markdown is close to plain text: structure without verbose markup. Models are trained heavily on Markdown, so Q&A over `.md` is usually more token-efficient than shipping Office/XML internals or base64.

## Upstream

- Repo: https://github.com/microsoft/markitdown
- Local extract: `C:/Users/Asus/.cursor/skills-libraries/markitdown-main-extracted/markitdown-main/`
- Zip source: `C:/Users/Asus/.cursor/skills-libraries/markitdown-main ( экономия токенов ).zip`
