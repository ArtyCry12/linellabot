#!/usr/bin/env node
/**
 * Search local 21st catalog: node search-catalog.mjs <query> [--limit 10]
 */
import { readFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..", "..", "..");
const CATALOG = join(ROOT, "lib", "21st", "search_results.json");
const ENSURE = join(__dirname, "ensure-library.mjs");

function parseArgs(argv) {
  const positional = [];
  let limit = 10;
  for (let i = 2; i < argv.length; i++) {
    if (argv[i] === "--limit" && argv[i + 1]) {
      limit = Number(argv[++i]) || 10;
    } else {
      positional.push(argv[i]);
    }
  }
  return { query: positional.join(" ").toLowerCase().trim(), limit };
}

function loadCatalog() {
  if (!existsSync(CATALOG)) {
    spawnSync(process.execPath, [ENSURE], { stdio: "inherit" });
  }
  if (!existsSync(CATALOG)) {
    console.error("Catalog not found. Run ensure-library.mjs first.");
    process.exit(1);
  }
  return JSON.parse(readFileSync(CATALOG, "utf8"));
}

function scoreEntry(entry, terms) {
  const blob = [
    entry.component_data?.name,
    entry.component_data?.description,
    entry.component_user_data?.username,
    entry.name,
  ]
    .filter(Boolean)
    .join(" ")
    .toLowerCase();
  let score = 0;
  for (const t of terms) {
    if (blob.includes(t)) score += t.length > 3 ? 2 : 1;
  }
  score += Math.min((entry.usage_count || 0) / 500, 5);
  return score;
}

function main() {
  const { query, limit } = parseArgs(process.argv);
  if (!query) {
    console.error("Usage: node search-catalog.mjs <query> [--limit N]");
    process.exit(1);
  }
  const data = loadCatalog();
  const terms = query.split(/\s+/).filter(Boolean);
  const ranked = (data.results || [])
    .map((entry) => ({ entry, score: scoreEntry(entry, terms) }))
    .filter((x) => x.score > 0)
    .sort((a, b) => b.score - a.score)
    .slice(0, limit);

  if (ranked.length === 0) {
    console.log("No matches. Try broader terms or browse https://21st.dev");
    process.exit(0);
  }

  for (const { entry } of ranked) {
    const cd = entry.component_data || {};
    const user = entry.component_user_data?.username || "?";
    console.log("---");
    console.log(`${cd.name || entry.name} (@${user})`);
    console.log(`usage: ${entry.usage_count ?? "?"}`);
    console.log(`install: ${cd.install_command || "(none)"}`);
    if (cd.description) console.log(cd.description.split("\n")[0]);
    if (entry.preview_url) console.log(`preview: ${entry.preview_url}`);
  }
}

main();
