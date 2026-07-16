---
name: frontend-design-nested-duplicate
description: Nested install copy — NOT indexed. Canon is ../SKILL.md (skills/frontend-design/SKILL.md).
---

# Nested duplicate (do not use)

Upstream/skills.sh sometimes installs as `frontend-design/frontend-design/SKILL.md`.  
Hub canon: `skills/frontend-design/SKILL.md`.  

`commands/generate-skill-index.mjs` skips `*/name/name/SKILL.md` paths.
