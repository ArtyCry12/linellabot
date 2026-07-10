# Selling site sandbox (REQ-047 practice)

Use to verify CRO + design-stack without production deploy.

## Bootstrap

```bash
# Any empty folder
node C:/Users/Asus/.cursor/skills/clone-website/scripts/init-clone-project.mjs ./selling-sandbox
cd selling-sandbox
npm install
npm run dev
```

## Build pass

1. `@design-stack` — hero + proof + FAQ + CTA
2. `@21st` or shadcn MCP for blocks
3. `SELLING-SITE-MANUAL-CHECKLIST.md` — tick boxes
4. Browser MCP snapshot at `localhost:3000`
5. `seo-audit.ps1 -Url http://localhost:3000`

## Done when

Checklist all [x] or documented exceptions.
