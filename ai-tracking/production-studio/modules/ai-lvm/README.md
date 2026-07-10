# Module: ai-lvm

**Owns:** Still + motion prompts, provider routing, gen retry.

## Inputs
- Storyboard from shared module
- Segments with `track: ai` or `hybrid`
- Style lock from `references/style-lock.md`

## Outputs
- `storyboard-json.prompt`
- `omni-flash-merge.prompt`
- Downloaded gen assets (user folder, not hub git)

## Providers
| Priority | Tool |
|----------|------|
| 1 | Magnificent MCP |
| 2 | gemini / Veo via browser |
| 3 | Kling / Seedance external UI |

## Split boundary
Future `skills/ai-lvm-studio` — only this README + LVM-PIPELINE + Magnificent routes.
