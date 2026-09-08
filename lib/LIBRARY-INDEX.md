# LIBRARY-INDEX — vendored sources

Nested libraries are reference material. They are not auto-discovered hub
skills, rules, agents, or commands.

| Path | Contents | Discovery policy |
|------|----------|------------------|
| `lib/ecc-src/` | Everything Claude Code source mirror; 894 nested `SKILL.md` files | Read by exact path only; ignored by root `.cursorignore` |
| `lib/n8n-templates-src/` | n8n workflow template source mirror; no `SKILL.md` files | Read by exact path only; add to root `.cursorignore` when permission allows |

Do not stage either source tree as ordinary hub code. Promote only reviewed,
named artifacts into the appropriate `blocks/<id>/` destination.
