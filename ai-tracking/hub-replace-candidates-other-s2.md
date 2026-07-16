# Hub replace candidates — other domains (Session 2)

**Status updated:** 2026-07-16 after Session 2 installs + hub wrappers.

Policy: Sacred (do **not** replace): task-router, squad agents, dev-os, markitdown, find-skills wire, **seo-geo library** (complementary skills only).

---

## Install status summary

| Status | Items |
|--------|--------|
| **Installed + wired** | See §Integration below — 20 hub wrappers + routes |
| **Failed / miss** | `growth-funnel` (not in upstream install set; used `entity-seo` substitute), `aidoc n8n` (`vladm3105/aidoc-flow-framework@n8n` install failed) |
| **Skip** | `firestore-security-rules-auditor` (not separate in firebase package), `jwynia/secrets-scan` (not present; used `secret-scanning` instead), `paw-mkt-agent-agency`, `testing-ci`, `n8n-skills`, generic `security-auditor` fork |

### Wired hub ids (Session 2)

| Hub id | Upstream `~/.agents/skills/` | Route id |
|--------|------------------------------|----------|
| `opc-seo-geo` | `seo-geo` (resciencelab) | `opc-seo-geo` |
| `seo-audit` | `seo-audit` | `seo-audit-ms` |
| `programmatic-seo` | `programmatic-seo` | `programmatic-seo` |
| `ai-search-optimization` | `ai-search-optimization` | `ai-search-optimization` |
| `core-web-vitals` | `core-web-vitals` | `core-web-vitals` |
| `entity-seo` | `entity-seo` | `entity-seo` |
| `copywriting` | `copywriting` | `copywriting` |
| `content-strategy` | `content-strategy` | `content-strategy` |
| `marketing-psychology` | `marketing-psychology` | `marketing-psychology` |
| `marketing-ideas` | `marketing-ideas` | `marketing-ideas` |
| `n8n-workflow-automation` | `n8n-workflow-automation` | `n8n-workflow-automation` |
| `n8n-workflow-architect` | `n8n-workflow-architect` | `n8n-workflow-architect` |
| `playwright` | `playwright` | `playwright-e2e` |
| `playwright-visual-testing` | `playwright-visual-testing` | `playwright-visual-testing` |
| `code-review-pro` | `code-review-pro` | `code-review-pro` |
| `qa-start` | `qa-start` | `qa-start` |
| `firebase-security-rules-auditor` | `firebase-security-rules-auditor` | `firebase-security-rules` |
| `cloudflare-security-audit` | `security-audit` | `cloudflare-security-audit` |
| `devsecops-expert` | `devsecops-expert` | `devsecops-expert` |
| `secret-scanning` | `secret-scanning` | `secret-scanning` |

**Clash handling:** `opc-seo-geo` hub id avoids `skills/seo-geo/` pack; `cloudflare-security-audit` hub id avoids route `security-audit` → `cybersecurity`; `seo-audit-ms` route id avoids duplicate `seo-audit` skill folder vs hub `skills/seo-audit/`.

---

## 1. SEO / GEO / growth

### Hub already has

| Asset | Path / route |
|-------|----------------|
| SEO/GEO pack (20 skills, CORE-EEAT/CITE) | `skills/seo-geo/` + `skills/seo-geo/library/` |
| Task route | `lib/task-router/routes.json` → `seo-geo`, `pagespeed` |
| Commands | `commands/seo-audit.ps1`, `seo-stack-verify.ps1`, `gsc-audit.ps1` |
| Squad | `agents/squad-growth.md` |
| Pipeline | `skills/crew-ai/` (marketing crew JSON) |

### Candidates

| Hub pain | Candidate (owner/repo@skill) | Installs (approx) | Suggested `npx skills add ...` | Suggestion |
|----------|-------------------------------|-------------------|--------------------------------|------------|
| GEO/AEO layer thin vs catalog leader | `resciencelab/opc-skills@seo-geo` | **35K** | … | **Installed** → `skills/opc-seo-geo/` |
| Founder/growth SEO playbook missing | `coreyhaines31/marketingskills@seo-audit` | **162K** | … | **Installed** → `skills/seo-audit/` |
| Programmatic SEO not first-class | `coreyhaines31/marketingskills@programmatic-seo` | **103K** | … | **Installed** → `skills/programmatic-seo/` |
| AI search / citation optimization | `dirnbauer/webconsulting-skills@ai-search-optimization` | **238** | … | **Installed** → `skills/ai-search-optimization/` |
| CWV route (`pagespeed`) has no dedicated skill | `tech-leads-club/agent-skills@core-web-vitals` | **160** | … | **Installed** → `skills/core-web-vitals/` |
| Growth funnel / SaaS motion | `kostja94/marketing-skills@growth-funnel` | **875** | … | **Failed-miss** — not installed; **entity-seo** wired as substitute |

---

## 2. n8n / automation / integrations

### Hub already has

| Asset | Path / route |
|-------|----------------|
| Workflow authoring (n8n-mcp distilled) | `skills/n8n-workflow/` |
| Template matcher (280+ JSON index) | `skills/n8n-templates/` + `lib/n8n-templates/` |
| Task route | `n8n-automation`, `automation-audit` |
| MCP | `user-n8n-mcp` |
| Commands | `commands/n8n-templates-match.ps1`, `n8n-mcp.md`, `n8n-workflow.md` |

### Candidates

| Hub pain | Candidate (owner/repo@skill) | Installs (approx) | Suggested `npx skills add ...` | Suggestion |
|----------|-------------------------------|-------------------|--------------------------------|------------|
| Architect-level n8n patterns | `vladm3105/aidoc-flow-framework@n8n` | **447** | … | **Failed-miss** — install failed; keep `n8n-workflow` anchor |
| Workflow automation recipes | `sundial-org/awesome-openclaw-skills@n8n-workflow-automation` | **248** | … | **Installed** → `skills/n8n-workflow-automation/` |
| Multi-workflow design / review | `promptadvisers/n8n-powerhouse@n8n-workflow-architect` | **227** | … | **Installed** → `skills/n8n-workflow-architect/` |
| OpenClaw n8n bundle | `nicepkg/ai-workflow@n8n-skills` | **46** | … | **Skip** — low installs vs hub stack |

**Keep:** `n8n-workflow`, `n8n-templates`, n8n-mcp — catalog skills are thin; hub authoring skill is the anchor.

---

## 3. Engineering / QA / CI

### Hub already has

| Asset | Path / route |
|-------|----------------|
| PR review (gh, score ≥80) | `skills/pr-review/` → route `pr-review` |
| Discipline skills | `verification-before-completion`, `systematic-debugging`, `mattpocock-skills`, `triage`, `tdd`, `diagnose`, `git-guardrails-claude-code` |
| CI route | `ci-debug` → subagent `ci-investigator` |
| Squad | `squad-qa`, `squad-review`, `squad-build`, `squad-architect` |
| E2E route | `browser-e2e` (MCP playwright / cursor-ide-browser) |
| Harness | `skills/ecc-harness/` |

### Candidates

| Hub pain | Candidate (owner/repo@skill) | Installs (approx) | Suggested `npx skills add ...` | Suggestion |
|----------|-------------------------------|-------------------|--------------------------------|------------|
| No Playwright skill (MCP-only E2E) | `bobmatnyc/claude-mpm-skills@playwright-e2e-testing` | **2.7K** | … | **Installed** as `playwright` → `skills/playwright/` |
| Visual regression gap | `manutej/luxor-claude-marketplace@playwright-visual-testing` | **946** | … | **Installed** → `skills/playwright-visual-testing/` |
| PR review depth vs Anthropic plugin | `onewave-ai/claude-skills@code-review-pro` | **2.4K** | … | **Installed** → `skills/code-review-pro/` |
| QA bootstrap protocol | `petrkindlmann/qa-skills@qa-start` | **146** | … | **Installed** → `skills/qa-start/` |
| CI testing graph | `alphaonedev/openclaw-graph@testing-ci` | **44** | … | **Skip** — prefer `ci-investigator` subagent |

**Keep:** squad QA chain, `pr-review`, `ci-debug` route — do not replace with catalog forks.

---

## 4. Content / marketing / agency personas

### Hub already has

| Asset | Path / route |
|-------|----------------|
| 66 agency personas | `skills/agency-agents/` + `rules/agency/*.mdc` |
| Task route | `agency-persona` |
| Crew pipelines | `skills/crew-ai/` (marketing-crew.json) |
| Creative loop | `skills/babyagi/`, `commands/creative-loop.ps1` |
| Prompt library | `skills/awesome-prompts/` |

### Candidates

| Hub pain | Candidate (owner/repo@skill) | Installs (approx) | Suggested `npx skills add ...` | Suggestion |
|----------|-------------------------------|-------------------|--------------------------------|------------|
| No liquid copywriting skill in hub | `coreyhaines31/marketingskills@copywriting` | **152K** | … | **Installed** → `skills/copywriting/` |
| Content strategy / calendar depth | `coreyhaines31/marketingskills@content-strategy` | **107K** | … | **Installed** → `skills/content-strategy/` |
| Persuasion / CRO psychology | `coreyhaines31/marketingskills@marketing-psychology` | **112K** | … | **Installed** → `skills/marketing-psychology/` |
| Marketing ideas backlog | `coreyhaines31/marketingskills@marketing-ideas` | **100K** | … | **Installed** → `skills/marketing-ideas/` |
| Agency persona pack on skills.sh | `pawbytes/skill-suites@paw-mkt-agent-agency` | **74** | … | **Skip** — hub `agency-agents` is deeper |

**Keep:** `agency-agents` + `rules/agency/*` — marketingskills bundle is the main complement candidate (bulk install later if approved).

---

## 5. Security / cyber

### Hub already has

| Asset | Path / route |
|-------|----------------|
| Anthropic Cybersecurity pack (754 skills) | `skills/cybersecurity/` + `library/` |
| Task route | `security-audit` → subagent `security-review` |
| Rules | `rules/cybersecurity.mdc`, `rules/ai-coding-security.mdc` |
| Scripts | `skills/cybersecurity/scripts/find-skill.mjs`, `ensure-library.mjs` |

### Candidates

| Hub pain | Candidate (owner/repo@skill) | Installs (approx) | Suggested `npx skills add ...` | Suggestion |
|----------|-------------------------------|-------------------|--------------------------------|------------|
| Firebase/Firestore rules audits | `firebase/agent-skills@firebase-security-rules-auditor` | **71K** | … | **Installed** → `skills/firebase-security-rules-auditor/` |
| Firestore variant | `firebase/agent-skills@firestore-security-rules-auditor` | **20K** | … | **Skip** — not in installed firebase package |
| Cloudflare edge audit | `cloudflare/security-audit-skill@security-audit` | **1.8K** | … | **Installed** → `skills/cloudflare-security-audit/` (upstream `security-audit`) |
| Secrets scan in CI | `jwynia/agent-skills@secrets-scan` | **267** | … | **Skip** — jwynia not present; **secret-scanning** installed instead |
| DevSecOps pipeline recipes | `martinholovsky/claude-skills-generator@devsecops-expert` | **312** | … | **Installed** → `skills/devsecops-expert/` |
| Generic security-auditor forks | `sickn33/antigravity-awesome-skills@security-auditor` | **993** | … | **Skip** — overlaps `cybersecurity` pack |

**Keep:** `skills/cybersecurity/` — do not replace; hub already ships the largest defensive library.

---

## Integration (Session 2 — done)

1. Installed upstream skills under `~/.agents/skills/` (design + other domains).
2. Thin hub wrappers under `skills/<hub-id>/SKILL.md` + `lib/task-router/routes.json` keywords.
3. Did **not** touch `hooks.json`, agent model lines, or `mcp.json` secrets.
4. Smoke (recommended): `commands/seo-stack-verify.ps1`, `commands/n8n-templates-test.ps1`, `commands/task-router-test.ps1`.
5. Taxonomy updated in `ai-tracking/skills-taxonomy-s2.md`.
