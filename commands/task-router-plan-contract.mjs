import fs from "node:fs";
import path from "node:path";

const planArgument = process.argv[2];
if (!planArgument) {
  console.error("Usage: node commands/task-router-plan-contract.mjs <plan.md>");
  process.exit(2);
}

const planPath = path.resolve(process.cwd(), planArgument);
const text = fs.readFileSync(planPath, "utf8");
const checks = [
  ["problem/goal", /(?:цель|проблем|overview|goal)/iu],
  ["verified facts", /(?:найденные факты|факты|evidence|зафиксированные решения)/iu],
  ["options/trade-offs", /(?:вариант|альтернатив|trade-?off|зафиксированные решения)/iu],
  ["decision", /(?:решение|choice|decision)/iu],
  ["architecture/flows", /(?:архитектур|поток|flowchart|data flow)/iu],
  ["risks", /(?:риск|risk)/iu],
  ["definition of done", /^#{1,3}\s+.*(?:\bDoD\b|definition of done|итоговый DoD)/imu],
];

const missing = checks
  .filter(([, pattern]) => !pattern.test(text))
  .map(([name]) => name);
const workHeadings = [...text.matchAll(/^##\s+(?:E|S|WP)\d+\b.*$/gimu)];
if (workHeadings.length < 2) missing.push("WBS/tasks");
if (workHeadings.length >= 2) {
  const unverified = workHeadings.filter((heading, index) => {
    const start = heading.index + heading[0].length;
    const end = workHeadings[index + 1]?.index ?? text.length;
    return !/(?:verify:|`verify`|провер)/iu.test(text.slice(start, end));
  });
  if (unverified.length) missing.push("leaf verification");
}
if (missing.length) {
  console.error(`plan contract failed: ${missing.join(", ")}`);
  process.exit(1);
}
console.log(`plan contract ok: ${path.basename(planPath)}`);
