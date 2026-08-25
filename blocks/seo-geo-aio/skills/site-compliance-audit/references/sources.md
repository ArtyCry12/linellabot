# Official sources — re-fetch every run

Не считать этот список «состоянием права». Это **стартовые URL**. Каждый запуск: открыть, проверить дату/in-force, если страница сменилась — идти по ссылкам регулятора.

Зафиксировать в отчёте: `checked_at` (ISO date) + какие URL ответили.

## Moldova — personal data

| What | URL |
|------|-----|
| CNPDCP national legislation | https://datepersonale.md/en/legislation/national-legislation/law/ |
| Same, RO | https://datepersonale.md/legislation/national-legislation/legi/ |
| Law 195/2024 EN PDF (CNPDCP) | https://datepersonale.md/wp-content/uploads/2024/09/Law-no.-195-2024-on-personal-data-protection-1.pdf |
| Law 195/2024 RO PDF | https://datepersonale.md/wp-content/uploads/2026/03/Legea-nr.1952024.pdf |
| CNPDCP Law 195 explainer | https://datepersonale.md/legea-nr-195-2024-privind-protectia-datelor-cu-caracter-personal-principalele-prevederi-si-noutati-legislative/ |
| CNPDCP guidelines 195 | https://datepersonale.md/en/guidelines-explanations-for-the-proper-application-of-law-no-195-2024-on-personal-data-protection/ |
| Justice.gov.md file | https://www.justice.gov.md/en/file/181487 |
| Monitorul Oficial 367-369/2024 | https://monitorul.gov.md/ro/monitor/2950 |

**Date gate (verify, do not hardcode forever):** Law 195/2024 published 23.08.2024, in force **24 months later → 23.08.2026**. Until that date Law 133/2011 still applies; after — 195/2024 (GDPR transpose). Law 36/2026 (Convention 108+ protocol) also tied to 23.08.2026 — confirm on CNPDCP list.

CNPDCP operator *notification* was dropped earlier (Law 175/2021 era); 195/2024 stresses internal RoPA (art. 30 analogue). Re-read CNPDCP, do not restore “must register as operator” without a current source.

## EU — GDPR / cookies / ePrivacy

| What | URL |
|------|-----|
| GDPR 2016/679 | https://eur-lex.europa.eu/eli/reg/2016/679/oj |
| ePrivacy Directive 2002/58 (consolidated) | https://eur-lex.europa.eu/eli/dir/2002/58 |
| EDPB topic ePrivacy | https://www.edpb.europa.eu/our-work-tools/our-documents/topic/e-privacy_en |
| EDPB Guidelines 2/2023 Art. 5(3) technical scope | https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-22023-technical-scope-art-53-eprivacy-directive_en |
| EDPB Guidelines 05/2020 consent | https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/guidelines-052020-consent-under-regulation-2016679_en |

**WATCH only (proposal, not law):** EDPB-EDPS Joint opinion 2/2026 on Digital Omnibus — https://www.edpb.europa.eu/documents/legislative-opinion/edpb-edps-joint-opinion-22026-on-the-proposal-for-a-regulation-as_en

## EU — accessibility (conditional)

| What | URL |
|------|-----|
| EAA Directive 2019/882 | https://eur-lex.europa.eu/eli/dir/2019/882 |
| EUR-Lex summary | https://eur-lex.europa.eu/EN/legal-content/summary/accessibility-of-products-and-services.html |
| Your Europe (business) | https://europa.eu/youreurope/business/selling-in-eu/selling-goods-services/accessibility/index_en.htm |

Applies to **e-commerce services to consumers** after 28.06.2025; microenterprises providing *services* exempt. B2B agency landing without consumer checkout → usually out of EAA; still run WCAG as quality, not as fake legal duty.

## Moldova — advertising / consumer

| What | URL |
|------|-----|
| Law 62/2022 advertising (AGEPI pointer) | https://agepi.gov.md/en/content/legea-republicii-moldova-nr-62-din-17032022-cu-privire-la-publicitate |
| ECC.md comparative/misleading ads | https://www.ecc.md/en/ro-publicitatea-n-el-toare-i-comparativ-riscuri-pentru-consumatori-i-c-i-de-protec-ie-a-drepturilor-acestora/ |
| ECC.md national legislation index | https://www.ecc.md/en/legislatie-nationala/ |
| Law 105/2003 consumer protection (EN PDF, ECC ecosystem) | https://ecommerce4all.md/wp-content/uploads/sites/8/2022/08/eng_law-on-consumer-protection_moldova.pdf |

Prefer legis.md / official gazette text if the PDF mirror looks stale.

## Licenses / fonts / animation (re-read vendor pages)

| What | URL |
|------|-----|
| SPDX License List | https://spdx.org/licenses/ |
| SIL Open Font License 1.1 | https://openfontlicense.org/ |
| GSAP Standard License (Webflow, no-charge) | https://gsap.com/community/standard-license/ |
| GSAP GitHub | https://github.com/greensock/gsap |

GSAP: commercial web use is permitted under current Standard License; prohibited use = competing visual animation builders. AI-generated GSAP code is allowed per their FAQ. Re-read if Webflow changes terms.

## How to refresh (agent)

1. Exa/fetch the CNPDCP legislation index + EUR-Lex GDPR + ePrivacy topic page (3 calls cover most drift).
2. If the site has fonts/GSAP/npm — fetch SPDX + the specific vendor license page.
3. If e-commerce to EU consumers — fetch EAA summary.
4. Quote dates from the page, not from this file.
