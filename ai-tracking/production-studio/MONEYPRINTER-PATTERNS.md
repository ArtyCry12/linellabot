# MoneyPrinterV2 + prompt patterns (REQ-065)

**Sources:** FujiwaraChoki/MoneyPrinterV2 · promptslab/Awesome-Prompt-Engineering  
**Use:** Automation loops and segment timing — **patterns only**, not full install.

---

## Extracted patterns for hub

| Pattern | Hub mapping |
|---------|-------------|
| Topic → script → scenes → voice → assets → render | `LVM-PIPELINE.md` phases |
| Scene = timed chunk | `segment-manifest.json` |
| Stock/asset search per scene | Exa + Apify (policy) for refs |
| TTS/voiceover optional | Live plate OR future TTS skill |
| Config-driven pipeline | `templates/production-studio/project-brief.md` |

---

## Segment timing (align REQ-057)

MoneyPrinter-style scene length: **3–10s** per visual beat.  
Hub standardizes: **2 / 4 / 6 / 8 / 10** — pick one duration per project for LVM API limits.

---

## Prompt layering (Awesome-Prompt-Engineering)

1. **Role** — "You are a short-form director…"
2. **Constraints** — aspect 9:16, no greeting, hook in 2s
3. **Format** — JSON storyboard OR plain motion prompt
4. **Examples** — one REF-* per request
5. **Verification** — "List shots with timestamps"

Storyboard Director implements layers 1–4; QC gate is layer 5.

---

## Do not install

- MoneyPrinterV2 as runtime server in hub
- Bulk auto-post without approval

Route: `@production-studio` + refs + Magnificent for video-specific prompts.
