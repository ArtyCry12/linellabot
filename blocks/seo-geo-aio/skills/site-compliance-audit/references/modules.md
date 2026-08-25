# Audit modules A–J

Каждый пункт: evidence или `UNVERIFIED`. Не отмечать GREEN без факта.

## A. Identity / imprint

- Кто оператор: бренд vs юрлицо, IDNO, адрес, email для прав субъекта, телефон.
- Footer / `/imprint` / «Identificare» не пустой и не противоречит Privacy.
- Нет юрлица → не выдумывать SRL; YELLOW + напоминание, не блокировать бренд-only если заказчик так решил.
- Телефон в UI в международном формате, если так принято на рынке (MD: `+373`, не локальный `079` в публичном UI).
- Домен / canonical / email — нет плейсхолдеров `[DOMAIN]` на проде.

## B. Legal pages vs live processors

Нужны (под категорию продукта): Privacy, Cookies, Terms (сайт ≠ договор — не раздувать SLA), Imprint.

- Ссылки в footer работают, `index,follow` или осознанный `noindex`.
- Языки: юрстраницы на языках сайта; hreflang + x-default согласованы с юр. якорем (для MD часто `ro`).
- Privacy перечисляет **фактических** получателей: хостинг, CDN, шрифты, мессенджеры, LLM, аналитика.
- Рассинхрон «в политике нет Google Fonts, в HTML есть fonts.googleapis.com» = RED/YELLOW.
- Не обещать бесплатную поддержку / сроки / «GDPR certified».

Черновики страниц: legal-page-generator / privacy-page-generator. Не копировать чужие политики.

## C. Cookies / storage / ePrivacy

- Инвентарь: cookie, localStorage, sessionStorage, pixels.
- Essential-only (сессия, cookie-ack, security) → короткий notice, не CMP-стена.
- Analytics / ads / extra tracking → согласие **до** загрузки скрипта (EDPB 2/2023: доступ к устройству шире, чем «cookie»).
- Reject не менее доступен, чем Accept. Pre-ticked = invalid.
- Баннер не перекрывает критичный UI (z-index), не ломает CTA.

Сверка с privacy-auditor: политика vs фактические скрипты.

## D. PDn inventory + transfers

Карта: источник → категория → цель → основание → срок → получатель → трансфер.

Типовые дыры агентских лендингов:

- Google Fonts / jsDelivr / esm.sh / CDN = IP к третьей стороне.
- Мессенджеры (WA/Viber/TG) = передача при клике; описать.
- LLM gateway (OpenRouter и аналоги): регион, ZDR, логи, training, subprocessors.
- Хостинг не в юрисдикции оператора (Vercel US vs EU region).
- Формы / Ask AI: имя, телефон, ниша, бюджет = сбор ПДн.

Минимизация: каталожный explainer без ПДн в модели = можно v1 без Enterprise DPA; тогда **запрет** слать имя/телефон в промпт + редact на воркере. Иначе DPA + основание + срок логов.

RoPA внутренний (195/2024 art. 30 analogue) — не путать с регистрацией оператора в CNPDCP.

## E. Licenses (fonts, JS, npm, UI kits)

- Реестр: файл → SPDX/vendor license → can ship? → NOTICE нужен?
- Шрифты: web license. Proprietary (TT Norms и аналоги) без лицензии → RED, OFL self-host.
- Self-host: полный набор весов **и** нужных письменных систем. Incomplete OFL (нет кириллицы, когда UI на RU) ломает UI — это баг заливки, не «мелочь».
- GSAP: Standard License, self-host `vendor/`; не тащить с CDN если политика «нет лишних трансферов».
- 21st.dev / shadcn / registry: прочитать LICENSE компонента, не полагаться на «все MIT».
- npm: license-compliance-auditor + oss-review buckets. Unknown ≠ permissive. AGPL/SSPL/BUSL — стоп до review.
- NOTICE / license-notices на сайте или в репо, если лицензия требует attribution.

## F. Marketing claims

MD: Law 62/2022 (реклама), Law 105/2003 (недобросовестные практики). ЕС: UCPD 2005/29.

Ловить:

- Абсолюты «ни у одной компании», «единственные», недоказуемые сравнения.
- Фейковый social proof, звёзды, AggregateRating без отзывов.
- SLA на публичной странице как гарантия («ответ ≤1 ч») без оговорки.
- Цены «от», которых нет в оффере.
- Копирование текстов/цен конкурента.

Сравнительная реклама допустима, если проверяемые факты, не дискредитация.

## G. AI on the site

- UI: «это ИИ, не сотрудник / не юрконсультация».
- Что уходит в модель (промпт, логи, провайдер, регион).
- Нет training на чатах, если так заявлено — проверить настройки вендора, не слоган.
- Квалификация лида → человек (телефон/TG), не договор через бота.
- EU AI Act: для простого explainer/FAQ обычно не high-risk; не раздувать. Если автоматизированные решения с правовым эффектом — эскалировать.

## H. Accessibility

- Всегда: семантика, один H1, контраст, клавиатура, alt — как качество.
- Юробязанность EAA: только e-commerce к потребителям ЕС после 28.06.2025, не микросервис-исключение. Иначе не писать «нарушение EAA».
- Детальный WCAG: скилл `wcag-accessibility-audit`.

## I. SEO / bots (legal slice)

- Не SEO-аудит (это `seo-geo`). Здесь: ложный JSON-LD отзывов; скрытый текст; robots — AI-боты по политике заказчика; legal pages indexable если это публичные политики.

## J. Pour-safe (если просят залить)

- Не трогать hero / motion / globe / aurora, если не чинят конкретный юрбаг.
- Юрссылки — отдельный ряд в footer.
- Шрифты: не подключать Google `@import` взамен self-host.
- Бандл esm (esm.sh → local) если политика no-CDN.
- ЮрHTML из утверждённых MD, не из stub preview.
- После заливки — визуально не «поехал» layout.

## Severity cheat

| RED | Нелицензионный ассет на проде; ПДн в LLM без notice/основания; трекеры до согласия; вводящая абсолютная реклама; пустой оператор на потребительском оффере |
| YELLOW | Нет IDNO; политика отстаёт от кода; CDN IP; нет DPA при реальном процессоре; неполный OFL |
| GREEN | Совпадает политика, код, NOTICE, notice в UI |
