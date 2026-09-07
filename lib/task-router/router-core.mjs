import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { performance } from "node:perf_hooks";

const here = path.dirname(fileURLToPath(import.meta.url));
const hubRoot = path.resolve(here, "../..");
const indexPath = path.join(here, "capabilities.generated.json");

const STOP_WORDS = new Set([
  "а", "без", "бы", "в", "во", "вот", "все", "для", "до", "его", "ее",
  "и", "из", "или", "как", "к", "мне", "мы", "на", "не", "но", "о", "он",
  "она", "по", "под", "при", "с", "со", "так", "то", "у", "это", "я",
  "a", "an", "and", "for", "from", "in", "is", "it", "of", "on", "or",
  "the", "this", "to", "with",
]);

const normalizedCache = new Map();
const tokenCache = new Map();
const SOCIAL_FILLER_WORDS = new Set([
  "все", "понятно", "понял", "поняла", "ок", "хорошо", "благодарю",
  "please", "you",
]);

function normalize(value = "") {
  const source = String(value);
  const cached = normalizedCache.get(source);
  if (cached !== undefined) return cached;
  const normalized = source
    .normalize("NFKC")
    .toLowerCase()
    .replaceAll("ё", "е")
    .replace(/[“”«»"']/gu, " ")
    .replace(/[^\p{L}\p{N}@./:+_-]+/gu, " ")
    .replace(/\s+/gu, " ")
    .trim();
  if (normalizedCache.size < 4096) normalizedCache.set(source, normalized);
  return normalized;
}

function words(value) {
  const normalized = normalize(value);
  const cached = tokenCache.get(normalized);
  if (cached !== undefined) return cached;
  const tokens = normalized.split(" ").filter(Boolean);
  if (tokenCache.size < 4096) tokenCache.set(normalized, tokens);
  return tokens;
}

function contentWords(value) {
  return words(value).filter((word) => !STOP_WORDS.has(word) && word.length > 1);
}

function clauses(value) {
  return String(value)
    .split(/[.!?;\n]+|,\s*(?:но|затем|потом|чтобы|хотя)\s+/giu)
    .map(normalize)
    .filter(Boolean);
}

function boundedPrompt(input) {
  const prompt = String(input.prompt ?? "").slice(0, 1600);
  const extra = String(input.extraText ?? "");
  if (!extra) return prompt;
  const sample = extra.length <= 1600
    ? extra
    : `${extra.slice(0, 800)}\n${extra.slice(-800)}`;
  return `${prompt}\n${sample}`;
}

function spansFor(value, min = 2, max = 7) {
  const tokens = words(value);
  const spans = [];
  for (let size = min; size <= Math.min(max, tokens.length); size += 1) {
    for (let start = 0; start <= tokens.length - size; start += 1) {
      spans.push(tokens.slice(start, start + size).join(" "));
    }
  }
  return spans;
}

function termHit(text, term) {
  const haystack = normalize(text);
  const needle = normalize(term);
  if (!needle) return false;
  const tokens = words(haystack);
  const needleTokens = words(needle);
  if (needleTokens.length > 1) {
    return tokens.some((_, start) =>
      needleTokens.every((token, offset) => tokens[start + offset] === token),
    );
  }
  if (needle.length >= 4) return tokens.some((token) => token.startsWith(needle));
  return tokens.includes(needle);
}

function keywordHit(text, keyword) {
  const haystack = normalize(text);
  const needle = normalize(keyword);
  if (!needle) return false;
  if (needle.includes(" ")) return haystack.includes(needle);
  return words(haystack).includes(needle);
}

function anyHit(text, terms = []) {
  return terms.find((term) => termHit(text, term)) ?? null;
}

function isTermNegated(text, term) {
  const tokens = words(text);
  const needle = words(term)[0];
  const index = tokens.findIndex((token) =>
    needle.length >= 4 ? token.startsWith(needle) : token === needle,
  );
  if (index < 0) return false;
  const before = tokens.slice(Math.max(0, index - 3), index);
  return before.includes("не") ||
    before.includes("без") ||
    before.includes("безо") ||
    before.includes("never") ||
    before.includes("without") ||
    (before.includes("don") && before.includes("t"));
}

function jaccard(left, right) {
  const a = new Set(contentWords(left));
  const b = new Set(contentWords(right));
  if (!a.size || !b.size) return 0;
  let intersection = 0;
  for (const token of a) if (b.has(token)) intersection += 1;
  return intersection / (a.size + b.size - intersection);
}

function similarityAgainstSpans(promptSpans, utterance) {
  let best = jaccard(promptSpans.join(" "), utterance);
  for (const span of promptSpans) best = Math.max(best, jaccard(span, utterance));
  return best;
}

function scoreCard(card, prompt, promptClauses, promptSpans, language) {
  let score = 0;
  const hits = [];
  const evidenceSpans = [];

  const anti = anyHit(prompt, card.antiExamples);
  if (anti) {
    score -= 80;
    hits.push(`anti:${anti}`);
  }

  for (const tag of card.tags ?? []) {
    if (normalize(prompt).includes(normalize(tag))) {
      score += 100;
      hits.push(`tag:${tag}`);
    }
  }

  for (const phrase of card.phrases ?? []) {
    if (termHit(prompt, phrase)) {
      score += 45;
      hits.push(`phrase:${phrase}`);
      evidenceSpans.push(phrase);
    }
  }

  let keywordHits = 0;
  let strongKeywordHits = 0;
  for (const keyword of card.keywords ?? []) {
    if (keywordHit(prompt, keyword)) {
      keywordHits += 1;
      const broad = (language.broadKeywords ?? [])
        .some((value) => normalize(value) === normalize(keyword));
      if (!broad) strongKeywordHits += 1;
      hits.push(`keyword:${keyword}`);
    }
  }
  score += Math.min(keywordHits - strongKeywordHits, 3) * 6;
  if (strongKeywordHits > 0) {
    score += 30 + Math.min(strongKeywordHits - 1, 2) * 10;
  }

  let bestSimilarity = 0;
  let bestUtterance = null;
  for (const utterance of card.utterances ?? []) {
    const similarity = similarityAgainstSpans(promptSpans, utterance);
    if (similarity > bestSimilarity) {
      bestSimilarity = similarity;
      bestUtterance = utterance;
    }
  }
  if (bestSimilarity >= 0.24) {
    score += Math.round(bestSimilarity * 50);
    hits.push(`example:${bestUtterance}`);
  }

  let bestClauseScore = 0;
  let bestClauseHits = [];
  let bestClause = null;
  let negatedAction = null;
  for (const clause of promptClauses) {
    const action = anyHit(clause, card.actions);
    const object = anyHit(clause, card.objects);
    const context = anyHit(clause, card.contexts);
    const negated = !card.allowNegatedActions &&
      ((action && isTermNegated(clause, action)) ||
        (object && isTermNegated(clause, object)));
    if (negated) {
      negatedAction = action ?? object;
      continue;
    }
    let clauseScore = 0;
    if (action) clauseScore += 18;
    if (object) clauseScore += 18;
    if (context) clauseScore += 10;
    if (action && object) clauseScore += 25;
    if (action && object && context) clauseScore += 10;
    if (clauseScore > bestClauseScore) {
      bestClauseScore = clauseScore;
      bestClauseHits = [
        action ? `action:${action}` : null,
        object ? `object:${object}` : null,
        context ? `context:${context}` : null,
      ].filter(Boolean);
      bestClause = clause;
    }
  }
  score += bestClauseScore;
  hits.push(...bestClauseHits);
  if (bestClause) evidenceSpans.push(bestClause);
  if (negatedAction && bestClauseScore === 0) {
    score -= 100;
    hits.push(`negated:${negatedAction}`);
  }

  return {
    score: Math.max(0, score),
    hits: [...new Set(hits)],
    spans: [...new Set(evidenceSpans)].slice(0, 3),
  };
}

function hasSignal(prompt, signals) {
  return Boolean(anyHit(prompt, signals));
}

function isSocial(prompt, language) {
  const normalized = normalize(prompt);
  const tokenCount = words(normalized).length;
  if (tokenCount > 7) return false;
  const patterns = language.socialPatterns.map(normalize);
  if (patterns.includes(normalized)) return true;
  const socialWords = new Set(patterns.flatMap(words));
  return words(normalized).every(
    (token) => socialWords.has(token) || SOCIAL_FILLER_WORDS.has(token),
  );
}

export function sanitizeSpan(value) {
  return String(value)
    .replace(/\bhttps?:\/\/\S+/giu, "[url]")
    .replace(/\b[\w.+-]+@[\w.-]+\.[a-z]{2,}\b/giu, "[email]")
    .replace(/\b(?:sk|pk|rk|api)[-_][a-z0-9_-]{8,}\b/giu, "[secret]")
    .replace(
      /(^|[\s,;])([\w-]*(?:api[_-]?key|token|secret|password|passwd)[\w-]*|парол[\p{L}\p{N}_-]*)\s*(?:[:=]\s*|\s+)\S+/giu,
      "$1$2=[secret]",
    )
    .replace(/\b[a-z0-9_-]{32,}\b/giu, "[long-token]")
    .replace(/\s+/gu, " ")
    .trim()
    .slice(0, 160);
}

function recordCandidate(input, result, promptClauses) {
  if (input.source !== "user" || !result.advisorRequired || !result.substantive) return;
  const shortSpan = words(promptClauses[0] ?? "").slice(0, 7).join(" ");
  const span = sanitizeSpan(shortSpan);
  if (!span || span.length < 4) return;
  const cacheDir = path.join(hubRoot, ".cache", "task-router");
  const queuePath = path.join(cacheDir, "candidates.jsonl");
  fs.mkdirSync(cacheDir, { recursive: true });
  const hash = crypto.createHash("sha256").update(span).digest("hex").slice(0, 16);
  if (fs.existsSync(queuePath) &&
      fs.readFileSync(queuePath, "utf8").includes(`"hash":"${hash}"`)) return;
  const entry = {
    ts: new Date().toISOString(),
    hash,
    span,
    actualRoutes: result.matches.map((match) => match.Id),
    confidence: result.confidence,
    outcome: "unresolved",
  };
  fs.appendFileSync(queuePath, `${JSON.stringify(entry)}\n`, "utf8");
}

function unique(values) {
  return [...new Set(values.filter(Boolean))];
}

function routeMatch(card, scored, confidence) {
  return {
    Id: card.id,
    Label: card.label,
    Score: scored.score,
    Confidence: confidence,
    Hits: scored.hits,
    Spans: scored.spans,
    Mode: card.mode,
    Skill: card.skills.find((skill) => !skill.excluded)?.path ?? null,
    Skills: card.skills.filter((skill) => !skill.excluded).map((skill) => skill.path),
    Rule: card.rule,
    Mcp: card.mcps.map((mcp) => mcp.name),
    Commands: card.commands,
    Subagent: card.subagents,
    Note: card.note,
    Stage: card.defaultStage,
    RequiredActions: card.requiredActions,
  };
}

function decisionStage(prompt, topCard, language, advisorRequired, social) {
  if (social) return "social";
  if (advisorRequired) return "ambiguous";
  if (topCard?.defaultStage === "high-risk") return "high-risk";
  if (topCard?.defaultStage === "systemic") return "systemic";
  if (topCard?.defaultStage === "research") return "research";
  if (topCard?.id === "llm-council") return "tradeoff";
  return topCard?.defaultStage ?? "clear-small";
}

function requiredActions(
  prompt,
  matches,
  stage,
  advisorRequired,
  language,
  preflight,
) {
  const actions = advisorRequired
    ? []
    : matches.flatMap((match) => match.RequiredActions ?? []);
  actions.push(...(preflight.stages[stage]?.requiredActions ?? []));
  if (advisorRequired) actions.push("route_advisor");
  if (hasSignal(prompt, ["раньше", "прошл", "уже обсуждал", "мы решили"])) {
    actions.push("memory_read");
  }
  if (matches.some((match) => match.Id === "gitnexus-refactor") ||
      matches.some((match) => match.RequiredActions?.includes("gitnexus_impact"))) {
    actions.push("gitnexus_freshness");
  }
  return unique(actions);
}

export function resolveIntent(input, index = null) {
  const startedAt = performance.now();
  const capabilities = index ??
    JSON.parse(fs.readFileSync(indexPath, "utf8"));
  const prompt = boundedPrompt(input);
  const promptClauses = clauses(prompt);
  const promptSpans = promptClauses
    .flatMap((clause) => spansFor(clause))
    .slice(0, 160);
  const social = isSocial(prompt, capabilities.language);
  const taskSignal = hasSignal(prompt, capabilities.language.taskSignals);

  const candidates = capabilities.cards
    .map((card) => ({
      card,
      ...scoreCard(
        card,
        prompt,
        promptClauses,
        promptSpans,
        capabilities.language,
      ),
    }))
    .filter((candidate) => candidate.score > 0)
    .sort((left, right) => right.score - left.score);

  const threshold = 28;
  const qualified = social
    ? []
    : candidates.filter((candidate) => candidate.score >= threshold);
  const bestScore = qualified[0]?.score ?? candidates[0]?.score ?? 0;
  const secondScore = qualified[1]?.score ?? candidates[1]?.score ?? 0;
  const margin = bestScore - secondScore;
  const topConfidence = bestScore === 0
    ? 0
    : Math.min(1, (bestScore / 80) * (margin < 8 ? 0.72 : 1));
  const substantive = !social &&
    (taskSignal || words(prompt).length >= 5 || bestScore >= 10);
  const advisorRequired = substantive &&
    (!qualified.length || topConfidence < 0.58 || margin < 8);
  const multiIntentFloor = Math.max(threshold, (qualified[0]?.score ?? 0) * 0.65);
  const selected = qualified
    .filter((candidate, indexValue) => {
      if (indexValue === 0 || candidate.score >= multiIntentFloor) return true;
      const hitTypes = new Set(
        candidate.hits.map((hit) => hit.split(":", 1)[0]),
      );
      return hitTypes.has("tag") ||
        hitTypes.has("phrase") ||
        (hitTypes.has("action") && hitTypes.has("object")) ||
        (candidate.score >= 36 && hitTypes.has("keyword"));
    })
    .slice(0, capabilities.policy.maxRoutes);
  const matches = selected.map((candidate, indexValue) =>
    routeMatch(
      candidate.card,
      candidate,
      indexValue === 0 ? topConfidence : Math.min(1, candidate.score / 100),
    ),
  );
  const stage = decisionStage(
    prompt,
    selected[0]?.card,
    capabilities.language,
    advisorRequired,
    social,
  );
  const actions = requiredActions(
    prompt,
    matches,
    stage,
    advisorRequired,
    capabilities.language,
    capabilities.preflight,
  );
  const elapsedMs = performance.now() - startedAt;

  const result = {
    version: 1,
    source: input.source ?? "resolve",
    substantive,
    social,
    stage,
    confidence: Number(topConfidence.toFixed(3)),
    margin,
    advisorRequired,
    inject: matches.length > 0 || advisorRequired,
    matches,
    candidates: candidates.slice(0, 5).map((candidate) => ({
      id: candidate.card.id,
      score: candidate.score,
      hits: candidate.hits,
      spans: candidate.spans,
    })),
    requiredActions: actions,
    expectedReceipts: actions.map((action) => ({
      action,
      status: "required",
    })),
    latencyMs: Number(elapsedMs.toFixed(3)),
  };
  if (input.recordCandidate !== false) recordCandidate(input, result, promptClauses);
  return result;
}

async function main() {
  let raw = "";
  for await (const chunk of process.stdin) raw += chunk;
  const input = raw.trim() ? JSON.parse(raw) : {};
  const result = resolveIntent(input);
  process.stdout.write(`${JSON.stringify(result)}\n`);
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main().catch((error) => {
    process.stderr.write(`${error.message}\n`);
    process.exit(1);
  });
}
