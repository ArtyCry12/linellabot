# Storyboard — Production Studio

**Slash:** `/storyboard` · **Skill:** `@production-studio`

Input: **$ARGUMENTS** (SRT path, part k/N, or paste transcript)

---

## Contract

Follow `skills/production-studio/references/storyboard-director.md` exactly.

## Steps

1. If missing — ask **only**: part `k/N`, palette preset, aspect (default 9:16).
2. Parse SRT/transcript → key beats.
3. Emit **Output A** — `storyboard-json.prompt` (JSON).
4. Emit **Output B** — `omni-flash-merge.prompt` (plain text).
5. Emit **Output C** — shot list markdown table.

## Track awareness (DEC-056)

- `live` segments → shot list emphasizes A-roll/B-roll; AI prompts optional for hybrid only.
- `hybrid` → both outputs required.
- `ai` → outputs A+B required; no shoot brief.

## Templates

Copy results into project folder using `templates/production-studio/storyboard-table.md` and update `segment-manifest.json`.
