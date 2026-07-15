# MCP + Plugins tiers (Session 2 · 2026-07-16)

Aligned with user: always-on minimal · Exa research primary · keep **firecrawl** · archive tavily/browse · disable-archive list.

## always-on (agents should expect)

| ID | Notes |
|----|-------|
| memory | LTM DEC-009 |
| gitnexus | Code graph |
| markitdown | Prefer **hook**; MCP optional |

## on-demand (task-router / explicit)

| ID | Trigger |
|----|---------|
| plugin-exa-exa | Web research **primary** |
| fetch | One URL |
| plugin-firecrawl-firecrawl | Crawl-at-scale (kept) |
| playwright | E2E |
| chrome-devtools | DOM debug |
| cursor-ide-browser | IDE smoke |
| stitch / figma | Design mock / D2C |
| context7 | Library docs |
| n8n-mcp · notion · iconify · @21st-dev/magic · magnific · gemini · google-* · apify · prompts.chat | By task |
| plugin-vercel / supabase / stripe / clerk / zapier / gitlab / harness / linear / shadcn / aikido | When task matches |

## disable-archive (do not load by default)

| Item | Why |
|------|-----|
| obsidian (mcp.json.example) | DEC-009 removed — **removed from example** |
| plugin-tavily-tavily + tavily MCP | Duplicate web; Exa primary |
| browse plugin | Overlaps playwright/chrome/ide-browser |
| Low-signal plugins (until explicit task) | braintrust, hex, heygen, higgsfield, mainframe, meta-quest, thermos, pstack, functions, canva, webflow, wix, huggingface-skills, omni-analytics, docs-canvas, pr-review-canvas, continual-learning, agent-compatibility, cli-for-agent, create-plugin, cursor-sdk, redis-development, postman (unless API work), firebase, cloudflare, wix |

**Browser routing:** e2e→playwright · debug→chrome-devtools · smoke→cursor-ide-browser.  
**Web routing:** research→Exa · single URL→fetch · crawl→firecrawl · not parallel Tavily.

### Operator note

Cursor plugins cannot be “archived” by filesystem alone — disable in **Settings → Plugins**. This file + `lib/mcp-router/McpTier.ps1` are the hub source of truth for agents.
