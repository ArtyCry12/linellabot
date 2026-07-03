#!/usr/bin/env node
/**
 * Dev OS status — source counts, domain coverage, gate state.
 * Usage: node commands/dev-os-status.mjs
 */
import { readdirSync, readFileSync, statSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const HUB = join(dirname(fileURLToPath(import.meta.url)), "..");
const DEV_OS = join(HUB, "ai-tracking", "dev-os");
const SOURCES = join(DEV_OS, "research", "sources");
const DOMAINS = join(DEV_OS, "research", "domains");
const UNDERSTANDING = join(DEV_OS, "synthesis", "understanding.md");

function parseFrontmatter(text) {
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!m) return {};
  const out = {};
  for (const raw of m[1].split(/\r?\n/)) {
    const line = raw.trim();
    if (!line) continue;
    const kv = line.match(/^([\w-]+):\s*(.+)$/);
    if (kv) {
      let v = kv[2].trim();
      if (v === "true") v = true;
      else if (v === "false") v = false;
      out[kv[1]] = v;
    }
  }
  return out;
}

function listSourceCards() {
  if (!existsSync(SOURCES)) return [];
  return readdirSync(SOURCES).filter(
    (f) => f.endsWith(".md") && f !== "_template.md"
  );
}

function countSourcesByDomain(cards) {
  const byDomain = {};
  for (const file of cards) {
    const text = readFileSync(join(SOURCES, file), "utf8");
    const fm = parseFrontmatter(text);
    const domain = fm.domain ?? "unknown";
    byDomain[domain] = (byDomain[domain] ?? 0) + 1;
  }
  return byDomain;
}

function listDomains() {
  if (!existsSync(DOMAINS)) return [];
  return readdirSync(DOMAINS, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name);
}

function domainHasFindings(name) {
  const p = join(DOMAINS, name, "findings.md");
  if (!existsSync(p)) return false;
  const text = readFileSync(p, "utf8");
  // Require at least one populated source row (http URL or source_id pattern)
  return /https?:\/\//.test(text) || /\|\s*20\d{2}-/.test(text);
}

function gateStatus() {
  if (!existsSync(UNDERSTANDING)) {
    return { status: "missing", open: false };
  }
  const fm = parseFrontmatter(readFileSync(UNDERSTANDING, "utf8"));
  const complete =
    fm.status === "research_complete" || fm.research_complete === true;
  return {
    status: fm.status ?? "unknown",
    phase: fm.phase ?? "?",
    phase_4_closed: fm.phase_4_closed === true,
    autonomy_mode: fm.autonomy_mode ?? "unknown",
    sprint_3: fm.sprint_3 ?? "?",
    sprint_4: fm.sprint_4 ?? "?",
    sprint_5: fm.sprint_5 ?? "?",
    corpus_domains: fm.corpus_domains ?? "?",
    design_candidate: fm.design_candidate ?? fm.decision ?? "?",
    research_complete: complete,
    open: complete,
    structural_emergence: fm.structural_emergence ?? "unknown",
    version: fm.version ?? "?",
  };
}

function main() {
  const cards = listSourceCards();
  const byDomain = countSourcesByDomain(cards);
  const allDomains = listDomains();
  const gate = gateStatus();

  const sprint1 = ["multi-agent", "context-engineering", "memory-systems"];
  const sprint3 = ["optimization", "security"];
  const sprint4 = ["automation", "prompt-systems"];
  const sprint3Ready = sprint3.every(
    (d) => (byDomain[d] ?? 0) >= 3 && domainHasFindings(d)
  );
  const sprint4Ready = sprint4.every(
    (d) => (byDomain[d] ?? 0) >= 3 && domainHasFindings(d)
  );
  const sprint5Ready =
    (byDomain["creative-systems"] ?? 0) >= 3 &&
    domainHasFindings("creative-systems");
  const corpusComplete = allDomains.every(
    (d) => (byDomain[d] ?? 0) >= 3 && domainHasFindings(d)
  );
  const sprint1Ready = sprint1.every(
    (d) => (byDomain[d] ?? 0) >= 3 && domainHasFindings(d)
  );

  console.log("=== Cursor AI Dev OS — Status ===\n");
  console.log(`Corpus: ${DEV_OS}`);
  console.log(`Source cards: ${cards.length} (excl. _template.md)\n`);

  console.log("Gate:");
  console.log(`  status: ${gate.status}`);
  console.log(`  phase: ${gate.phase}`);
  console.log(`  research_complete: ${gate.research_complete}`);
  console.log(`  bootstrap gate OPEN: ${gate.open}`);
  console.log(`  structural_emergence: ${gate.structural_emergence}`);
  console.log(`  understanding version: ${gate.version}`);
  console.log(`  phase_4_closed: ${gate.phase_4_closed}`);
  console.log(`  design_candidate: ${gate.design_candidate}`);
  console.log(`  autonomy_mode: ${gate.autonomy_mode}`);
  console.log(`  sprint_3: ${gate.sprint_3}`);
  console.log(`  sprint_4: ${gate.sprint_4}`);
  console.log(`  sprint_5: ${gate.sprint_5 ?? "?"}`);
  console.log(`  corpus_domains: ${gate.corpus_domains}/10`);

  const researchAgent = join(HUB, "agents", "dev-os-research.md");
  const structureDoc = join(DEV_OS, "synthesis", "structure-emergence.md");
  const designDoc = join(DEV_OS, "synthesis", "design-candidates.md");
  let phase4Status = "unknown";
  if (existsSync(designDoc)) {
    const dfm = parseFrontmatter(readFileSync(designDoc, "utf8"));
    phase4Status = dfm.status ?? "unknown";
  }
  console.log("\nStructure:");
  console.log(`  dev-os-research agent: ${existsSync(researchAgent) ? "yes" : "no"}`);
  console.log(`  structure-emergence.md: ${existsSync(structureDoc) ? "yes" : "no"}`);
  console.log(`  design-candidates (Phase 4): ${phase4Status}`);
  console.log("");

  console.log("Domain coverage:");
  console.log("  domain                  sources  findings  compare-ready (≥3)");
  for (const d of allDomains.sort()) {
    const n = byDomain[d] ?? 0;
    const findings = domainHasFindings(d) ? "yes" : "no";
    const compare = n >= 3 ? "yes" : "no";
    console.log(
      `  ${d.padEnd(24)} ${String(n).padStart(3)}      ${findings.padEnd(8)}  ${compare}`
    );
  }

  console.log(`\nCorpus complete (10/10): ${corpusComplete}`);

  console.log("\nSprint 5:");
  console.log(`  complete: ${sprint5Ready}`);
  console.log(`    creative-systems: ${byDomain["creative-systems"] ?? 0} sources`);

  console.log("\nSprint 4 (domains 9–10 partial):");
  console.log(`  complete: ${sprint4Ready}`);
  for (const d of sprint4) {
    console.log(`    ${d}: ${byDomain[d] ?? 0} sources`);
  }

  console.log("\nSprint 3 (domains 7–8):");
  console.log(`  complete: ${sprint3Ready}`);
  for (const d of sprint3) {
    console.log(`    ${d}: ${byDomain[d] ?? 0} sources`);
  }

  console.log("\nSprint 1 (domains 1–3):");
  console.log(`  complete: ${sprint1Ready}`);
  for (const d of sprint1) {
    console.log(`    ${d}: ${byDomain[d] ?? 0} sources`);
  }

  console.log("\nLayers:");
  for (const layer of [
    "knowledge-map.md",
    "best-practices.md",
    "anti-patterns.md",
    "emerging-trends.md",
  ]) {
    const p = join(DEV_OS, "layers", layer);
    const body = existsSync(p) ? readFileSync(p, "utf8") : "";
    const populated =
      (body.includes("### ") || body.includes("| Approach |")) &&
      !body.includes("*(Populated during");
    console.log(`  ${layer}: ${populated ? "populated" : "template"}`);
  }

  const decisions = join(DEV_OS, "decisions", "log.md");
  const decCount = existsSync(decisions)
    ? (readFileSync(decisions, "utf8").match(/^## DEC-/gm) ?? []).length
    : 0;
  console.log(`\nDecision log entries: ${decCount}`);

  if (!gate.open) {
    console.log("\n⚠ Gate CLOSED — block new agents/, always-on rules, architecture commits");
  } else {
    console.log("\n✓ Gate OPEN — structural work allowed (see structural_emergence note)");
  }

  process.exit(0);
}

main();
