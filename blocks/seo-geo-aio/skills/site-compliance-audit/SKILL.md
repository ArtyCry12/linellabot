---
name: site-compliance-audit
description: Full website legal/docs/licenses gap scan (privacy vs processors, cookies, imprint, fonts/JS licenses, GDPR/Law 195, AI data flows). Use when building or re-checking a client site, legal pages, cookie banner, ПДн, imprint, license registry, юридический аудит сайта, compliance pour. Not a SEO ranking audit.
version: "1.0.0"
license: MIT
compatibility: cursor
metadata:
  author: hub
  version: "1.0.0"
when_to_use: client_site_legal_audit, privacy_cookies_imprint, license_fonts_js, pdn_llm
argument-hint: "[url | local path] [--profile md-eu|eu|us|generic]"
---

# Site compliance audit

Полная перепроверка сайта: документы, юриспруденция, лицензии, пробелы. Не юридическая консультация.

**Каждый запуск** — сначала живое чтение официальных источников из [references/sources.md](references/sources.md). Кэш и этот файл не закон.

## Read first

1. Этот файл (протокол)
2. [references/sources.md](references/sources.md) — URL, которые **обязательно** перечитать
3. [references/modules.md](references/modules.md) — чеклисты модулей
4. [references/handoff.md](references/handoff.md) — уроки чата NLMedia, обобщённые

Поддержка (если есть на диске, не блокируют запуск):

| Модуль | Скилл |
|--------|--------|
| Privacy vs код | `~/.agents/skills/gdpr-ccpa-privacy-auditor/SKILL.md` |
| npm/OSS | `~/.agents/skills/license-compliance-auditor/SKILL.md` |
| Классификация лицензий | `~/.agents/skills/oss-review/SKILL.md` (без Claude practice-profile / cold-start) |
| WCAG | `~/.agents/skills/wcag-accessibility-audit/SKILL.md` |
| GDPR принципы | `~/.agents/skills/gdpr-compliance/SKILL.md` |
| Черновики страниц | `~/.agents/skills/legal-page-generator/SKILL.md` · `privacy-page-generator` |

`maddhruv/absolute@privacy-compliance` в каталоге больше нет — не искать, использовать privacy-auditor.

## Inputs (собрать за 1 круг, не тормозить)

| Поле | Дефолт |
|------|--------|
| Цель | URL и/или локальный репо |
| Профиль | `md-eu` (Молдова + ЕС). Иначе `eu` / `us` / `generic` |
| Языки юртекстов | как на сайте |
| Категория | лендинг / SaaS / e-com / AI-чат / приложение |
| LLM на сайте | да/нет |
| Аналитика / пиксели | да/нет (не гадать — проверить код и сеть) |
| Хостинг / CDN / шрифты | по факту, не по README |

Нет IDNO / юрлица — не выдумывать. Пометить YELLOW и imprint = бренд + контакты + город, если так решил заказчик.

## Hard rules

- Не выдумывать кейсы, отзывы, рейтинг, AggregateRating.
- Не копировать юртексты конкурентов.
- Не лить `legal-preview` / заглушки как прод.
- Не ломать UI: юрряд / баннер / notice — **additive**.
- Не обещать «GDPR certified», «EU residency» для US LLM-шлюза.
- PAYG ≠ подписанный DPA.
- Essential-only cookie ≠ стена маркетингового согласия.
- Proprietary font без web-лицензии → RED, заменить на OFL/самохост.
- CDN шрифтов/JS = передача IP третьей стороне, даже без формы.
- Commit / push / deploy / заливка на прод — только после явного «да».
- Digital Omnibus / черновики законов = WATCH, не как действующее право.

## Flow (каждый запуск)

```
0 Disclaimer
1 Live refresh  → sources.md URLs (Exa/fetch). Зафиксировать дату проверки.
2 Scope         → юрисдикции, категория, AI, коммерция, языки
3 Fact gather   → HTML/репо + live (cookies, scripts, network) если URL
4 Modules A–J   → evidence, severity
5 Gap log       → RED / YELLOW / GREEN
6 Pour          → только если попросили; UI-safe
```

### 0. Disclaimer (коротко в отчёте)

Технический аудит, не заключение юриста. RED — к counsel до прода.

### 1. Live refresh (обязателен, даже если промпт «просто глянь»)

Прочитать актуальные страницы из sources.md (не все байты — заголовки, дата, in-force, изменения). Записать:

- сегодняшняя дата
- какой акт ПДн в силе для MD (133/2011 до **2026-08-23**; 195/2024 с этой даты — **перепроверить на datepersonale.md**)
- ePrivacy / cookies: Directive 2002/58 Art. 5(3) + EDPB Guidelines 2/2023
- EAA 2019/882: в скоупе только если e-commerce к потребителям ЕС (микропредприятия — исключение; не раздувать)

Если источник недоступен — UNVERIFIED, не подставлять память модели как закон.

MCP: `plugin-exa-exa` (поиск/fetch). Один URL — `user-fetch`. Live cookies/scripts — браузер, если цель публичная и заказчик свой/клиентский сайт.

### 2. Scope

Пропустить чужое право. Ложный GDPR-штраф на чисто MD B2B без ЕС-субъектов — вред. Если посетители из ЕС возможны — второй контур GDPR.

### 3. Fact gather

Минимум: `index`/layout, footer, legal URLs, `robots.txt`, JSON-LD, `package.json`/`vendor`/`assets/fonts`, любые `localStorage`/`document.cookie`, внешние origin (Google Fonts, esm.sh, CDN, analytics, LLM).

Сверить **текст Privacy** с **фактическими** процессорами.

## Output

Один gap-log (таблица). Без воды.

| ID | Модуль | Severity | Находка | Evidence (файл/URL) | Что сделать |
|----|--------|----------|---------|---------------------|-------------|

Severity: **RED** блокер прода / вводящее / нелицензионный ассет / ПДн в LLM без основания. **YELLOW** дыра или рассинхрон, не сразу штраф. **GREEN** закрыто. **WATCH** черновик закона. **UNVERIFIED** не смогли проверить.

В конце: 3–7 приоритетов. Pour — отдельным шагом, не по умолчанию.

## Profiles

| id | Когда |
|----|--------|
| `md-eu` | Клиенты агентства MD, второй рынок ЕС (дефолт) |
| `eu` | Оператор/аудитория ЕС, без MD-специфики |
| `us` | US/CCPA overlay + федеральная реклама; GDPR если есть ЕС-субъекты |
| `generic` | Другой проект: сначала определить юрисдикцию, затем модули A–J |
