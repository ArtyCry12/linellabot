# Handoff — lessons from NLMedia legal pour (generalized)

Источник: чат agency-site-prod (юридический пакет + заливка на скелет). Это **паттерны для любого клиентского сайта**, не чеклист «скопируй NLMedia».

Не юридическая консультация.

## What the chat actually produced

Пять фаз текста → заливка на живой HTML без смены визуала:

1. ПДн-инвентарь, карта обработок, Ask AI requirements, Law 195 readiness, риски
2. Privacy / Cookies / Terms / Imprint (RO+RU+EN)
3. Лицензии: реестр, 21st, шрифты, risk matrix, NOTICE
4. Оператор, трансферы CDN/LLM/hosting, gap-log
5. MASTER-BRIEF + implementation pack

Заливка: OFL self-host, GSAP vendor, бандлы вместо esm.sh, 15 юрстраниц, footer-ряд, cookie notice, Ask AI one-liner. Не деплой.

## Aspects to encode in the skill

### Jurisdiction is a parameter

NLMedia: MD first, EU second contour, `/ro/` = locale not «рынок Румыния».  
Для другого клиента: спросить оператор / аудитория / языки. Не натягивать CNPDCP на калифорнийский SaaS.

### Law dates move

В чате: 133/2011 → 195/2024 с **23.08.2026**. К 14.08.2026 133 ещё в силе. Поэтому **каждый прогон** читает CNPDCP, а не этот абзац.

### Operator identification

Можно жить на бренде + город + tel/TG + email, если юрлица нет. Не выдумывать IDNO. На проде не оставлять `[DOMAIN]` / `[COMPANY]`.

### Single CTA / contact policy (agency sites)

Юрблоки не плодят новые CTA. Телефон международный в UI. Мессенджеры = тот же номер, если так у клиента.

### Cookies v1

Нет GA4/Meta → essential notice, не Consent Mode theatre. Когда появятся пиксели — баннер и политика должны измениться **вместе** со скриптами.

### Ask AI / LLM

Рабочая схема v1: в модель не класть имя/телефон/почту/бюджет; каталог+FAQ; квалификация на tel/TG; ZDR; no training; короткий лог; redact на воркере.  
OpenRouter PAYG ≠ Enterprise DPA. Не блокировать explainer-only чат требованием EU endpoint, если ПДн в модель не идут. Если идут — DPA обязателен.

Не писать «наш ИИ в ЕС / GDPR certified» про US gateway.

### CDN = processing

Google Fonts, jsDelivr, esm.sh, motion `@import` — это трансфер IP. Лечится self-host + бандл, не абзацем в политике «мы ничего не передаём».

### Fonts break UI if incomplete

Скачать «какой-то OFL» недостаточно: веса как в макете + письменность (кириллица). Семья без кириллицы на Google/Fontsource (часто DM Sans, Sora) → fallback, не «закрыли лицензию». Proprietary (TT Norms) не в прод без лицензии.

### GSAP

После смены лицензии Webflow: commercial OK, self-host, не конкурент Webflow visual builder. Перечитывать gsap.com/standard-license.

### 21st / registry UI

Каждый компонент — свой LICENSE. Не считать «раз в 21st, значит MIT».

### Pour without redesign

Юрряд additive. Не подключать cinematic footer на legal pages. Не мигрировать на Next.js «чтобы починить compliance». Preview-папка с `noindex` не линкуется в прод.

### Claims

Абсолютные сравнения («ни у одной локальной компании») — высокий риск 62/2022 + 105/2003. Фейковый рейтинг — запрещён правилами агентства и законом о вводящей рекламе.

### Hosting

Регион (например Vercel `fra1`) — рекомендация, не факт, пока не задеплоено. Политика должна совпадать с фактом.

### What not to automate as «fix»

- Выдать IDNO
- Подписать DPA за клиента
- Поставить цены
- Скопировать политику Claro/конкурента
- Включить аналитику «для галочки»
- Counsel: желателен, не soft-block для текстового скелета; для потребительского e-com с оплатой — другое

## Default agency profile (`md-eu`)

Использовать, когда клиент — MD SMB / CIS + возможны ЕС-посетители:

- Языки юртекстов как у сайта (часто RO+RU+EN, якорь RO)
- ПДн: 133 или 195 по **сегодняшней** дате + GDPR как второй контур
- Реклама: 62/2022, потребитель: 105/2003
- Лицензии и CDN — всегда, независимо от юрисдикции

## Files from that project (examples, not templates to copy blindly)

В репо клиента после похожей работы обычно:

`docs/legal/` (privacy, cookies, terms, imprint, pdn-*, license-*, transfers)  
`docs/compliance/` (MASTER-BRIEF, IMPLEMENTATION-PACK, REMINDERS, gap log)

Автоматизация **проверяет** такое дерево или его отсутствие; не требует NLMedia-имён секций.
