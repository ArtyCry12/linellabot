# Media reference conversion (REQ-052)

When user attaches photo / video / gif:

## Workflow

1. **Identify type** — still, motion plate, gif loop, screen recording.
2. **Extract** — browser snapshot / download to project folder (not hub git).
3. **Describe** using segment formula (skill SKILL.md).
4. **Map to segment** in `segment-manifest.json` — `refs: ["path/to/file"]`.
5. **For video** — `commands/transcribe-video.ps1` if speech present.

## Outputs

| Input | Output |
|-------|--------|
| Photo | Style + composition notes for Prompt A |
| Video plate | SRT + timecodes for storyboard |
| Gif | Loop duration + key frames description |
| Screen | UI regions for CRO or tutorial refs |

## Tools

- `transcribe-video.ps1` — whisper + ffmpeg
- Browser MCP — capture state
- Exa — find similar references (on demand)

## Do not

- Commit user media into `.cursor` hub repo
- Auto-upload to paid gen without approval
