import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { resolveIntent } from "../lib/task-router/router-core.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const hubRoot = path.resolve(here, "..");
const corpusPath = path.join(hubRoot, "lib", "task-router", "golden-corpus.json");
const indexPath = path.join(
  hubRoot,
  "lib",
  "task-router",
  "capabilities.generated.json",
);

const corpus = JSON.parse(fs.readFileSync(corpusPath, "utf8"));
const index = JSON.parse(fs.readFileSync(indexPath, "utf8"));
const failures = [];
const latencies = [];
let routeCases = 0;
let top1Hits = 0;
let top2Hits = 0;
let stageHits = 0;
let advisorCases = 0;
let advisorHits = 0;
let negatives = 0;
let falsePositives = 0;

for (const testCase of corpus.cases) {
  const result = resolveIntent(
    {
      prompt: testCase.prompt,
      source: "test",
      recordCandidate: false,
    },
    index,
  );
  const ids = result.matches.map((match) => match.Id);
  latencies.push(result.latencyMs);

  if (testCase.expect.length) {
    routeCases += 1;
    const top1 = testCase.expect.includes(ids[0]);
    const top2 = ids.slice(0, 2).some((id) => testCase.expect.includes(id));
    if (top1) top1Hits += 1;
    if (top2) top2Hits += 1;
    if (!top1 && top2) {
      failures.push(
        `top1: "${testCase.prompt}" expected ${testCase.expect.join("|")} got ${ids[0] || "(none)"}`,
      );
    }
    if (!top2) {
      failures.push(
        `route: "${testCase.prompt}" expected ${testCase.expect.join("|")} got ${ids.join("|") || "(none)"}`,
      );
    }
    if (testCase.all &&
        !testCase.expect.every((id) => ids.slice(0, 2).includes(id))) {
      failures.push(
        `multi-intent: "${testCase.prompt}" expected all ${testCase.expect.join("|")} got ${ids.join("|")}`,
      );
    }
  }

  for (const rejected of testCase.reject ?? []) {
    if (ids.includes(rejected) || result.requiredActions.includes(rejected)) {
      failures.push(
        `rejected: "${testCase.prompt}" unexpectedly used ${rejected}`,
      );
    }
  }

  if (testCase.stage) {
    if (result.stage === testCase.stage) stageHits += 1;
    else {
      failures.push(
        `stage: "${testCase.prompt}" expected ${testCase.stage} got ${result.stage}`,
      );
    }
  }

  const expectedAdvisor = typeof testCase.advisor === "boolean"
    ? testCase.advisor
    : testCase.expect.length > 0
      ? false
      : null;
  if (expectedAdvisor !== null) {
    advisorCases += 1;
    if (result.advisorRequired === expectedAdvisor) advisorHits += 1;
    else {
      failures.push(
        `advisor: "${testCase.prompt}" expected ${expectedAdvisor} got ${result.advisorRequired}`,
      );
    }
  }

  if (testCase.negative) {
    negatives += 1;
    if (result.inject) {
      falsePositives += 1;
      failures.push(`false positive: "${testCase.prompt}" -> ${ids.join("|")}`);
    }
  }
}

latencies.sort((left, right) => left - right);
const percentile = (values, p) =>
  values[Math.min(values.length - 1, Math.ceil(values.length * p) - 1)] ?? 0;
const percent = (part, total) => total ? (part / total) * 100 : 100;
const top1Rate = percent(top1Hits, routeCases);
const top2Rate = percent(top2Hits, routeCases);
const falsePositiveRate = percent(falsePositives, negatives);
const stageRate = percent(stageHits, corpus.cases.length);
const advisorRate = percent(advisorHits, advisorCases);
const p95 = percentile(latencies, 0.95);

console.log(`cases=${corpus.cases.length}`);
console.log(`top1=${top1Rate.toFixed(1)}% (${top1Hits}/${routeCases})`);
console.log(`top2=${top2Rate.toFixed(1)}% (${top2Hits}/${routeCases})`);
console.log(`falsePositive=${falsePositiveRate.toFixed(1)}% (${falsePositives}/${negatives})`);
console.log(`stage=${stageRate.toFixed(1)}%`);
console.log(`advisor=${advisorRate.toFixed(1)}%`);
console.log(`latencyP95=${p95.toFixed(1)}ms`);

for (const failure of failures.slice(0, 30)) console.error(`FAIL ${failure}`);
if (failures.length > 30) console.error(`FAIL ... ${failures.length - 30} more`);

const qualityPassed =
  failures.length === 0 &&
  corpus.cases.length >= 60 &&
  top1Rate >= 85 &&
  top2Rate >= 95 &&
  falsePositiveRate <= 5 &&
  p95 <= index.policy.localLatencyBudgetMs &&
  stageRate >= 95 &&
  advisorRate === 100;

if (!qualityPassed) process.exit(1);
