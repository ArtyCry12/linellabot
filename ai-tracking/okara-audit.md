# Okara.ai — audit report

**Date:** 2026-07-10  
**Methods:** cursor-ide-browser (public pages) · fetch (docs, pricing, FAQ) · [llms.txt index](https://okara.ai/docs/llms.txt)  
**Logged-in dashboard:** ✅ live audit `okara-audit-live.md` (2026-07-10)

---

## Executive summary

Okara = **managed AI CMO SaaS**: URL in → strategy docs + **Agents Feed** (daily cards) → human approves → optional one-click publish via integrations.

**Not a copy target** — extract **patterns** for Cursor hub: orchestration, feed UX, human-in-the-loop, GEO as channel, UGC briefs, credits model.

---

## Browser session (cursor-ide-browser)

| Step | Result |
|------|--------|
| Navigate `okara.ai/` | Redirect → Google Sign-in («AI CMO» OAuth client) |
| Navigate `okara.ai/pricing` | OK — plans, FAQ accordion, footer (Docs, Blog, Changelog) |
| Homepage (after nav) | Full agent roster visible in snapshot — 10+ agents listed |
| Dashboard / chat UI | **Blocked** without user login in same browser profile |

**Workaround used:** Public [docs](https://okara.ai/docs/introduction) + [FAQ](https://okara.ai/docs/faq) + [Agents Feed spec](https://okara.ai/docs/dashboard/agents-feed) — equivalent depth for architecture, not live UI screenshots.

---

## Product architecture

### Onboarding

1. User enters website URL  
2. **Terminal** logs setup (2–8 min): scrape → strategy docs → SEO audit → seed channels  
3. **Agents Feed** populates with first cards  

Free: homepage SEO only. Paid: full site audit, all agents.

### Dashboard panels

| Panel | Role |
|-------|------|
| **AI CMO Terminal** | Timestamped activity log (transparency) |
| **Company** | Product profile, brand voice, competitors, strategy — **SSOT for agents** |
| **Analytics** | SEO · GEO · Links · Technical · Traffic (GSC/GA4) |
| **Agents Feed** | Daily queue — **primary action surface** |
| **Talk to AI CMO** | Chat + daily rundown + **context pills** from feed cards |

### Agents Feed — card types

| Card | Agent | Action |
|------|-------|--------|
| SEO Recommendation | SEO | Fix button → CMS / GitHub PR / manual |
| Reddit Thread | Reddit | Copy + post manually (always) |
| X Post | X | Review → one-click if OAuth connected |
| LinkedIn Post | LinkedIn | Same |
| Article | Writer | Publish → WordPress/Webflow/Framer |
| HN Pitch | Hacker News | Copy/post manually |
| GEO Recommendation | GEO | Implement visibility fixes |
| UGC Video | UGC | Brief + multi-aspect clips |

Tabs: **Current** / **Archived**. Writing Instructions per channel (tone, priority subreddits, keywords).

### Agent roster (10)

SEO · GEO · Reddit · X · LinkedIn · Articles · Hacker News · UGC · Coding · Influencer (new)

Refresh cadence: content cards **daily**; SEO/GEO audits **daily** (paid: all pages); analytics sync **daily**; strategy updates propagate in **~6h** cycles.

---

## Pricing & credits

| Plan | Price | Credits |
|------|-------|---------|
| Free | $0 | 20 credits (marketing says 5 one-time in FAQ — verify in-app) |
| Paid | ~$66/mo annual ($990/yr) · ~$99/mo list | 2,000/mo |

Credit draw per action (articles, replies, audits). Agent **pauses** at zero balance; warning at 20%.

---

## Posting & control model (critical)

From [FAQ](https://okara.ai/docs/faq):

- **Reddit:** always manual copy — anti-spam / authenticity  
- **X / LinkedIn:** one-click after OAuth — **not fully automatic**; user clicks Publish  
- **SEO fixes:** never auto — Fix button → CMS/GitHub PR  
- **Articles:** optional CMS auto-publish after review  

→ Aligns with our Zapier write-confirmation + production-studio approval gates.

---

## Integrations

GSC · GA4 · GitHub (Coding PRs) · WordPress/Webflow/Framer · X/LinkedIn OAuth · Telegram/WhatsApp (chat with CMO)

---

## Talk to AI CMO — UX patterns

- **Daily rundown** auto-generated (no prompt needed)  
- **Context pills** attach feed cards into chat  
- Use cases: refine copy, explain analytics, weekly focus, strategy Q&A  

**Hub equivalent:** Notion handoff comments + `user-memory` + `@production-studio` with ref attachment.

---

## UGC agent (Production Studio relevance)

- Guided briefs  
- Multi-aspect AI clips  
- Downloads for social/ads  

Maps 1:1 to our `production-studio` skill + `refs/` vault + segment prompt formula.

---

## What to build in Cursor hub (action list)

| Okara pattern | Hub implementation | Status |
|---------------|-------------------|--------|
| Agents Feed queue | Notion task board + emoji status (`notion-workspace`) | skill ready |
| Company SSOT | `docs/knowledge-base/` + user-memory | partial |
| Terminal log | `ai-tracking/` session logs | ad-hoc |
| Daily rundown | squad-memory after substantive work | policy exists |
| GEO channel | seo-geo GEO skills | installed |
| UGC briefs | production-studio + 18 refs | done |
| SEO fix PRs | squad-build + GitHub | on demand |
| Credits / budget | Apify policy + API budget caps | relaxed policy |
| Multi-project | separate Cursor workspaces | user rule |
| Writing Instructions | agency persona + per-project `.cursor/rules` | agency-agents |

---

## Gaps requiring user login

~~To complete live audit~~ — **done** 2026-07-10. See `okara-audit-live.md`.

Optional follow-up when feed has cards: expand SEO + Reddit cards; full Chat UX in wide tab.

---

## Live audit summary (2026-07-10)

- Route: `/agent/cmo/{uuid}` · nav: Company · Analytics · Agents · Chat
- Agents Settings: per-channel toggles, writing instructions, GEO market, draft frequency, UGC video biweekly
- Fresh project: no feed cards yet; Analytics needs Google connect
- Test project `example.com` created during probe — user should replace

Full detail: [`okara-audit-live.md`](okara-audit-live.md)

## Sources

- https://okara.ai/  
- https://okara.ai/pricing  
- https://okara.ai/docs/llms.txt  
- https://okara.ai/docs/introduction  
- https://okara.ai/docs/dashboard/agents-feed  
- https://okara.ai/docs/dashboard/talk-to-ai-cmo  
- https://okara.ai/docs/faq  
- https://okara.ai/docs/channels/overview  
- Prior: `ai-tracking/okara-knowledge.md`
