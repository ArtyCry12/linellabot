# Photocard — AI video prompts (Production Studio)

**Use for:** short photocard / talking-head / B-roll clips (2-10s segments, REQ-057).

## Photocard types

| Type | Duration | Track |
|------|----------|-------|
| Hook photocard | 2-4s | ai |
| Proof / stat | 4-6s | ai or hybrid |
| CTA end card | 4-6s | ai |

## Prompt formula (extends segment formula)

```
[Subject + action] + [Framing: close-up/medium] + [Lighting] + [Motion: slow push/static] + [Duration Xs] + [No audio/subtitles burn-in]
```

### Hook example (4s)

```
Young professional at desk, looks up at camera with confident smile, soft window light,
shallow depth of field, slow push-in, 4 seconds, cinematic, no text overlay, vertical 9:16.
```

### Stat photocard (6s)

```
Abstract data visualization particles forming upward arrow, dark navy background,
accent cyan glow, subtle camera drift, 6 seconds, clean, no readable numbers unless specified.
```

## Hybrid (AI bg + live face)

1. Generate background plate with LVM prompt above
2. Live A-roll per `references/live-action-module.md`
3. Composite in edit — document in segment manifest `track: hybrid`

## Magnificent / Veo / Kling

Route video gen prompts through Magnificent MCP when configured. Keep **one duration per project** (REQ-057).

## Template file

`templates/production-studio/photocard-prompts.json` — batch prompts linked to segment IDs.

## QC checklist

- [ ] Duration matches manifest chunk (2/4/6/8/10)
- [ ] Style lock colors respected
- [ ] No unintended text in frame
- [ ] Safe zone for platform UI (9:16 top/bottom)
