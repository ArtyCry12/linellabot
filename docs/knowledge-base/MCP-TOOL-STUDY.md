# MCP tool study — context7, iconify, shadcn (REQ-011–013)

**Config:** `mcp.json` · Routing: `rules/mcp-routing.mdc`

---

## context7 (`@upstash/context7-mcp`) — REQ-013

| Field | Value |
|-------|-------|
| Transport | stdio via `npx -y @upstash/context7-mcp` |
| Purpose | Up-to-date library/framework docs in context |

**When to use**

- Before using API you're unsure about (Next.js, Tailwind, Prisma, etc.)
- After training-cutoff features
- **Before** writing custom UI when docs might show official pattern

**Workflow**

1. Resolve library ID (tool descriptor)
2. Fetch docs for specific topic
3. Implement — then typecheck

**Pair with:** gitnexus for *this* repo's symbols; context7 for *external* libs.

---

## iconify (`iconify-mcp-server`) — REQ-012

| Field | Value |
|-------|-------|
| Transport | stdio `npx -y iconify-mcp-server` |
| Purpose | Search 200k+ icons across Iconify collections |

**When to use**

- UI needs icon — search before importing random SVG
- Match design system (lucide vs mdi vs tabler)

**Production path**

- MCP for discovery → install `@iconify-json/<set>` + `@iconify/react` for offline bundle

---

## shadcn — REQ-011

**Not a separate stdio MCP in `mcp.json`.** Fulfilled via:

| Layer | Role |
|-------|------|
| Cursor **shadcn plugin** | Registry browse/install in IDE |
| `@21st-dev/magic` MCP | `21st-design` skill — search, add components |
| `skills/design-stack` | Registry-first policy |

**Contract:** Browse → install via MCP URL → adapt tokens. **No copy-paste** from docs.

**Verify:** Reload Window if plugin tools missing.

---

## Smoke checklist

- [ ] context7: query `next.js` app router caching
- [ ] iconify: search `arrow-right`
- [ ] shadcn: `21st-design` ensure-library + one component add path

*P2 · 2026-07-10*
