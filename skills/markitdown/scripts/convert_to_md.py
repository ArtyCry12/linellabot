#!/usr/bin/env python3
"""Batch-convert files to Markdown via MarkItDown (token-efficient agent intake)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

_MIN_PYTHON = (3, 10)


def _check_python() -> None:
    if sys.version_info < _MIN_PYTHON:
        print(
            f"Python {sys.version_info.major}.{sys.version_info.minor} is too old; "
            f"markitdown needs >= {_MIN_PYTHON[0]}.{_MIN_PYTHON[1]}. "
            "On Windows try: py -3.12 -m pip install \"markitdown[all]\"",
            file=sys.stderr,
        )
        raise SystemExit(1)


def _default_output_dir() -> Path:
    return Path.cwd() / ".cache" / "markitdown"


def _safe_out_path(out_dir: Path, src: Path) -> Path:
    out_dir.mkdir(parents=True, exist_ok=True)
    stem = src.stem or "document"
    candidate = out_dir / f"{stem}.md"
    if not candidate.exists():
        return candidate
    n = 1
    while True:
        candidate = out_dir / f"{stem}_{n}.md"
        if not candidate.exists():
            return candidate
        n += 1


def convert_one(src: Path, out_dir: Path, *, plugins: bool) -> Path:
    try:
        from markitdown import MarkItDown
    except ImportError as exc:
        print(
            "markitdown is not installed. Run: pip install \"markitdown[all]\"",
            file=sys.stderr,
        )
        raise SystemExit(1) from exc

    if not src.is_file():
        print(f"not a file: {src}", file=sys.stderr)
        raise SystemExit(1)

    md = MarkItDown(enable_plugins=plugins)
    result = md.convert_local(str(src.resolve()))
    text = getattr(result, "markdown", None) or result.text_content or ""
    out_path = _safe_out_path(out_dir, src)
    out_path.write_text(text, encoding="utf-8")
    return out_path


def main() -> None:
    _check_python()
    parser = argparse.ArgumentParser(
        description="Convert documents to Markdown for LLM-friendly, token-efficient reading.",
    )
    parser.add_argument(
        "inputs",
        nargs="+",
        help="One or more files to convert (PDF, DOCX, PPTX, XLSX, HTML, …).",
    )
    parser.add_argument(
        "-o",
        "--output-dir",
        type=Path,
        default=None,
        help="Directory for .md outputs (default: ./.cache/markitdown).",
    )
    parser.add_argument(
        "--plugins",
        action="store_true",
        help="Enable MarkItDown third-party plugins (disabled by default).",
    )
    args = parser.parse_args()

    out_dir = args.output_dir or _default_output_dir()
    written: list[Path] = []

    for raw in args.inputs:
        src = Path(raw).expanduser()
        try:
            out = convert_one(src, out_dir, plugins=args.plugins)
            written.append(out)
            print(out.resolve())
        except Exception as exc:
            print(f"failed: {src}: {exc}", file=sys.stderr)
            raise SystemExit(1) from exc

    if len(written) == 1:
        print(f"# ok: 1 file -> {written[0]}", file=sys.stderr)
    else:
        print(f"# ok: {len(written)} files -> {out_dir}", file=sys.stderr)


if __name__ == "__main__":
    main()
