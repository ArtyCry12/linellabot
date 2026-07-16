import {
  Button,
  Callout,
  Card,
  CardBody,
  CardHeader,
  CollapsibleSection,
  Divider,
  Grid,
  H1,
  H2,
  H3,
  Pill,
  Row,
  Select,
  Stack,
  Stat,
  Swatch,
  Table,
  Text,
  TodoList,
  UsageBar,
  useCanvasState,
  useHostTheme,
} from "cursor/canvas";

type RowTone = "success" | "danger" | "warning" | "info" | "neutral";

const CANVAS_VERSION = "v4.1 · 16.07.2026 P3";

const DESIGN_REFS = [
  { url: "https://www.apple.com/", role: "Золотой стандарт", note: "Эталон чистоты, иерархии, brand-first" },
  { url: "https://antigravity.google/", role: "Wow / современный фаворит", note: "Когда нужен сильный wow-эффект" },
  { url: "https://framery.com/en/", role: "Продающий почти идеал", note: "Landing CRO + продукт в кадре" },
  { url: "https://www.palantir.com/platforms/aip/", role: "Красота + эффективность", note: "B2B platform: эстетика без потери ясности" },
];

function dataTable(
  headers: string[],
  cells: string[][],
  tones?: (RowTone | undefined)[],
) {
  return { headers, rows: cells, rowTone: tones, striped: true as const };
}

type SectionId =
  | "overview"
  | "models"
  | "squad"
  | "logic"
  | "markitdown"
  | "mistakes"
  | "honest"
  | "q7"
  | "cleanup"
  | "why-broken"
  | "memory"
  | "about-you"
  | "partner"
  | "skills-mcp"
  | "auto-route"
  | "squad-howto";

const SECTIONS: { id: SectionId; label: string }[] = [
  { id: "overview", label: "Обзор системы" },
  { id: "models", label: "1. Модели LLM" },
  { id: "squad", label: "2. Субагенты" },
  { id: "logic", label: "3. Логика Squad" },
  { id: "markitdown", label: "4. MarkItDown + токены" },
  { id: "mistakes", label: "5. Ошибки в промптах" },
  { id: "honest", label: "6. Честный разбор" },
  { id: "q7", label: "7. Plan + Auto + Squad" },
  { id: "cleanup", label: "8. Что почистить" },
  { id: "why-broken", label: "9. Почему не работает" },
  { id: "memory", label: "10. Память и вопросы" },
  { id: "about-you", label: "11. Что я знаю о тебе" },
  { id: "partner", label: "12. Поддакивание" },
  { id: "skills-mcp", label: "13. Скиллы не видны" },
  { id: "auto-route", label: "14. Автоподбор" },
  { id: "squad-howto", label: "15. Как запустить Squad" },
];

const MODELS = [
  {
    slug: "claude-opus-4-7",
    name: "Opus 4.7 / 4.8",
    tier: "High",
    strength: "Сложная инженерия, многофайловые рефакторинги, самопроверка, длинные сессии",
    weak: "Дорого; для рутины — переплата",
    devVoice: "StackSpend, DataCamp, Railwail (июль 2026): лидер SWE-bench Pro (~64%), CursorBench ~70%. Лучший Boss и architect.",
    squadFit: "Boss (родительский чат), architect (сложные планы)",
  },
  {
    slug: "claude-sonnet-5",
    name: "Sonnet 5 / 4.6",
    tier: "Medium",
    strength: "90% coding-задач за ~40% цены Opus. Баланс скорость/качество",
    weak: "На самых жёстких багах слабее Opus",
    devVoice: "Pulse Mark, Anthropic guidance: default для production-кода. The New Stack — основной workhorse.",
    squadFit: "architect, design, qa, ship, growth (по model-map)",
  },
  {
    slug: "composer-2.5-fast",
    name: "Composer 2.5 Fast",
    tier: "Low",
    strength: "Scout/explore: дешёвый frontier (~$0.44/задача vs $4+ у Opus). SWE-Bench Multilingual ~80%",
    weak: "Terminal-Bench слабее GPT-5.5; не для финального кода",
    devVoice: "Artificial Analysis (май 2026): 3-е место Coding Agent Index, 10–60× дешевле Opus/GPT-5.5.",
    squadFit: "scout, cleanup, Explore Subagent Model",
  },
  {
    slug: "gpt-5.3-codex",
    name: "Codex 5.3",
    tier: "High",
    strength: "Пишет код, TypeScript/React, tool-heavy terminal workflows",
    weak: "Меньше «архитектурного» мышления чем Opus",
    devVoice: "Lushbinary: Terminal-Bench лидер у GPT-5.5; Codex-линейка — для implementation loops.",
    squadFit: "build (по model-map)",
  },
  {
    slug: "gpt-5.4",
    name: "GPT-5.4 / 5.5 / 5.6",
    tier: "Medium–High",
    strength: "Code review, agentic web, terminal automation, строгая логика",
    weak: "SWE-bench Pro ниже Opus на ~6 п.п.; дороже Composer",
    devVoice: "DataCamp: Terminal-Bench 75% vs Opus 69%. Railwail: слабее на multi-file без открытия файлов.",
    squadFit: "review, shell-heavy задачи",
  },
  {
    slug: "gemini-3.1-pro",
    name: "Gemini 3.1 Pro",
    tier: "Medium",
    strength: "Длинный контекст (2M), мультимодал, дешевле frontier",
    weak: "Agentic coding ниже Opus; в Cursor — не всегда стабилен",
    devVoice: "Pulse Mark: budget long-context pick. Хорош для research summaries.",
    squadFit: "growth research, НЕ memory (слишком дорого)",
  },
  {
    slug: "claude-haiku-4-5",
    name: "Haiku 4.5",
    tier: "Low",
    strength: "Дёшево, быстро: память, классификация, короткие summary",
    weak: "Не для кода и дизайна",
    devVoice: "Anthropic: routing tier для high-volume low-complexity.",
    squadFit: "memory (canonical в model-map)",
  },
  {
    slug: "glm-5.2",
    name: "GLM 5.2",
    tier: "Medium",
    strength: "Reasoning, китайский контекст, дешевле западных frontier",
    weak: "Design/creative слабее Sonnet+skills; мало dev-отзывов в Cursor",
    devVoice: "StackSpend: execute-tier модель. Сейчас на squad-design — спорный выбор.",
    squadFit: "Цена/качество: черновики, ops; слабые зоны — huashu + Sonnet gate",
  },
  {
    slug: "kimi-k2.7-code",
    name: "Kimi K2.7 Code",
    tier: "Medium",
    strength: "Сильный код за меньшую цену; backup build/scout",
    weak: "Design/marketing слабее; нужен review от GPT/Sonnet",
    devVoice: "PrimeAIcenter: Kimi K2.5 lineage. Ты подтвердил: держать для оптимизации spend.",
    squadFit: "Backup build/scout; прикрывать squad-review",
  },
  {
    slug: "claude-fable-5",
    name: "Fable 5",
    tier: "High",
    strength: "Топ SWE-bench (StackSpend июль 2026), hardest tickets",
    weak: "Очень дорого; редко нужен ежедневно",
    devVoice: "StackSpend: best overall coding quality после export-control pause.",
    squadFit: "1–5% задач: критический refactor, не Boss по умолчанию",
  },
  {
    slug: "gpt-5-mini",
    name: "GPT-5 Mini / Nano",
    tier: "Low",
    strength: "Микро-задачи, черновики, классификация",
    weak: "Качество падает на сложном коде",
    devVoice: "StackSpend: execute tier alongside Haiku.",
    squadFit: "Не включать в Squad; router fallback",
  },
];

/** Оптимизированный список ON в Settings → Models (по ответам Артёма, июль 2026) */
const ENABLED_MODELS_ROSTER = [
  { on: true, name: "Opus 4.8", slug: "claude-opus-4-8", ctx: "200K", ctxLong: "1M beta — только architect/plan", effort: "xhigh", thinking: "on", when: "Boss: план, тяжёлые задачи, Phase 0", tier: "High" },
  { on: true, name: "Sonnet 5", slug: "claude-sonnet-5", ctx: "200K", ctxLong: "1M — architect при большом репо", effort: "medium", thinking: "on", when: "Основная работа: design, qa, ship, growth, hub", tier: "Medium" },
  { on: true, name: "Sonnet 4.6", slug: "claude-sonnet-4-6", ctx: "200K", ctxLong: "—", effort: "medium", thinking: "off", when: "QA, ship, стабильный fallback Sonnet", tier: "Medium" },
  { on: true, name: "Composer 2.5", slug: "composer-2.5-fast", ctx: "128K", ctxLong: "—", effort: "low", thinking: "off", when: "scout, cleanup, explore, разведка репо", tier: "Low" },
  { on: true, name: "Codex 5.3", slug: "gpt-5.3-codex-high-fast", ctx: "128K", ctxLong: "—", effort: "high", thinking: "off", when: "squad-build, клиентский код TS/React", tier: "High" },
  { on: true, name: "GPT-5.5", slug: "gpt-5.5-medium", ctx: "128K", ctxLong: "—", effort: "medium", thinking: "off", when: "squad-review, PR, shell-heavy", tier: "Medium" },
  { on: true, name: "Haiku 4.5", slug: "claude-haiku-4-5-thinking", ctx: "200K", ctxLong: "—", effort: "low", thinking: "on", when: "squad-memory, классификация, summary", tier: "Low" },
  { on: true, name: "Gemini 3.1 Pro", slug: "gemini-3.1-pro", ctx: "2M", ctxLong: "длинный research", effort: "low", thinking: "off", when: "Web research, длинные доки, growth intel", tier: "Medium" },
  { on: true, name: "GLM 5.2", slug: "glm-5.2", ctx: "128K", ctxLong: "—", effort: "medium", thinking: "on", when: "Цена/качество: черновики, reasoning; прикрывать Sonnet+skills", tier: "Medium" },
  { on: true, name: "Kimi K2.7 Code", slug: "kimi-k2.7-code", ctx: "128K", ctxLong: "—", effort: "medium", thinking: "off", when: "Цена/качество код; backup build/scout", tier: "Medium" },
  { on: false, name: "Fable 5", slug: "claude-fable-5", ctx: "200K", ctxLong: "—", effort: "xhigh", thinking: "on", when: "OFF — не используешь", tier: "High" },
  { on: false, name: "GPT-5.4 / 5.6 Sol/Terra/Luna", slug: "gpt-5.6-*", ctx: "128K", ctxLong: "—", effort: "—", thinking: "off", when: "OFF — дубли Codex+5.5", tier: "—" },
  { on: false, name: "Gemini Flash / 3.5 Flash", slug: "gemini-flash", ctx: "1M", ctxLong: "—", effort: "low", thinking: "off", when: "OFF — только Pro", tier: "—" },
  { on: false, name: "Opus/Sonnet 4.x старые", slug: "legacy-claude", ctx: "—", ctxLong: "—", effort: "—", thinking: "—", when: "OFF — шум в Auto", tier: "—" },
  { on: false, name: "GPT Mini/Nano, Codex Mini", slug: "gpt-mini", ctx: "32K", ctxLong: "—", effort: "low", thinking: "off", when: "OFF — Haiku/Composer дешевле и стабильнее", tier: "Low" },
];

const BOSS_MODEL_RULES = [
  { situation: "Крупный план, архитектура, 5+ файлов", model: "Opus 4.8 thinking xhigh", auto: "Auto может взять Sonnet — лучше вручную Opus" },
  { situation: "Обычный чат: клиент, hub, правки", model: "Sonnet 5 thinking medium ИЛИ Auto", auto: "Auto OK если ON только 10 моделей из таблицы" },
  { situation: "Быстрый вопрос без правок", model: "Ask mode + Sonnet 5 или Haiku", auto: "—" },
  { situation: "Дебаг / CI", model: "Sonnet 5 или Auto → spawn scout на Composer", auto: "Не Opus — дорого на grep" },
  { situation: "Только оркестрация Squad", model: "Opus 4.8 (ты = Boss, отдельного squad-boss нет)", auto: "Spawn делает работу; Boss не пишет код" },
];

const SQUAD = [
  {
    id: "boss",
    role: "Boss (ты + родительский чат)",
    task: "Phase 0, оркестрация, spawn субагентов, gates commit/deploy",
    current: "Opus 4.7 (ручной выбор)",
    recommended: "Opus 4.7 thinking xhigh",
    modelOk: true,
    skills: "project-squad, auto-orchestrator",
  },
  {
    id: "scout",
    role: "Scout",
    task: "Аудит репо, риски, junk, inventory — только чтение",
    current: "composer-2.5",
    recommended: "composer-2.5-fast",
    modelOk: true,
    skills: "graphify, markitdown, gitnexus",
  },
  {
    id: "architect",
    role: "Architect",
    task: "План модулей, API, порядок задач — без массового кода",
    current: "claude-sonnet-5 thinking",
    recommended: "claude-sonnet-5 medium-thinking или Opus 4.7",
    modelOk: false,
    skills: "gitnexus impact, product-manager",
  },
  {
    id: "design",
    role: "Design",
    task: "UI/UX, motion, huashu, 21st, figma, agency personas",
    current: "glm-5.2 reasoning max",
    recommended: "claude-sonnet-5 medium-thinking",
    modelOk: false,
    skills: "huashu-design, ui-ux-pro-max, 21st-design",
  },
  {
    id: "build",
    role: "Build",
    task: "Implementation TS/React/Next, minimal diffs",
    current: "claude-sonnet-5 thinking high",
    recommended: "gpt-5.3-codex-high-fast",
    modelOk: false,
    skills: "mattpocock, nextjs, shadcn",
  },
  {
    id: "qa",
    role: "QA",
    task: "lint, typecheck, build, Playwright, browser smoke",
    current: "claude-sonnet-4-6",
    recommended: "claude-sonnet-4-6",
    modelOk: true,
    skills: "playwright, cursor-ide-browser",
  },
  {
    id: "review",
    role: "Review",
    task: "Code quality, security, maintainability на diff",
    current: "gpt-5.4",
    recommended: "gpt-5.5-medium или gpt-5.4",
    modelOk: true,
    skills: "thermo-nuclear-review, bugbot",
  },
  {
    id: "growth",
    role: "Growth",
    task: "SEO/GEO, CWV, meta, agency marketing personas",
    current: "gemini-3.1-pro",
    recommended: "claude-sonnet-5 medium-thinking",
    modelOk: false,
    skills: "seo-geo, humanizer, agency-agents",
  },
  {
    id: "ship",
    role: "Ship",
    task: "Vercel deploy, env, CI — только с твоим OK",
    current: "claude-sonnet-4-6",
    recommended: "claude-sonnet-4-6",
    modelOk: true,
    skills: "deployment-expert, vercel MCP",
  },
  {
    id: "memory",
    role: "Memory",
    task: "Facts → user-memory, AGENTS.md, ai-tracking",
    current: "gemini-3.1-pro",
    recommended: "claude-haiku-4-5-thinking",
    modelOk: false,
    skills: "user-memory MCP, squad-memory skill",
  },
  {
    id: "cleanup",
    role: "Cleanup",
    task: "Cache, hub refresh, safe deletes",
    current: "composer-2.5",
    recommended: "composer-2.5-fast",
    modelOk: true,
    skills: "cursor-system-refresh, hub-safe-cleanup",
  },
];

const SATISFACTION = [
  { label: "Router", value: 2, max: 5 },
  { label: "Coach", value: 2, max: 5 },
  { label: "Notion", value: 2, max: 5 },
  { label: "MCP", value: 3, max: 5 },
  { label: "Skills", value: 4, max: 5 },
  { label: "Squad", value: 3, max: 5 },
];

const ACTION_ITEMS = [
  { id: "models-trim", content: "Settings: 8–10 моделей ON (Boss сделал)", status: "completed" as const },
  { id: "explore", content: "Explore Subagent → Composer 2.5 (Boss сделал)", status: "completed" as const },
  { id: "design-gate", content: "Design gate: frontend-design + matrix (design-stack / squad-design) до build", status: "completed" as const },
  { id: "route-ui", content: "Route echo «Подключил: …» в rules/task-router.mdc", status: "completed" as const },
  { id: "ask-full", content: "AskQuestion полным списком — rules/user-profile.mdc", status: "completed" as const },
  { id: "cleanup", content: "hub-safe-cleanup Apply (markitdown sacred)", status: "completed" as const },
  { id: "s1-s3", content: "S1–S3 hub refactor COMPLETE (find-skills → installs → deep-dive)", status: "completed" as const },
  { id: "s4", content: "S4: canvas v4 + markers + _INDEX dedupe + gate-smoke", status: "completed" as const },
  { id: "sync-models", content: "НЕ синхронизировать agents/*.md model lines (trust_manual lock)", status: "cancelled" as const },
  { id: "reload", content: "Reload Window — только если правили hooks.json (S3 не трогал)", status: "cancelled" as const },
  { id: "deferred", content: "Boss: закрыть Cursor → cursor-system-refresh-deferred.ps1", status: "pending" as const },
  { id: "design-refs", content: "Design refs: Apple · Antigravity · Framery · Palantir AIP", status: "completed" as const },
  { id: "notion-p3", content: "Notion: publish under Prompt Coach hub (CoachConfig)", status: "completed" as const },
  { id: "models-boss", content: "Models: Boss настроил в Settings — model-map unlock закрыт", status: "completed" as const },
  { id: "budget", content: "P3: budget $/mo — пока нет точной цифры", status: "pending" as const },
];

const SQUAD_MODELS = [
  { role: "Boss", slug: "claude-opus-4-8-thinking-xhigh", ctx: "200K (1M beta)", effort: "xhigh", thinking: "on", file: "— (родительский чат)" },
  { role: "Scout", slug: "composer-2.5-fast", ctx: "128K", effort: "low", thinking: "off", file: "squad-scout.md" },
  { role: "Architect", slug: "claude-sonnet-5[thinking,ctx=1m,effort=medium]", ctx: "1M", effort: "medium", thinking: "on", file: "squad-architect.md" },
  { role: "Design", slug: "claude-sonnet-5[thinking,effort=medium]", ctx: "200K", effort: "medium", thinking: "on", file: "squad-design.md" },
  { role: "Build", slug: "gpt-5.3-codex-high-fast", ctx: "128K", effort: "high", thinking: "off", file: "squad-build.md" },
  { role: "QA", slug: "claude-sonnet-4-6", ctx: "200K", effort: "medium", thinking: "off", file: "squad-qa.md" },
  { role: "Review", slug: "gpt-5.5-medium", ctx: "128K", effort: "medium", thinking: "off", file: "squad-review.md" },
  { role: "Growth", slug: "claude-sonnet-5[thinking,effort=medium]", ctx: "200K", effort: "medium", thinking: "on", file: "squad-growth.md" },
  { role: "Ship", slug: "claude-sonnet-4-6", ctx: "200K", effort: "medium", thinking: "off", file: "squad-ship.md" },
  { role: "Memory", slug: "claude-haiku-4-5-thinking", ctx: "200K", effort: "low", thinking: "on", file: "squad-memory.md" },
  { role: "Cleanup", slug: "composer-2.5-fast", ctx: "128K", effort: "low", thinking: "off", file: "squad-cleanup.md" },
];

const TEAM_ANALOGS = [
  { name: "obra/superpowers", stars: "254K", source: "github.com/obra/superpowers", roles: "14 skills, без фикс. ролей", logic: "brainstorm→plan→TDD→subagent-driven-dev", vsSquad: "Сильнее plan/TDD; слабее marketing/design/SEO", change: "Уже в hub (bridge). Не дублировать Boss." },
  { name: "Anthropic code-review", stars: "official plugin", source: "claude-plugins-official", roles: "4–5 parallel reviewers + Haiku scorer", logic: "PR only, confidence ≥80", vsSquad: "Узкий scope; у нас squad-review шире", change: "Оставить pr-review skill. OK." },
  { name: "cursor-agent-team", stars: "academic", source: "github.com/thiswind/cursor-agent-team", roles: "3 маски: Partner / Executor / Prompt Engineer", logic: "Один чат, switch ролей slash-командами", vsSquad: "Проще, нет token tiers; хуже для агентства", change: "Не заменять Squad; взять идею «полный список вопросов»" },
  { name: "CCGS (game-studios)", stars: "hub-local", source: "skills/game-studios-multiagent", roles: "49 agents, 5 tiers", logic: "GDD→ADR→story gates, жёсткая иерархия", vsSquad: "Overkill для hub; силён в game dev", change: "Не копировать 49 ролей; взять gate-check pattern" },
  { name: "subagentmaxxing", stars: "niche", source: "github.com/Kuberwastaken/subagentmaxxing", roles: "Model router: Opus/Sonnet/Composer/GPT fanout", logic: "Один orchestrator, разные модели на задачу", vsSquad: "Ближе к твоей идее LLM rotation", change: "Добавить optional fanout на review (GPT+Sonnet)" },
  { name: "Cursor default Subagents", stars: "built-in", source: "Cursor docs / Settings", roles: "explore, shell, generalPurpose + custom", logic: "Boss spawn по задаче", vsSquad: "Меньше domain skills", change: "Squad = custom agents поверх built-in. OK." },
];

const COMPARE_FORMATS = [
  { format: "Squad v2 (твой)", boss: "Родительский чат", pros: "10 domain roles, marketing+design+code, token tiers", cons: "Drift models; spawn вручную; overhead" },
  { format: "Superpowers (obra)", boss: "Skills auto-trigger", pros: "254K stars, TDD/plan enforced, 8 harnesses", cons: "Нет growth/SEO/agency personas" },
  { format: "cursor-agent-team", boss: "1 чат, 3 маски", pros: "Нет потери контекста при switch", cons: "Нет параллели, нет specialist models" },
  { format: "Single Opus + Auto", boss: "Auto router", pros: "Zero config", cons: "Серый design, нет gates, дорого" },
];

const CLEANUP_DO = [
  { step: "1", action: "Settings → Models: 8–10 ON — DONE (Boss)", time: "DONE" },
  { step: "2", action: "НЕ sync agents model lines — trust_manual lock", time: "LOCK" },
  { step: "3", action: "hub-safe-cleanup Apply (markitdown sacred) — DONE S3", time: "DONE" },
  { step: "4", action: "Закрыть Cursor → cursor-system-refresh-deferred.ps1", time: "Boss TBD" },
  { step: "5", action: "Таксономия ACTIVE/ON-DEMAND/ARCHIVE — DONE S2", time: "DONE" },
  { step: "6", action: "Agency alwaysApply false (66/66) — DONE", time: "DONE" },
  { step: "7", action: "Reload Window — только если правили hooks (S3–S4 не трогали)", time: "N/A" },
  { step: "8", action: "S4: canvas sync + _INDEX dedupe + stale markers — DONE", time: "DONE" },
];

export default function HubDeepDiveAudit() {
  const theme = useHostTheme();
  const [section, setSection] = useCanvasState<SectionId>("section", "overview");
  const [modelFilter, setModelFilter] = useCanvasState<string>("modelFilter", "all");

  const filteredModels =
    modelFilter === "all"
      ? MODELS
      : MODELS.filter((m) => m.tier.toLowerCase() === modelFilter);

  return (
    <Stack gap={16} style={{ padding: 16, maxWidth: 960, color: theme.text.primary }}>
      <Stack gap={4}>
        <H1>Deep Dive: Hub + Squad + LLM</H1>
        <Text tone="secondary" size="small">
          Аудит для Артёма · {CANVAS_VERSION} · StackSpend, model-map, твои ответы
        </Text>
      </Stack>

      <Grid columns={4} gap={12}>
        <Stat label="Routes" value="69" />
        <Stat label="Squad agents" value="10" />
        <Stat label="S1–S3" value="DONE" tone="success" />
        <Stat label="S4 open" value="P0–P1" tone="warning" />
      </Grid>

      <UsageBar
        total={5}
        topLeftLabel="Твоё удовлетворение системой (из quiz, 1–5)"
        segments={SATISFACTION.map((s, i) => ({
          id: s.label,
          value: s.value,
          color: (["purple", "orange", "pink", "green", "blue", "yellow"] as const)[i],
        }))}
      />

      <Row gap={8} style={{ flexWrap: "wrap", alignItems: "flex-end" }}>
        <Stack gap={4}>
          <Text size="small" tone="secondary">Раздел</Text>
          <Select
            value={section}
            onChange={(v) => setSection(v as SectionId)}
            options={SECTIONS.map((s) => ({ value: s.id, label: s.label }))}
          />
        </Stack>
        {section === "models" && (
          <Stack gap={4}>
            <Text size="small" tone="secondary">Tier</Text>
            <Select
              value={modelFilter}
              onChange={setModelFilter}
              options={[
                { value: "all", label: "Все" },
                { value: "high", label: "High" },
                { value: "medium", label: "Medium" },
                { value: "low", label: "Low" },
              ]}
            />
          </Stack>
        )}
      </Row>

      {section === "overview" && (
        <Stack gap={12}>
          <Callout tone="info">
            Post S1–S3 (2026-07-16): find-skills, taxonomy, MCP tiers, design matrix, route echo «Подключил», dual
            review, cleanup, digest — wired. S4 = sync canvas/markers + hygiene (_INDEX), не новый стек.
          </Callout>
          <Card>
            <CardHeader title="Диагноз (обновлён)" />
            <CardBody>
              <Text>
                Инфраструктура после S3 заметно ближе к enforcement: task-router echo + design-stack gate в rules.
                Остаётся измерять proof in chat (smoke Applied / Подключил) и не трогать model-map lock. Главный долг
                UI-аудита был stale canvas v3.1 — **починен в S4** (v4.0). P3: design-refs, budget, Notion.
              </Text>
            </CardBody>
          </Card>
          <H2>Ближайшие действия</H2>
          <TodoList todos={ACTION_ITEMS} />
          <H2>Design refs (канон)</H2>
          <Table
            {...dataTable(
              ["Роль", "URL", "Заметка"],
              DESIGN_REFS.map((r) => [r.role, r.url, r.note]),
            )}
          />
        </Stack>
      )}

      {section === "models" && (
        <Stack gap={12}>
          <Callout tone="info">
            Итог: 10 моделей ON, остальные OFF. High (Opus+Codex) — план и build, не рутина. Fable OFF. GLM+Kimi+Gemini Pro —
            цена/качество и research.
          </Callout>

          <H2>1. Settings → Models: 10 ON / остальное OFF</H2>
          <Table
            {...dataTable(
              ["ON", "Модель", "Context", "Effort", "Think", "Когда"],
              ENABLED_MODELS_ROSTER.filter((m) => m.on).map((m) => [
                "✓",
                m.name,
                m.ctxLong ? `${m.ctx} · ${m.ctxLong}` : m.ctx,
                m.effort,
                m.thinking,
                m.when,
              ]),
            )}
          />
          <CollapsibleSection title="Что выключить (OFF)" defaultOpen={false}>
            <Table
              {...dataTable(
                ["Модель", "Причина OFF"],
                ENABLED_MODELS_ROSTER.filter((m) => !m.on).map((m) => [m.name, m.when]),
              )}
            />
          </CollapsibleSection>

          <Card variant="elevated">
            <CardHeader title="Конфигурация в Cursor UI (скопируй)" />
            <CardBody>
              <Stack gap={4}>
                <Text tone="secondary" size="small">Explore Subagent Model → Composer 2.5</Text>
                <Text tone="secondary" size="small">Architect subagent → claude-sonnet-5[thinking=true,context=1m,effort=medium]</Text>
                <Text tone="secondary" size="small">Design → claude-sonnet-5[thinking=true,effort=medium]</Text>
                <Text tone="secondary" size="small">Build → gpt-5.3-codex-high-fast</Text>
                <Text tone="secondary" size="small">Review → gpt-5.5-medium</Text>
                <Text tone="secondary" size="small">Scout/Cleanup → composer-2.5-fast</Text>
                <Text tone="secondary" size="small">Memory → claude-haiku-4-5-thinking</Text>
                <Text tone="secondary" size="small">Boss чат → Opus 4.8 thinking xhigh (план) или Sonnet 5 / Auto (работа)</Text>
              </Stack>
            </CardBody>
          </Card>

          <Card variant="elevated">
            <CardHeader title="Explore Subagent Model" />
            <CardBody>
              <Stack gap={6}>
                <Text weight="medium">Поставь: Composer 2.5 (Fast) — НЕ «Inherit from parent»</Text>
                <Text tone="secondary">
                  Inherit тянет модель Boss-чата. Если Boss на Opus или Auto выбрал Opus — каждый explore съедает в 10×
                  больше токенов. Explore = только чтение/grep/разведка → Composer 2.5 Fast (128K, effort low).
                </Text>
                <Text tone="secondary">
                  Совпадает с squad-scout и model-map. Встроенный Task(explore) и squad-scout — одна ценовая категория.
                </Text>
              </Stack>
            </CardBody>
          </Card>

          <Card>
            <CardHeader title="Ты = Boss (родительский чат). Отдельного squad-boss агента нет" />
            <CardBody>
              <Stack gap={6}>
                <Text tone="secondary">
                  Auto в Boss-чате выбирает только из включённых моделей. Чем меньше ON — тем предсказуемее Auto. С
                  таблицей выше Auto чаще попадёт в Sonnet/Codex, а не в legacy-модели.
                </Text>
                <Table
                  {...dataTable(
                    ["Ситуация", "Модель Boss", "Auto?"],
                    BOSS_MODEL_RULES.map((r) => [r.situation, r.model, r.auto]),
                  )}
                />
              </Stack>
            </CardBody>
          </Card>

          <Callout tone="warning">
            1M context: включай context=1m только на Sonnet 5 для architect/plan. Для длинных сессий — hook digest чата в
            .md (markitdown/transcript), чтобы агент читал сводку, а не весь чат. Иначе 1M = перерасход без выигрыша.
          </Callout>

          <H3>Справка по моделям (детали)</H3>
          {filteredModels.map((m) => (
            <CollapsibleSection
              key={m.slug}
              title={m.name}
              leading={<Swatch color={m.tier === "High" ? "red" : m.tier === "Medium" ? "blue" : "green"} />}
              trailing={<Pill tone="neutral" size="small">{m.tier}</Pill>}
            >
              <Stack gap={6} style={{ paddingLeft: 8 }}>
                <Text weight="medium">Сильна:</Text>
                <Text tone="secondary">{m.strength}</Text>
                <Text weight="medium">Слаба:</Text>
                <Text tone="secondary">{m.weak}</Text>
                <Text weight="medium">Голос dev-сообщества:</Text>
                <Text tone="secondary" size="small">{m.devVoice}</Text>
                <Text weight="medium">Куда в Squad:</Text>
                <Text tone="secondary">{m.squadFit}</Text>
              </Stack>
            </CollapsibleSection>
          ))}
          <Text tone="tertiary" size="small">
            Источники: stackspend.app, artificialanalysis.ai, model-map.md, твои ответы 14.07.2026
          </Text>
        </Stack>
      )}

      {section === "squad" && (
        <Stack gap={12}>
          <H2>2. Субагенты — модели, context, effort</H2>
          <Text tone="secondary" size="small">
            Канон: skills/project-squad/reference/model-map.md · Subagents UI = те же slug · Explore = Composer 2.5 Fast
          </Text>
          <Table
            {...dataTable(
              ["Роль", "Model slug", "Context", "Effort", "Think", "Файл"],
              SQUAD_MODELS.map((m) => [
                m.role,
                m.slug,
                m.ctx,
                m.effort,
                m.thinking,
                m.file,
              ]),
            )}
          />
          <H3>Drift: файл vs канон</H3>
          <Table
            {...dataTable(
              ["Роль", "Задача", "Сейчас в файле", "Статус"],
              SQUAD.filter((s) => s.id !== "boss").map((s) => [
                s.role,
                s.task,
                s.current,
                s.modelOk ? "OK" : "DRIFT",
              ]),
              SQUAD.filter((s) => s.id !== "boss").map((s) =>
                s.modelOk ? undefined : ("warning" as RowTone),
              ),
            )}
          />
          <Callout tone="warning">
            5 ролей в drift. Пропиши в agents/*.md те же slug, что в таблице выше. Boss — Opus 4.7 thinking xhigh вручную в чате.
          </Callout>
          <CollapsibleSection title="Как вписать effort / context в Cursor" defaultOpen>
            <Stack gap={4}>
              <Text tone="secondary">Формат в Subagents UI: model[thinking=true,context=1m,effort=high]</Text>
              <Text tone="secondary">Boss / Architect: thinking on + effort medium–xhigh для планов</Text>
              <Text tone="secondary">Build: Codex high-fast — effort встроен в имя модели</Text>
              <Text tone="secondary">Scout / Cleanup / Memory: effort low, без 1M context</Text>
              <Text tone="secondary">Никогда 2 High-tier (Boss+Build) параллельно на одних файлах</Text>
            </Stack>
          </CollapsibleSection>
        </Stack>
      )}

      {section === "logic" && (
        <Stack gap={12}>
          <H2>3. Логика Squad vs топовые аналоги</H2>
          <Text tone="secondary">
            10 ролей = token tiers + domain (growth/design/ship). Scout/cleanup Composer · Build Codex · Review GPT · Memory Haiku.
          </Text>
          <H3>Реальные репо и люди (июль 2026)</H3>
          <Table
            {...dataTable(
              ["Команда", "Источник", "Масштаб", "Состав", "vs Squad", "Менять?"],
              TEAM_ANALOGS.map((t) => [
                t.name,
                t.source,
                t.stars,
                t.roles,
                t.vsSquad,
                t.change,
              ]),
            )}
          />
          <Callout tone="info" title="Вердикт">
            Squad оставляем — уникален для агентства. Взять: Superpowers brainstorm gate, subagentmaxxing dual review (GPT+Sonnet).
            Не копировать 49 ролей CCGS. GLM/Kimi — экономия, прикрывать Sonnet+skills на design.
          </Callout>
          <H3>Форматы orchestration</H3>
          <Table
            {...dataTable(
              ["Формат", "Boss", "Плюсы", "Минусы"],
              COMPARE_FORMATS.map((r) => [r.format, r.boss, r.pros, r.cons]),
            )}
          />
        </Stack>
      )}

      {section === "markitdown" && (
        <Stack gap={12}>
          <H2>Почему MarkItDown только на файлы?</H2>
          <Text tone="secondary">
            Hook markitdown-intake.ps1 срабатывает на пути к бинарникам (pdf, docx, pptx, xlsx) во вложениях или промпте.
            Обычный текст чата уже markdown — прогон через MarkItDown даст overhead без выигрыша. RTK сжимает shell,
            GitNexus — код-граф, не grep по всему репо.
          </Text>
          <H3>Можно ли всё текстовое через MarkItDown?</H3>
          <Text tone="secondary">
            Нет смысла для chat/rules. Имеет смысл расширить на: большие HTML-дампы, email .eml, Notion export, длинные
            transcript JSONL → .md summary layer. Для skills — compact SKILL.md (&lt;350 строк) + references/, не inline
            700 строк в always-on.
          </Text>
          <H3>Что ещё по token economy</H3>
          <CollapsibleSection title="Работает" defaultOpen>
            <Text tone="secondary">
              RTK на Shell · compact task-router (~162 chars) · profile throttle 45 мин · hooks-token-test PASS ·
              GitHub archive ECC/n8n (~79 MB)
            </Text>
          </CollapsibleSection>
          <CollapsibleSection title="Не раскрывает потенциал">
            <Text tone="secondary">
              user-memory MCP — редко вызывается proactively · GitNexus — агент grep'ит вместо query · Exa vs Tavily —
              оба подключены, нет жёсткого «one web MCP» · 93+ rules грузят контекст каждый turn · Coach уроки не
              доходят до READY порога
            </Text>
          </CollapsibleSection>
          <CollapsibleSection title="Доработки без потери качества">
            <Text tone="secondary">
              1) alwaysApply: true только для 4 rules (profile, router, markitdown, rtk). 2) Transcript digest hook →
              .md перед длинными сессиями. 3) Skill lazy-load: router inject skill PATH, agent MUST read first 80 lines.
              4) MCP tier: Tier1=no tools, Tier2=read, Tier3=write+confirm.
            </Text>
          </CollapsibleSection>
        </Stack>
      )}

      {section === "mistakes" && (
        <Stack gap={8}>
          <H2>Где ты теряешь систему в промптах</H2>
          {[
            {
              t: "Мега-промпт на 14 пунктов без приоритета",
              d: "Агент берёт первые 3 пункта, остальное откладывает. Лучше: Deliverables / Не трогать / Готово когда.",
            },
            {
              t: "Ask mode для задач с файлами",
              d: "Hooks работают, но агент не может править → кажется что «ничего не меняется».",
            },
            {
              t: "Plan + ожидание что субагенты уже бегут",
              d: "Plan = только Boss планирует. Spawn squad-* — отдельный шаг после approve.",
            },
            {
              t: "Не Reload Window после hooks.json",
              d: "Самая частая причина «hooks не подтягиваются».",
            },
            {
              t: "Design без brief",
              d: "«Сделай презентацию» без huashu/brand-guardian/humanizer → generic gray UI.",
            },
            {
              t: "Auto model + все 25 моделей ON",
              d: "Auto-router путается; Explore Subagent ≠ squad model.",
            },
          ].map((item, i) => (
            <CollapsibleSection key={i} title={item.t} leading={<Swatch color="orange" />}>
              <Text tone="secondary">{item.d}</Text>
            </CollapsibleSection>
          ))}
        </Stack>
      )}

      {section === "honest" && (
        <Stack gap={12}>
          <Callout tone="warning">
            После S3 wiring сильнее, но proof in chat всё ещё нужно мерить (gate-smoke). Model-map ↔ agents — сознательный
            lock (trust_manual), не баг. Skills discovery = find-skills + taxonomy, не «загрузить всё».
          </Callout>
          <CollapsibleSection title="Что ещё слабо" defaultOpen>
            <Stack gap={4}>
              <Text>1. Enforcement smoke: echo + Applied checklist (S4 gate-smoke).</Text>
              <Text>2. Model drift accepted under trust_manual — не sync без OK.</Text>
              <Text>3. _INDEX дубли / шум discovery — чистка в S4.</Text>
              <Text>4. Canvas был stale до S4 sync.</Text>
              <Text>5. P3: design-refs, budget, Notion — нет данных.</Text>
              <Text>6. Growth landing-brief — вне этого sprint.</Text>
            </Stack>
          </CollapsibleSection>
          <CollapsibleSection title="Чего ты не понимаешь при постановке задач">
            <Text tone="secondary">
              Cursor agent не «помнит» hub между сессиями автоматически. Каждый чат — cold start + always-on rules.
              Чтобы система «работала», нужен видимый артеfact: route block, skill read log, spawn transcript. Ты
              ожидаешь фоновую магию — Cursor даёт prompt injection + optional MCP.
            </Text>
          </CollapsibleSection>
        </Stack>
      )}

      {section === "q7" && (
        <Card variant="elevated">
          <CardHeader title="7. Plan + /project-squad + Auto — как работает?" />
          <CardBody>
            <Stack gap={10}>
              <Row gap={8}>
                <Pill tone="info">Boss (этот чат)</Pill>
                <Text>Режим Plan = только план, без writes. Auto = Cursor сам выбирает модель Boss-чата, не субагентов.</Text>
              </Row>
              <Row gap={8}>
                <Pill tone="neutral">squad-* subagents</Pill>
                <Text>
                  Берут model: из frontmatter agents/squad-*.md. Auto родителя НЕ наследуется. Boss может override:
                  «Model: composer-2.5-fast» в spawn-команде.
                </Text>
              </Row>
              <Row gap={8}>
                <Pill tone="warning">!auto / autopilot hook</Pill>
                <Text>
                  Даёт Boss право писать без лишних confirm. Не меняет модели субагентов. Не spawn'ит их автоматически —
                  Boss должен явно вызвать.
                </Text>
              </Row>
              <Divider />
              <Text weight="medium">Короткий ответ:</Text>
              <Text tone="secondary">
                Plan+Auto = Boss планирует на Auto-модели. Каждый squad-* берёт model из frontmatter. Drift vs model-map
                — lock trust_manual: не sync агентов. Override: «Model: …» при spawn, если нужно.
              </Text>
            </Stack>
          </CardBody>
        </Card>
      )}

      {section === "cleanup" && (
        <Stack gap={12}>
          <H2>8. Что почистить — план действий</H2>
          <Table
            {...dataTable(
              ["#", "Сделать", "Время"],
              CLEANUP_DO.map((r) => [r.step, r.action, r.time]),
            )}
          />
          <H3>Что убрать / архивировать</H3>
          <Table
            {...dataTable(
              ["Кандидат", "Риск", "Выигрыш"],
              [
                ["Дубли rules (.cursor/rules + rules/)", "Средний", "Context tokens"],
                ["Deprecated skills (skills-main/deprecated)", "Низкий", "Шум discovery"],
                ["25+ models ON в Settings", "Низкий", "Фокус + меньше путаницы"],
                ["Obsidian refs (DEC-009)", "Низкий", "Ясность memory stack"],
                ["Неиспользуемые MCP plugins", "Низкий", "Меньше descriptor overload"],
              ],
            )}
          />
          <Callout tone="info">
            Не трогать: hooks.json, task-router, user-profile, project-squad, markitdown venv, mcp.json secrets.
            Taxonomy: ACTIVE / ON-DEMAND / ARCHIVE.
          </Callout>
        </Stack>
      )}

      {section === "why-broken" && (
        <Stack gap={12}>
          <H2>Почему «ничего не меняется»</H2>
          {[
            ["Hooks", "Инжектят текст в user message. Агент может проигнорировать. Fix: agent rule «если видишь [TASK ROUTE] — read SKILL first» + visible echo в ответе."],
            ["Skills", "Лежат в disk. Cursor показывает list, но не auto-read. Fix: router returns skill path; Boss logs «Read: huashu-design/SKILL.md»."],
            ["MCP", "50+ servers — descriptor overload. Fix: McpTier.ps1 + max 3 MCP per task."],
            ["Plugins", "Rules alwaysApply=true от каждого plugin суммируются. Fix: disable plugin rules не по задаче."],
            ["Иерархия", "Нет enforced tree — flat rules. Fix: SYSTEM-TAXONOMY ACTIVE tier only."],
          ].map(([title, body]) => (
            <CollapsibleSection key={title} title={title} leading={<Swatch color="purple" />}>
              <Text tone="secondary">{body}</Text>
            </CollapsibleSection>
          ))}
          <Callout tone="info">
            Post-S3: route echo rule в task-router.mdc есть; design gate в design-stack + squad-design. Дальше —
            измерять signal в чате (gate-smoke), не наращивать слои. Hooks.json в S3–S4 не трогали.
          </Callout>
        </Stack>
      )}

      {section === "memory" && (
        <Stack gap={12}>
          <H2>10. Память, вопросы, забытые задачи</H2>
          <Text tone="secondary">
            Почему 1–2 вопроса вместо полного списка: conflict между rules (plan-first, не останавливаться в середине) и
            user-profile (полный AskQuestion до старта). Агент выбирает «не блокировать» — это баг compliance.
          </Text>
          <Text tone="secondary">
            Почему забываю пункты: длинный промпт без нумерации статуса; нет todo persistence между turns; summary
            теряет хвост.
          </Text>
          <Text tone="secondary">
            Fix: Boss обязан TodoWrite на 3+ step tasks; AskQuestion tool до Phase 0; squad-memory после каждой delivery.
          </Text>
        </Stack>
      )}

      {section === "about-you" && (
        <Stack gap={12}>
          <H2>11. Что я знаю о тебе</H2>
          <Grid columns={2} gap={12}>
            <Card>
              <CardHeader title="Профиль" />
              <CardBody>
                <Stack gap={4}>
                  <Text>Артём, Молдова, UTC+3, русский язык</Text>
                  <Text tone="secondary">Бoss AI-агентства ~4 мес, B2B/B2C, SaaS, курсы</Text>
                  <Text tone="secondary">Plan-first, confirm-writes, partner tone, plain RU</Text>
                  <Text tone="secondary">Боль: вода, серый дизайн, hooks не видны, MCP rotation</Text>
                </Stack>
              </CardBody>
            </Card>
            <Card>
              <CardHeader title="Хочу узнать" />
              <CardBody>
                <Stack gap={4}>
                  <Text tone="secondary">1. Название агентства + niche (для brand-guardian)</Text>
                  <Text tone="secondary">2. Top-3 revenue services сейчас</Text>
                  <Text tone="secondary">3. GitHub org strategy — hub vs client repos</Text>
                  <Text tone="secondary">4. Design refs — Apple (gold) · Antigravity (wow) · Framery (sell) · Palantir AIP</Text>
                  <Text tone="secondary">5. Budget cap на AI models / month — пока не задан</Text>
                </Stack>
              </CardBody>
            </Card>
          </Grid>
        </Stack>
      )}

      {section === "partner" && (
        <Stack gap={12}>
          <H2>12. Поддакивание и skills на полке</H2>
          <Text tone="secondary">
            Поддакивание = default RLHF + твой past feedback «продолжай без остановок». Partner tone rule есть, но
            слабее reward за agree. Fix: явный «challenge mode» в промпте; я обязан писать «Риск:» и «Альтернатива:» перед
            согласием на крупную задачу.
          </Text>
          <Text tone="secondary">
            Skills не применяются потому что нет hard gate: read SKILL.md → output section «Applied:» with checklist.
            Без этого — импровизация.
          </Text>
        </Stack>
      )}

      {section === "skills-mcp" && (
        <Stack gap={12}>
          <H2>13. Работают ли skills/MCP на фоне?</H2>
          <Callout tone="info">
            Частично. Always-on: markitdown hook, RTK, task-router inject, user-profile, prompt-coach capture. НЕ
            always-on: huashu, seo-geo, agency personas, MCP calls — только если agent решит.
          </Callout>
          <Text tone="secondary">
            Design был серым потому что: не spawn squad-design, не read huashu-design/SKILL.md, не @brand-guardian, не
            humanizer on copy, GLM без design skills ≈ generic Tailwind.
          </Text>
          <Text tone="secondary">
            MCP plugins установлены — но agent должен GetMcpTools + CallMcpTool. Figma/Stitch/Higgsfield не срабатывают
            сами.
          </Text>
        </Stack>
      )}

      {section === "auto-route" && (
        <Stack gap={12}>
          <H2>14. Автоподбор без @ — статус post-S3</H2>
          <Card>
            <CardHeader title="Flow (1–3 wired; 4–5 — compliance)" />
            <CardBody>
              <Stack gap={8}>
                <Text>1. Ты пишешь простой промпт — OK</Text>
                <Text>2. task-router.ps1 → [TASK ROUTE] — OK (69 routes, tests PASS)</Text>
                <Text>3. Boss echo «Подключил: …» — rule DONE; smoke в S4</Text>
                <Text>4. AskQuestion полный список — policy в user-profile</Text>
                <Text>5. Execute with design gate Applied — matrix DONE; smoke в S4</Text>
              </Stack>
            </CardBody>
          </Card>
          <Table
            {...dataTable(
              ["Инструмент", "TL;DR"],
              [
                ["task-router", "Классифицирует промпт → skill/MCP/subagent"],
                ["huashu-design", "HTML/PPTX/motion — не generic React"],
                ["humanizer", "RU copy без AI-slop для клиентов"],
                ["seo-geo", "SEO/GEO audits + CORE-EEAT"],
                ["user-memory", "Долгая память между сессиями"],
                ["Exa MCP", "Web research primary"],
                ["project-squad", "Multi-agent execution phases"],
              ],
            )}
          />
          <Button
            onClick={() => setSection("overview")}
            variant="secondary"
          >
            Вернуться к action items
          </Button>
        </Stack>
      )}

      {section === "squad-howto" && (
        <Stack gap={12}>
          <H2>15. Как правильно запустить Squad</H2>
          <Card variant="elevated">
            <CardHeader title="Минимальный промпт (скопируй шаблон)" />
            <CardBody>
              <Text tone="secondary">
                {`/project-squad audit путь/к/репо\n\nDeliverables: [что на выходе]\nНе трогать: [файлы, .env]\nГотово когда: [критерий]\nБез commit / без deploy`}
              </Text>
            </CardBody>
          </Card>
          <Table
            {...dataTable(
              ["Режим", "Когда", "Squad"],
              [
                ["Plan", "Крупная задача, архитектура", "Boss планирует; spawn после OK"],
                ["Agent", "Правки файлов, build", "scout→architect→build→review→qa"],
                ["Ask", "Вопросы без правок", "Субагенты не spawn'ятся"],
                ["Debug", "Баг, CI", "scout + systematic-debugging → build"],
              ],
            )}
          />
          <H3>Что указать от руки (обязательно)</H3>
          <Stack gap={4}>
            <Text>1. Путь к workspace (абсолютный)</Text>
            <Text>2. Deliverables / Не трогать / Готово когда</Text>
            <Text>3. Явный spawn: «Use the squad-scout subagent to …»</Text>
            <Text>4. Gates: «без commit», «без deploy» (если не хочешь push)</Text>
            <Text>5. Для design: «web app» или «deck» — разные skills</Text>
          </Stack>
          <H3>Что НЕ нужно писать</H3>
          <Text tone="secondary">
            @skills, @mcp, markitdown — router подставит. Model у субагентов — из agents/squad-*.md (не Auto родителя).
          </Text>
          <Callout tone="info">
            Auto в чате = модель Boss, не squad. Plan + Auto = план на Auto-модели; субагенты после approve со своими моделями.
          </Callout>
          <TodoList todos={ACTION_ITEMS} />
        </Stack>
      )}

      <Divider />
      <Text tone="tertiary" size="small">
        Canvas: hub-deep-dive-audit · {CANVAS_VERSION} · Boss: Opus 4.8 xhigh · Explore: Composer 2.5 Fast · ON: 10 models
      </Text>
    </Stack>
  );
}
