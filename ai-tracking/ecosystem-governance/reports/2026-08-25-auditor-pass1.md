# Auditor pass 1 — plan (2026-08-25)

Source: [Adversarial plan pass 1](3effd18e-f45b-4759-b6d6-fee79d643ed7)

**Вердикт:** FAIL (дыры закрываются в execute, не игнор)

Implementer mitigations (без правки plan.md):

1. `generate-skill-index.mjs` — сканировать `blocks/*/skills` один уровень; skip `_quarantine`.
2. Domain `.ps1` в блок; корневые `.md` slash + `routes.json` пути обновить на `blocks/...`.
3. Keep-list: AGENTS, LOCKED, SYSTEM-REGISTRY, registry.json, User Rules.
4. Remotion → `blocks/media` only.
5. `.cursor/rules` = 8 always-on stubs; не гонять полный huashu-sync на все mdc.
6. Sentry docs/registry без URL.
7. LIBRARY-INDEX + `.cursorignore` `blocks/*/library/`.
8. Charter SEO merge into `blocks/seo-geo-aio/`.
