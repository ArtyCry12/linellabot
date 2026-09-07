import { spawnSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { sanitizeSpan } from "../lib/task-router/router-core.mjs";

const here = path.dirname(fileURLToPath(import.meta.url));
const hubRoot = path.resolve(here, "..");
const queuePath = path.join(hubRoot, ".cache", "task-router", "candidates.jsonl");
const overridesPath = path.join(
  hubRoot,
  "lib",
  "task-router",
  "capability-overrides.json",
);
const apply = process.argv.includes("--apply");

if (!fs.existsSync(queuePath)) {
  console.log("No candidate queue.");
  process.exit(0);
}

const entries = fs.readFileSync(queuePath, "utf8")
  .split(/\r?\n/)
  .filter(Boolean)
  .map((line) => JSON.parse(line));
const eligible = [
  ...new Map(
    entries
      .filter((entry) =>
        entry.outcome === "confirmed" &&
        entry.expectedRoute &&
        entry.span &&
        sanitizeSpan(entry.span) === entry.span,
      )
      .map((entry) => [`${entry.expectedRoute}:${entry.span}`, entry]),
  ).values(),
];

if (!eligible.length) {
  console.log("No confirmed candidates. Set outcome=confirmed and expectedRoute first.");
  process.exit(0);
}

for (const entry of eligible) {
  console.log(`${entry.expectedRoute}: ${entry.span}`);
}
if (!apply) {
  console.log("Dry run. Re-run with --apply after review.");
  process.exit(0);
}

const before = fs.readFileSync(overridesPath, "utf8");
const overrides = JSON.parse(before);
for (const entry of eligible) {
  const overlay = overrides.intentOverlays[entry.expectedRoute];
  if (!overlay) throw new Error(`Unknown route: ${entry.expectedRoute}`);
  overlay.utterances ??= [];
  if (!overlay.utterances.includes(entry.span)) overlay.utterances.push(entry.span);
}
fs.writeFileSync(overridesPath, `${JSON.stringify(overrides, null, 2)}\n`, "utf8");

const build = spawnSync(
  process.execPath,
  [path.join(hubRoot, "lib", "task-router", "build-capability-index.mjs")],
  { cwd: hubRoot, encoding: "utf8" },
);
const evaluation = spawnSync(
  process.execPath,
  [path.join(hubRoot, "commands", "task-router-eval.mjs")],
  { cwd: hubRoot, encoding: "utf8" },
);
if (build.status !== 0 || evaluation.status !== 0) {
  fs.writeFileSync(overridesPath, before, "utf8");
  spawnSync(
    process.execPath,
    [path.join(hubRoot, "lib", "task-router", "build-capability-index.mjs")],
    { cwd: hubRoot },
  );
  process.stderr.write(build.stderr ?? "");
  process.stderr.write(evaluation.stderr ?? "");
  throw new Error("Promotion failed regression checks; overrides restored.");
}
console.log(`Promoted ${eligible.length} candidate(s); regression checks passed.`);
