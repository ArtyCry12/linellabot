# Production Studio — gap analysis (REQ-049)

**Date:** 2026-07-10  
**Target:** Ready for **manual verification** — system built, user runs tests.

---

## Built (ready to test)

| Component | Artifact | Manual test |
|-----------|----------|-------------|
| Unified arch (live+AI) | `ARCHITECTURE.md`, DEC-056 | Read + pick REF-16 hybrid path |
| LVM pipeline | `LVM-PIPELINE.md` | Follow smoke § in playbook |
| Storyboard Director | `references/storyboard-director.md` | `/storyboard` + sample SRT |
| Segment rules | `references/segment-splitter.md` | Fill `segment-manifest.json` |
| Style lock | `references/style-lock.md` | Lock palette once per project |
| Live module | `references/live-action-module.md` | `live-shoot-brief.md` template |
| Viral refs | 18 × `refs/REF-*.md` | Route script from REF-07 |
| OMNI workflow | `OMNI-REEL-ARCHITECTURE.md` | Compare to your DaVinci flow |
| Transcription | `transcribe-video.ps1` | Run on 10s clip |
| MoneyPrinter patterns | `MONEYPRINTER-PATTERNS.md` | Segment timing reference |
| Templates | `templates/production-studio/*` | Copy for new project |
| Manual playbook | `P3-MANUAL-TEST-PLAYBOOK.md` | **Start here** |

---

## Gaps (by design — user or post-MVP)

| Gap | Severity | Unblock |
|-----|----------|---------|
| USER-*.md commercial scripts | Medium | You upload to `refs/` |
| First LVM gen success | Medium | Reload + Magnificent OAuth + 1 segment |
| DaVinci iTool doc | Low | External; SRT export manual |
| Kling/Seedance MCP | Low | Browser UI for now |
| Auto-publish social | Out of scope | Explicit approval only |
| Whisper on all langs | Low | `transcribe-video.ps1` ru default |

---

## MCP / plugin status

| Tool | Config | Manual verify |
|------|--------|---------------|
| Magnificent | mcp.json | Reload → connect → one prompt |
| gemini | mcp.json | Simple text gen |
| Apify | mcp.json | Policy allows; OAuth |
| cursor-ide-browser | IDE | Selling site snapshot |
| context7 | mcp.json | Doc lookup for shadcn |

---

## Verdict

**REQ-049 satisfied for "built & ready for manual test".**  
Not "production run completed" — that is playbook sections 3–5.
