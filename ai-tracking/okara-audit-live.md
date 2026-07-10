# Okara.ai — live dashboard audit (REQ-059)

**Date:** 2026-07-10 02:34 UTC+3  
**Browser:** cursor-ide-browser · viewId `4ff697`  
**Session URL:** `https://okara.ai/agent/cmo/604643f3-cbce-40fd-8ec6-60e128574f13`  
**Account:** logged in (Google OAuth OK) · **20 credits** visible in header  
**Test project:** ~~`example.com`~~ **deleted** 2026-07-10 (Settings → Account → Delete Agent)

---

## Access path (confirmed live)

1. `okara.ai/` → marketing homepage (logged-in users still land here until project exists)
2. Enter website URL → **Get Started** → onboarding
3. App route: **`/agent/cmo/{project-uuid}`** — not `/dashboard` or `/app` (both 404)

---

## Shell layout (live)

| Zone | Control | Notes |
|------|---------|-------|
| Top bar | `Toggle terminal` | Opens/closes AI CMO Terminal log panel |
| Top bar | `{domain}` dropdown | Project switcher (e.g. `example.com`) |
| Top bar | User avatar + credits | e.g. `AARKR20 Credits` |
| Left nav | **Company** | SSOT profile, Documents, Competitors |
| Left nav | **Analytics** | SEO/GEO/traffic; **Connect Google services** CTA |
| Left nav | **Agents** | Full dashboard: Company + Analytics + **Agents Feed** + Talk to CMO |
| Left nav | **Chat** | Focus mode → **Talk to AI CMO** only |
| Agents view | `Content instructions settings` | Per-channel writing rules modal |
| Agents view | `Collapse all` | Collapse dashboard sections |

**Chat vs Agents:** Chat hides feed/company panels — single-purpose CMO chat. Agents = unified command center (matches docs).

---

## Onboarding (first run)

Modal after Get Started:

- X + LinkedIn handle fields (`yourhandle`)
- **Save & Continue** / **Skip** (countdown timer ~47s)
- Skippable social connect before full dashboard

---

## Company panel (live, example.com project)

Auto-generated from URL scrape:

- **Company** blurb (IANA example.com description populated)
- **Documents** section (strategy docs — headings visible, content loading/empty in fresh project)
- **Competitors** section

---

## Analytics panel (live)

- **Connect Google services** button (GSC/GA4 OAuth gate)
- Full analytics widgets not populated without Google connect + crawl completion

---

## Agents Feed (live)

- Section heading present; **no feed cards yet** (fresh project, setup still running or credits not spent)
- Expected card types per docs: SEO, Reddit, X, LinkedIn, Article, HN, GEO, UGC
- **Content instructions settings** opens full **Agents Settings** modal (see below)

---

## Agents Settings modal (live — high value)

Opened via gear on Agents view.

| Section | Toggle | Fields |
|---------|--------|--------|
| **General instructions** | — | Cross-platform rules (4000 chars): brand facts, phrases to avoid, positioning, audience |
| **SEO Analysis** | ON | Market/Language combo (US English default); note: ChatGPT GEO data US-only |
| **Reddit** | ON | Writing instructions; **Search region** (Global + 36 countries); **Priority subreddits** Add; **Search keywords** Add |
| **X (Twitter)** | ON | Writing instructions (contrarian hooks, short lines, subtle CTA) |
| **LinkedIn** | ON | Founder voice instructions |
| **Articles** | ON | Practical depth, examples, professional tone |
| **Draft frequency** | — | Articles: Daily / Weekly / Biweekly |
| **Auto-generate video** | ON | Biweekly / Weekly / Off |

**Save** disabled until edits made. **Market/Language** affects GEO mention counts and competitor comparisons on next run.

---

## Talk to AI CMO (live)

- Dedicated section in Agents view; Chat nav isolates this panel
- Chat input not fully exposed in narrow side-panel a11y tree — open in wider browser for full chat UX audit

---

## Terminal (live)

- **Toggle terminal** control confirmed in header
- Log content not captured in side-panel snapshot (layout constraint) — reopen in full-width tab for timestamped setup log

---

## Homepage delta vs prior public audit

Marketing page now lists **13 capabilities** (not 10):

- Core 10 agents + **Google Search Console** + **Google Analytics** + **Link Broker Agent**

Banner: **Influencer Agent** — «Automate creator outreach!»

---

## Hub takeaways (live-confirmed)

1. **Project = `/agent/cmo/{uuid}`** — map to Cursor workspace / Notion project ID
2. **Agents Settings** ≈ our `.cursor/rules` + agency personas + seo-geo market locale
3. **Unified Agents view** beats separate tools — feed + SSOT + analytics in one scroll
4. **Credit badge** in header — mirror with Apify/API budget indicator in hub
5. **Onboarding skip** — don't block first value on OAuth for X/LinkedIn

---

## Screenshots

- Agents Settings: `ai-tracking/okara-live-dashboard.png` (temp capture path; copy to vault if needed)

---

## Remaining (optional, user action)

- [x] ~~Delete `example.com` test project~~ — done 2026-07-10
- [ ] Add real site URL when ready (okara.ai homepage → Get Started)
- [ ] Connect Google services for Analytics panel
- [ ] Re-audit when Agents Feed has cards (expand one SEO + one Reddit card)
- [ ] Full Talk to CMO chat + context pills in wide browser tab
