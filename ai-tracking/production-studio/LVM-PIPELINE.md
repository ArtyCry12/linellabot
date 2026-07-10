# Production Studio — LVM pipeline (P3 / REQ-049–057)

**Status:** MVP documented · smoke pending user media  
**Skill:** `skills/production-studio/SKILL.md`  
**Architecture source:** `OMNI-REEL-ARCHITECTURE.md` (REQ-058)

---

## End-to-end flow

```
Brief → Style lock → Script (viral ref) → Segment split → Per-segment prompts → LVM gen → QC → Subtitles/motion → Export
```

| Phase | Output | Tool / route |
|-------|--------|--------------|
| 1. Brief | Goal, platform, duration 15–30s | User + `@production-studio` |
| 2. Style lock | Palette, aspect 9:16, tone | Ask once if unclear |
| 3. Script | Hook→Tension→Value→Payoff→CTA | `refs/REF-*.md` or `USER-*.md` |
| 4. Storyboard table | Shots × timing × camera | `references/storyboard-director.md` |
| 5. Segment split | 2/4/6/8/10 s chunks | REQ-057 — no narrative breaks |
| 6. Prompt A | Still storyboard JSON | Magnificent MCP / external image gen |
| 7. Prompt B | Motion merge prompt | Gemini / Veo / Kling / Seedance |
| 8. QC | Retry loop, human gate | Okara-style approve-before-publish |
| 9. Assembly | DaVinci / CapCut manual | Subtitles from SRT |

---

## LVM routing

| Provider | When | Hub access |
|----------|------|------------|
| **Google Veo / Omni Flash** | Primary motion + typography | `gemini` MCP, browser |
| **Kling 3.0** | Character motion, lip-sync alt | External UI / future MCP |
| **Seedance 2.0** | Dance / kinetic shorts | External |
| **Magnificent** | Prompt craft for video | `mcp.magnific.com` |

**Policy:** No auto-spend on paid gen — confirm if batch >3 segments.

---

## Segment prompt formula

`[Visual type/style] + [Subject & action] + [Environment] + [Light & angle] + [Params/text]`

Each segment file MUST include:

1. Camera (lens, movement, framing)
2. Action + character refs
3. Tags + links to refs
4. Duration (2–10 s)
5. Part index `k/N`

---

## Storyboard Director contract

Trigger: `/storyboard` or word `Storyboard`  
Input: SRT/VTT + part `k/N` + optional refs  
Outputs:

- `storyboard-json.prompt` — grid still (9:16)
- `omni-flash-merge.prompt` — animate still + plate video
- Optional shot list (face / PiP / full-frame)

See `skills/production-studio/references/storyboard-director.md`.

---

## Smoke checklist (P3)

- [ ] One 10 s talking-head segment → SRT
- [ ] Storyboard Director → dual prompts
- [ ] One Magnificent or gemini gen attempt
- [ ] Document failures + retry policy

---

## REQ coverage

| REQ | Status |
|-----|--------|
| 049 | This doc + skill |
| 050–053 | storyboard-director + skill formula |
| 054–055 | refs vault (18) + USER-*.md slot |
| 056 | Live-action note in REF-16/17 |
| 057 | Segment durations in skill + here |
| 058 | OMNI-REEL-ARCHITECTURE ✓ |
| 065 | MoneyPrinter patterns in refs INDEX |
