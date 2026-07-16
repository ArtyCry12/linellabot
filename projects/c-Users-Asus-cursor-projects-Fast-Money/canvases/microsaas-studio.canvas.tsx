import {
  BarChart,
  Button,
  Callout,
  Card,
  CardBody,
  CardHeader,
  Divider,
  Grid,
  H1,
  H2,
  H3,
  Pill,
  Row,
  Select,
  Spacer,
  Stack,
  Stat,
  Table,
  Text,
  useCanvasState,
  useHostTheme,
} from "cursor/canvas";

type Stage = "1" | "2" | "3" | "4";
type WeightKey = "ttp" | "lowCost" | "melo" | "b2b" | "ceiling" | "viral";

const WEIGHT_OPTIONS = [
  { value: "0.7", label: "Низкий 0.7" },
  { value: "1.0", label: "Средний 1.0" },
  { value: "1.3", label: "Высокий 1.3" },
  { value: "1.5", label: "Критично 1.5" },
];

const DEFAULT_WEIGHTS: Record<WeightKey, string> = {
  ttp: "1.3",
  lowCost: "1.3",
  melo: "1.5",
  b2b: "1.3",
  ceiling: "1.0",
  viral: "1.0",
};

type Idea = {
  id: string;
  name: string;
  oneLiner: string;
  scores: Record<WeightKey, number>;
  top3: boolean;
};

const IDEAS: Idea[] = [
  {
    id: "ai-inbox-smb",
    name: "Ada — AI Inbox SMB",
    oneLiner: "WA/IG админ + запись для стоматологий, салонов, авто",
    scores: { ttp: 9, lowCost: 9, melo: 10, b2b: 9, ceiling: 8, viral: 7 },
    top3: true,
  },
  {
    id: "social-shop-os",
    name: "Social Shop OS",
    oneLiner: "Мини-витрина для IG/TG шопов без сайта (боль 999 сбоку)",
    scores: { ttp: 7, lowCost: 8, melo: 8, b2b: 8, ceiling: 9, viral: 8 },
    top3: true,
  },
  {
    id: "micro-automations-suite",
    name: "Micro-automations",
    oneLiner: "Каталог готовых микро-автоматизаций в красивом UI",
    scores: { ttp: 6, lowCost: 7, melo: 7, b2b: 8, ceiling: 8, viral: 6 },
    top3: true,
  },
  {
    id: "teen-jobs",
    name: "Teen Career",
    oneLiner: "Работа 16–19 + AI-квалификация под трендовые сферы",
    scores: { ttp: 4, lowCost: 6, melo: 5, b2b: 5, ceiling: 7, viral: 8 },
    top3: false,
  },
  {
    id: "md-ai-news",
    name: "MD AI Feed",
    oneLiner: "Лента/чат по Молдове + инфлюенсеры",
    scores: { ttp: 3, lowCost: 5, melo: 3, b2b: 2, ceiling: 6, viral: 7 },
    top3: false,
  },
  {
    id: "duolingo-skill",
    name: "Upskill Duolingo-like",
    oneLiner: "Привычка учиться сложным сферам простым языком",
    scores: { ttp: 2, lowCost: 4, melo: 3, b2b: 3, ceiling: 8, viral: 7 },
    top3: false,
  },
  {
    id: "marketplace-999",
    name: "999-killer Marketplace",
    oneLiner: "Полный маркетплейс 2.0 с видео/3D/соцкнопками",
    scores: { ttp: 2, lowCost: 2, melo: 4, b2b: 4, ceiling: 7, viral: 6 },
    top3: false,
  },
];

function weightedScore(
  idea: Idea,
  weights: Record<WeightKey, string>
): number {
  let sum = 0;
  let wSum = 0;
  (Object.keys(idea.scores) as WeightKey[]).forEach((k) => {
    const w = Number(weights[k] || "1");
    sum += idea.scores[k] * w;
    wSum += w;
  });
  return Math.round((sum / wSum) * 10) / 10;
}

function StageNav({
  stage,
  setStage,
}: {
  stage: Stage;
  setStage: (s: Stage) => void;
}) {
  const items: { id: Stage; label: string }[] = [
    { id: "1", label: "1. Поле" },
    { id: "2", label: "2. Топ-3" },
    { id: "3", label: "3. Финал" },
    { id: "4", label: "4. Архитектура" },
  ];
  return (
    <Row gap={8} wrap>
      {items.map((item) => (
        <Button
          key={item.id}
          variant={stage === item.id ? "primary" : "secondary"}
          onClick={() => setStage(item.id)}
        >
          {item.label}
        </Button>
      ))}
    </Row>
  );
}

function WeightsPanel({
  weights,
  setWeight,
}: {
  weights: Record<WeightKey, string>;
  setWeight: (k: WeightKey, v: string) => void;
}) {
  const labels: Record<WeightKey, string> = {
    ttp: "TTP (скорость денег)",
    lowCost: "Низкие расходы",
    melo: "Рычаг MELO",
    b2b: "B2B платит",
    ceiling: "Потолок роста",
    viral: "Дешёвый/вирусный маркетинг",
  };
  return (
    <Grid columns={2} gap={12}>
      {(Object.keys(labels) as WeightKey[]).map((k) => (
        <Stack key={k} gap={4}>
          <Text size="small" tone="secondary">
            {labels[k]}
          </Text>
          <Select
            value={weights[k]}
            onChange={(v) => setWeight(k, v)}
            options={WEIGHT_OPTIONS}
          />
        </Stack>
      ))}
    </Grid>
  );
}

function Stage1({
  weights,
  setWeight,
}: {
  weights: Record<WeightKey, string>;
  setWeight: (k: WeightKey, v: string) => void;
}) {
  const ranked = [...IDEAS]
    .map((idea) => ({ idea, score: weightedScore(idea, weights) }))
    .sort((a, b) => b.score - a.score);

  return (
    <Stack gap={16}>
      <H2>Этап 1 — Широкое поле</H2>
      <Text tone="secondary">
        7 направлений. Веса автопилота уже выставлены под твой профиль (TTP,
        MELO, B2B, низкий cost). Подвинь слайдеры — рейтинг пересчитается.
      </Text>

      <Card>
        <CardHeader>Веса рубрики</CardHeader>
        <CardBody>
          <WeightsPanel weights={weights} setWeight={setWeight} />
        </CardBody>
      </Card>

      <H3>Реалии Молдовы (источники: WB, NBS, Invest MD, OSW, Simpals)</H3>
      <Grid columns={4} gap={12}>
        <Stat value="~$8.6k" label="GDP / capita 2025" />
        <Stat value="€709" label="Средняя ЗП H1’24" />
        <Stat value="~2.3M" label="Резидентное население" />
        <Stat value="~300k" label="999.md DAU" tone="info" />
      </Grid>
      <Callout tone="info" title="Следствие">
        Малый рынок + слабая B2C-платёжеспособность + RU/RO + мозги уезжают =
        начинаем с B2B в Chișinău, продукт расширяем горизонтально (модули /
        RO), а не через «ещё один маркетплейс».
      </Callout>

      <Table
        headers={["Ранг", "Идея", "Скор", "Статус", "Клин"]}
        columnAlign={["right", "left", "right", "left", "left"]}
        rows={ranked.map((r, i) => [
          String(i + 1),
          r.idea.name,
          String(r.score),
          r.idea.top3 ? "ТОП-3" : "отложено",
          r.idea.oneLiner,
        ])}
        rowTone={ranked.map((r) => (r.idea.top3 ? "success" : "neutral"))}
        striped
      />

      <H3>Взвешенный скор идей (автопилот)</H3>
      <BarChart
        categories={ranked.map((r) => r.idea.name.split(" — ")[0] || r.idea.name)}
        series={[
          {
            name: "Скор",
            data: ranked.map((r) => r.score),
            tone: "info",
          },
        ]}
        height={220}
        yMax={10}
      />

      <Callout tone="success" title="Автопилот → топ-3">
        Ada (AI Inbox) · Social Shop OS · Micro-automations. Остальное отсеяно:
        marketplace бьётся с 999; news/Duolingo — долгий TTP и слабый B2B;
        teen-jobs — сезон + юридическая сложность 16–18.
      </Callout>
    </Stack>
  );
}

function Stage2() {
  return (
    <Stack gap={16}>
      <H2>Этап 2 — Deep-dive топ-3</H2>
      <Text tone="secondary">
        Прямое сравнение. Победитель выбран автопилотом — Social Shop остаётся
        модулем v2 внутри Ada.
      </Text>

      <Table
        headers={["Критерий", "Ada Inbox", "Social Shop OS", "Micro-suite"]}
        rows={[
          ["ICP", "Клиники / салоны / авто", "IG/TG ресейлеры", "SMB «хочу Zapier»"],
          ["JTBD", "Не терять лиды в Direct", "Продавать без сайта", "Склеить сервисы"],
          ["Клин входа", "MELO Booking Pack", "Боль 999 + нет сайта", "Каталог сценариев"],
          ["Монетизация", "Подписка 390–1490 MDL", "Подписка + % позже", "Подписка / пакеты"],
          ["TTP", "14–21 день", "21–40 дней", "21–35 дней"],
          ["Тех-cost / мес", "$10–25", "$15–40", "$20–50"],
          ["Рычаг MELO", "Максимум", "Высокий", "Средний"],
          ["Главный риск", "Малый рынок MD", "Нужен supply продавцов", "Конкуренция Make/Zapier"],
        ]}
        striped
      />

      <Grid columns={3} gap={12}>
        <Card>
          <CardHeader trailing={<Pill tone="success" size="sm">Winner</Pill>}>
            Ada
          </CardHeader>
          <CardBody>
            <Text>
              Продуктизирует уже описанный в MELO upsell «Booking Pack». Деньги
              у бизнеса. Не нужен двухсторонний маркетплейс.
            </Text>
          </CardBody>
        </Card>
        <Card>
          <CardHeader trailing={<Pill tone="warning" size="sm">Backup / v2</Pill>}>
            Social Shop
          </CardHeader>
          <CardBody>
            <Text>
              Не конкурируем с 999 head-on: даём продавцу свою витрину (поиск,
              видео, соцкнопки). Становится модулем Ada.
            </Text>
          </CardBody>
        </Card>
        <Card>
          <CardHeader trailing={<Pill tone="neutral" size="sm">Park</Pill>}>
            Micro-suite
          </CardHeader>
          <CardBody>
            <Text>
              Хорошая идея «на потом», слабый wedge для холодного MD SMB без
              живого собеседника.
            </Text>
          </CardBody>
        </Card>
      </Grid>

      <Callout tone="success" title="Решение этапа 2">
        Строим Ada сейчас. Social Shop — фаза расширения той же учётной записи
        (Inbox + Витрина), а не отдельный стартап.
      </Callout>
    </Stack>
  );
}

function Stage3() {
  return (
    <Stack gap={16}>
      <H2>Этап 3 — Финал: Ada</H2>
      <H3>AI-администратор для локального бизнеса Молдовы</H3>
      <Text>
        Отвечает в WhatsApp / Instagram / Telegram на RU и RO, закрывает FAQ,
        собирает запись. Бизнес видит диалоги и календарь. Пользователь «не
        думает, что платит» — платит владелец точки.
      </Text>

      <Grid columns={3} gap={12}>
        <Stat value="14–21д" label="TTP до 1–3 платящих" tone="success" />
        <Stat value="≤$25" label="Месячный тех-cost до PMF" />
        <Stat value="18ч/нед" label="Соло-темп" />
      </Grid>

      <Card>
        <CardHeader>MVP границы (что входит / не входит)</CardHeader>
        <CardBody>
          <Grid columns={2} gap={16}>
            <Stack gap={8}>
              <Text weight="semibold">В MVP</Text>
              <Text size="small">• 1 канал: Telegram fallback → WhatsApp</Text>
              <Text size="small">• База знаний из сайта / IG bio</Text>
              <Text size="small">• AI FAQ + сбор контактa + слот</Text>
              <Text size="small">• Кабинет: диалоги + bookings</Text>
              <Text size="small">• RU / RO</Text>
              <Text size="small">• Биллинг вручную первые 30 дней</Text>
            </Stack>
            <Stack gap={8}>
              <Text weight="semibold">Не в MVP</Text>
              <Text size="small">• Маркетплейс и лента новостей</Text>
              <Text size="small">• Teen-jobs / Duolingo</Text>
              <Text size="small">• 3D / тяжёлое видео-каталог</Text>
              <Text size="small">• Полный Stripe/фискальный контур MD</Text>
            </Stack>
          </Grid>
        </CardBody>
      </Card>

      <H3>Цены</H3>
      <Table
        headers={["План", "Цена", "Для кого"]}
        rows={[
          ["Старт", "390 MDL/мес", "1 канал, до 300 AI-ответов"],
          ["Бизнес", "790 MDL/мес", "Мультиканал + запись, 1500 ответов"],
          ["Про", "1490 MDL/мес", "Филиалы / приоритет / позже white-label"],
        ]}
      />

      <H3>Скачок популярности без бюджета</H3>
      <Text size="small">
        1) Пилот 14 дней бесплатно клиентам MELO-демо. 2) Кейс «X лидов спасено
        за неделю» → TG + Reels. 3) Позиция «первый AI-админ для салонов/клиник
        MD». 4) Реферал: −1 месяц за приведённого коллегу.
      </Text>

      <Callout tone="info" title="Расширение">
        M2 Instagram/TG → M3 модуль Витрина (Social Shop) → M4–6 Румыния →
        later white-label. РФ — отдельное решение (платежи/хостинг).
      </Callout>
    </Stack>
  );
}

function Stage4() {
  return (
    <Stack gap={16}>
      <H2>Этап 4 — Архитектура и план сборки</H2>

      <Table
        headers={["Слой", "Выбор", "Зачем"]}
        rows={[
          ["Web / deploy", "Next.js 16 + Vercel", "Уже стек Fast-Money / MELO"],
          ["Data / auth", "Supabase free", "Таблицы + RLS без своего бэка"],
          ["Оркестрация", "n8n", "Webhooks WA/TG без тяжёлого кода"],
          ["AI", "Gemini Flash / GPT-mini", "Дешёвые FAQ-ответы"],
          ["Каналы", "TG Bot → WA Cloud", "Быстрый старт, потом WA"],
          ["Биллинг v0", "Invoice вручную", "Деньги раньше интеграции банков"],
        ]}
        striped
      />

      <H3>Поток данных</H3>
      <Text size="small">
        Клиент → WhatsApp/TG → webhook → n8n → Ada (LLM + knowledge) → ответ →
        при необходимости booking row в Supabase → кабинет бизнеса.
      </Text>

      <H3>Вехи @ 18 ч / неделю</H3>
      <Table
        headers={["Неделя", "Часы", "Готово когда"]}
        rows={[
          ["W1", "18", "Auth, tenant, KB upload, fake chat UI"],
          ["W2", "18", "Telegram bot end-to-end + таблица записей"],
          ["W3", "18", "WA или отполированный TG + RU/RO + 3 пилота"],
          ["W4", "18", "Ручной биллинг + онбординг + первый paid"],
        ]}
        rowTone={["info", "info", "warning", "success"]}
      />

      <Callout tone="success" title="Статус студии">
        Автопилот завершил stages 1→4. Hub лежит в
        ai-tracking/microsaas/. Следующий шаг разработки — каркас репо Ada и
        первая неделя W1. Имя «Ada» рабочее: можно переименовать до старта кода.
      </Callout>
    </Stack>
  );
}

export default function MicroSaasStudio() {
  const theme = useHostTheme();
  const [stage, setStage] = useCanvasState<Stage>("stage", "4");
  const [wTtp, setWTtp] = useCanvasState("w_ttp", DEFAULT_WEIGHTS.ttp);
  const [wLow, setWLow] = useCanvasState("w_low", DEFAULT_WEIGHTS.lowCost);
  const [wMelo, setWMelo] = useCanvasState("w_melo", DEFAULT_WEIGHTS.melo);
  const [wB2b, setWB2b] = useCanvasState("w_b2b", DEFAULT_WEIGHTS.b2b);
  const [wCeil, setWCeil] = useCanvasState("w_ceil", DEFAULT_WEIGHTS.ceiling);
  const [wViral, setWViral] = useCanvasState("w_viral", DEFAULT_WEIGHTS.viral);

  const weights: Record<WeightKey, string> = {
    ttp: wTtp,
    lowCost: wLow,
    melo: wMelo,
    b2b: wB2b,
    ceiling: wCeil,
    viral: wViral,
  };

  const setWeight = (k: WeightKey, v: string) => {
    switch (k) {
      case "ttp":
        setWTtp(v);
        break;
      case "lowCost":
        setWLow(v);
        break;
      case "melo":
        setWMelo(v);
        break;
      case "b2b":
        setWB2b(v);
        break;
      case "ceiling":
        setWCeil(v);
        break;
      case "viral":
        setWViral(v);
        break;
      default: {
        const _exhaustive: never = k;
        return _exhaustive;
      }
    }
  };

  return (
    <Stack gap={20} style={{ padding: 16, maxWidth: 960 }}>
      <Stack gap={8}>
        <Row gap={8} align="center">
          <H1 style={{ margin: 0 }}>Micro-SaaS Studio</H1>
          <Pill tone="success" size="sm">
            !auto
          </Pill>
          <Pill tone="info" size="sm">
            MD → RO
          </Pill>
        </Row>
        <Text tone="secondary">
          Интерактивный лендинг-quiz: этапы 1→4 пройдены автопилотом с учётом
          MELO, TTP 14–31д, соло 18ч/нед. Дизайн фиксирован — меняется контент.
        </Text>
      </Stack>

      <Callout tone="warning" title="Автопилот-контракт">
        Решения зафиксированы в hub без пауз на каждом гейте. Можешь
        переопределить веса на этапе 1 или переключить этап ниже — структура
        останется той же.
      </Callout>

      <StageNav stage={stage} setStage={setStage} />
      <Divider />

      {stage === "1" && (
        <Stage1 weights={weights} setWeight={setWeight} />
      )}
      {stage === "2" && <Stage2 />}
      {stage === "3" && <Stage3 />}
      {stage === "4" && <Stage4 />}

      <Divider />
      <Row gap={8} align="center">
        <Text size="small" tone="tertiary">
          Hub: ai-tracking/microsaas/ · победитель: Ada · backup: Social Shop OS
        </Text>
        <Spacer />
        <Text
          size="small"
          tone="tertiary"
          style={{ color: theme.text.quaternary }}
        >
          Fast-Money × MELO
        </Text>
      </Row>
    </Stack>
  );
}
