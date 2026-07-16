#!/usr/bin/env python3
"""Exact token count via tiktoken (cl100k_base). Used by prompt-coach."""
import sys

def main() -> int:
    if len(sys.argv) < 2:
        print("0", file=sys.stderr)
        return 1
    text = sys.argv[1]
    if not text:
        print("0")
        return 0
    try:
        import tiktoken
        enc = tiktoken.get_encoding("cl100k_base")
        print(len(enc.encode(text)))
        return 0
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

if __name__ == "__main__":
    raise SystemExit(main())
