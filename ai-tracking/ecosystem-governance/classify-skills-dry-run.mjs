/**
 * Skills taxonomy dry-run — NO moves, NO deletes.
 * Output: ai-tracking/ecosystem-governance/skills-classify-dry-run.{json,md}
 */
import fs from "node:fs";
import path from "node:path";

const HUB = "C:/Users/artyo/.cursor";
const OUT_DIR = path.join(HUB, "ai-tracking/ecosystem-governance");
const SKILLS = path.join(HUB, "skills");
const INDEX = path.join(SKILLS, "_INDEX.md");
const ROUTES = path.join(HUB, "lib/task-router/routes.json");
const REGISTRY = path.join(OUT_DIR, "registry.json");

const CORE_NAMES = new Set([
  "ecosystem-architect",
  "project-squad",
  "markitdown",
  "ponytail",
  "caveman",
  "security-hub",
  "cybersecurity",
  "open-design",
  "seo-geo",
  "clone-website",
  "task-router",
  "dev-os",
  "find-skills",
  "prompt-engineering-coach",
  "openrouter-free",
  "rtk",
  "user-profile",
]);

const EXPERIMENTAL_HINTS = [
  "babyagi",
  "crew-ai",
  "llm-council",
  "graphify",
  "pixel-office",
  "quiz-channel",
];

const FALLBACK_HINTS = ["fallback", "-alt", "alternate"];

function stripBom(s) {
  return s.replace(/^\uFEFF/, "");
}

function walkSkillMd(root, bucket, acc, depth = 0) {
  if (!fs.existsSync(root) || depth > 6) return;
  let entries;
  try {
    entries = fs.readdirSync(root, { withFileTypes: true });
  } catch {
    return;
  }
  for (const e of entries) {
    if (e.name === "node_modules" || e.name === ".git") continue;
    const full = path.join(root, e.name);
    if (e.isDirectory()) {
      const skillMd = path.join(full, "SKILL.md");
      if (fs.existsSync(skillMd)) {
        const rel = path.relative(HUB, skillMd).replace(/\\/g, "/");
        const name = e.name;
        let size = 0;
        try {
          size = fs.statSync(skillMd).size;
        } catch {}
        acc.push({ name, path: rel, dir: path.relative(HUB, full).replace(/\\/g, "/"), bucket, sizeBytes: size });
      }
      // descend into known nests only for archive/od-repo/library
      if (
        e.name === "_archive" ||
        e.name === "repo" ||
        e.name === "library" ||
        e.name === "template" ||
        depth === 0
      ) {
        walkSkillMd(full, bucket, acc, depth + 1);
      } else if (bucket === "hub-nested" || bucket === "archive" || bucket === "od-repo") {
        walkSkillMd(full, bucket, acc, depth + 1);
      }
    }
  }
}

function parseIndexNames(md) {
  const names = new Set();
  for (const line of md.split(/\r?\n/)) {
    const m = line.match(/^\| ([^|]+) \| `([^`]+)`/);
    if (!m) continue;
    const name = m[1].trim();
    const p = m[2].trim();
    if (name && !name.startsWith("-")) names.add(name);
    const base = path.basename(path.dirname(p));
    if (base && base !== "skills" && base !== "skills-cursor") names.add(base);
  }
  return names;
}

function routeSkillRefs(routes) {
  const refs = new Set();
  const paths = new Set();
  for (const r of routes.routes || routes || []) {
    if (r.skill) {
      paths.add(String(r.skill).replace(/\\/g, "/"));
      const parts = String(r.skill).split("/");
      const i = parts.indexOf("skills");
      if (i >= 0 && parts[i + 1]) refs.add(parts[i + 1]);
      if (parts.includes("dev-os") && parts[parts.length - 2]) {
        // e.g. skills/dev-os/memory/SKILL.md
        refs.add(parts[parts.length - 2] === "dev-os" ? "dev-os" : `dev-os-${parts[parts.length - 2]}`);
      }
    }
    if (Array.isArray(r.skills)) {
      for (const s of r.skills) {
        paths.add(String(s).replace(/\\/g, "/"));
        const parts = String(s).split("/");
        const i = parts.indexOf("skills");
        if (i >= 0 && parts[i + 1]) refs.add(parts[i + 1]);
      }
    }
  }
  return { refs, paths };
}

function classify(item, ctx) {
  const n = item.name.toLowerCase();
  const reasons = [];

  if (item.bucket === "archive" || item.dir.includes("skills/_archive")) {
    return { tier: "DEPRECATED", action: "already_archived", reasons: ["under skills/_archive"] };
  }
  if (item.bucket === "od-repo" || item.dir.includes("open-design/repo")) {
    return {
      tier: "EXPERIMENTAL",
      action: "keep_on_disk_not_index",
      reasons: ["Open Design template/repo — not active hub skill"],
    };
  }
  if (item.dir.includes("/library/") || item.dir.includes("/template/")) {
    return {
      tier: "SECONDARY",
      action: "library_keep",
      reasons: ["library/template nest — secondary pack"],
    };
  }

  if (CORE_NAMES.has(item.name) || CORE_NAMES.has(n)) {
    reasons.push("CORE allowlist");
    return { tier: "CORE", action: "keep_active", reasons };
  }

  if (ctx.routeRefs.has(item.name) || ctx.routePaths.has(item.path)) {
    reasons.push("referenced in routes.json");
    return { tier: "SECONDARY", action: "keep_routed", reasons };
  }

  if (EXPERIMENTAL_HINTS.some((h) => n.includes(h))) {
    reasons.push("experimental hint");
    return { tier: "EXPERIMENTAL", action: "keep_experimental", reasons };
  }

  if (FALLBACK_HINTS.some((h) => n.includes(h))) {
    reasons.push("fallback naming");
    return { tier: "FALLBACK", action: "review_fallback", reasons };
  }

  if (ctx.indexNames.has(item.name)) {
    reasons.push("listed in skills/_INDEX.md");
    if (item.bucket === "hub-top" && !ctx.routeRefs.has(item.name) && !CORE_NAMES.has(item.name)) {
      reasons.push("not referenced in routes.json — soft quarantine review");
      return { tier: "SECONDARY", action: "quarantine_soft_candidate", reasons };
    }
    return { tier: "SECONDARY", action: "keep_indexed", reasons };
  }

  // hub top-level with SKILL.md but not indexed and not routed → quarantine candidate
  if (item.bucket === "hub-top") {
    reasons.push("hub-top SKILL.md not in _INDEX and not in routes");
    return { tier: "DEPRECATED", action: "quarantine_candidate", reasons };
  }

  reasons.push("unclassified nest");
  return { tier: "EXPERIMENTAL", action: "review", reasons };
}

function main() {
  const indexMd = fs.existsSync(INDEX) ? fs.readFileSync(INDEX, "utf8") : "";
  const indexNames = parseIndexNames(indexMd);
  const routesRaw = JSON.parse(stripBom(fs.readFileSync(ROUTES, "utf8")));
  const { refs: routeRefs, paths: routePaths } = routeSkillRefs(routesRaw);
  let registry = {};
  try {
    registry = JSON.parse(stripBom(fs.readFileSync(REGISTRY, "utf8")));
  } catch {}

  const items = [];
  // hub top-level only (direct children of skills/ with SKILL.md)
  for (const e of fs.readdirSync(SKILLS, { withFileTypes: true })) {
    if (!e.isDirectory()) continue;
    if (e.name.startsWith("_")) continue;
    const full = path.join(SKILLS, e.name);
    const skillMd = path.join(full, "SKILL.md");
    if (fs.existsSync(skillMd)) {
      items.push({
        name: e.name,
        path: path.relative(HUB, skillMd).replace(/\\/g, "/"),
        dir: path.relative(HUB, full).replace(/\\/g, "/"),
        bucket: "hub-top",
        sizeBytes: fs.statSync(skillMd).size,
      });
    }
  }
  // archive + od-repo (optional counts)
  const archiveRoot = path.join(SKILLS, "_archive");
  if (fs.existsSync(archiveRoot)) walkSkillMd(archiveRoot, "archive", items, 0);
  const odRepo = path.join(SKILLS, "open-design", "repo");
  if (fs.existsSync(odRepo)) walkSkillMd(odRepo, "od-repo", items, 0);

  const ctx = { indexNames, routeRefs, routePaths };
  const classified = items.map((it) => {
    const c = classify(it, ctx);
    return { ...it, ...c };
  });

  const byTier = {};
  const byAction = {};
  for (const c of classified) {
    byTier[c.tier] = (byTier[c.tier] || 0) + 1;
    byAction[c.action] = (byAction[c.action] || 0) + 1;
  }

  const quarantineCandidates = classified.filter((c) => c.action === "quarantine_candidate");
  const softCandidates = classified.filter((c) => c.action === "quarantine_soft_candidate");
  const hubTop = classified.filter((c) => c.bucket === "hub-top");

  const report = {
    generatedAt: new Date().toISOString(),
    dryRun: true,
    moved: false,
    scope: "hub-top SKILL.md + archive/od-repo inventory counts",
    counts: {
      totalScanned: classified.length,
      hubTop: hubTop.length,
      byTier,
      byAction,
      quarantineCandidates: quarantineCandidates.length,
      quarantineSoftCandidates: softCandidates.length,
      indexNames: indexNames.size,
      routeSkillRefs: routeRefs.size,
    },
    keepFromRegistry: registry.keep || [],
    quarantineCandidates: quarantineCandidates.map((c) => ({
      name: c.name,
      path: c.path,
      reasons: c.reasons,
      proposedDest: `skills/_quarantine/${c.name}/`,
    })),
    quarantineSoftCandidates: softCandidates.map((c) => ({
      name: c.name,
      path: c.path,
      reasons: c.reasons,
      proposedDest: `skills/_quarantine/${c.name}/`,
    })),
    hubTopByTier: hubTop.reduce((acc, c) => {
      (acc[c.tier] ||= []).push(c.name);
      return acc;
    }, {}),
    items: classified,
  };

  fs.writeFileSync(path.join(OUT_DIR, "skills-classify-dry-run.json"), JSON.stringify(report, null, 2));

  const md = [];
  md.push("# Skills classify — dry-run");
  md.push("");
  md.push(`**When:** ${report.generatedAt}`);
  md.push("**Moved:** no (dry-run only)");
  md.push("");
  md.push("## Counts");
  md.push("");
  md.push(`| Metric | N |`);
  md.push(`|--------|--:|`);
  md.push(`| Total scanned | ${report.counts.totalScanned} |`);
  md.push(`| Hub-top with SKILL.md | ${report.counts.hubTop} |`);
  md.push(`| Quarantine candidates (hard) | ${report.counts.quarantineCandidates} |`);
  md.push(`| Quarantine soft (indexed, not routed) | ${report.counts.quarantineSoftCandidates} |`);
  md.push(`| _INDEX names | ${report.counts.indexNames} |`);
  md.push(`| Route skill refs | ${report.counts.routeSkillRefs} |`);
  md.push("");
  md.push("### By tier");
  md.push("");
  for (const [k, v] of Object.entries(byTier).sort()) md.push(`- **${k}**: ${v}`);
  md.push("");
  md.push("### Hub-top by tier (names)");
  md.push("");
  for (const [tier, names] of Object.entries(report.hubTopByTier).sort()) {
    md.push(`**${tier}** (${names.length}): ${names.sort().join(", ")}`);
    md.push("");
  }
  md.push("## Quarantine candidates — hard (NOT applied)");
  md.push("");
  if (!quarantineCandidates.length) {
    md.push("_None — every hub-top skill is in `_INDEX` or routes or CORE._");
  } else {
    md.push("| Name | Proposed dest | Why |");
    md.push("|------|---------------|-----|");
    for (const c of quarantineCandidates.sort((a, b) => a.name.localeCompare(b.name))) {
      md.push(`| \`${c.name}\` | \`skills/_quarantine/${c.name}/\` | ${c.reasons.join("; ")} |`);
    }
  }
  md.push("");
  md.push("## Quarantine soft — indexed but not in routes (NOT applied)");
  md.push("");
  md.push("Candidates for Boss review. Safer first batch than touching routed skills.");
  md.push("");
  if (!softCandidates.length) {
    md.push("_None._");
  } else {
    md.push("| Name | Proposed dest | Why |");
    md.push("|------|---------------|-----|");
    for (const c of softCandidates.sort((a, b) => a.name.localeCompare(b.name))) {
      md.push(`| \`${c.name}\` | \`skills/_quarantine/${c.name}/\` | ${c.reasons.join("; ")} |`);
    }
  }
  md.push("");
  md.push("## Already DEPRECATED on disk");
  md.push("");
  md.push(`\`skills/_archive/\` — **${byTier.DEPRECATED || 0}** SKILL.md (leave; already out of active index).`);
  md.push("");
  md.push(`Open Design \`repo/\` templates — **${byTier.EXPERIMENTAL || 0}** tagged EXPERIMENTAL / keep_on_disk_not_index (do not quarantine into hub trash; leave under OD).`);
  md.push("");
  md.push("## Next gate");
  md.push("");
  md.push("Boss: **APPLY soft quarantine** (all or name list) → move into `skills/_quarantine/`.");
  md.push("Until then nothing is moved.");
  md.push("");

  fs.writeFileSync(path.join(OUT_DIR, "skills-classify-dry-run.md"), md.join("\n"));

  // update registry pointer (no entity mass-write)
  try {
    registry.updatedAt = report.generatedAt;
    registry.lastClassifyDryRun = {
      path: "ai-tracking/ecosystem-governance/skills-classify-dry-run.json",
      quarantineCandidates: quarantineCandidates.length,
      quarantineSoftCandidates: softCandidates.length,
      hubTop: hubTop.length,
    };
    fs.writeFileSync(REGISTRY, JSON.stringify(registry, null, 2));
  } catch {}

  console.log(
    JSON.stringify(
      {
        ok: true,
        hubTop: hubTop.length,
        quarantineCandidates: quarantineCandidates.length,
        quarantineSoftCandidates: softCandidates.length,
        byTier,
        outMd: "ai-tracking/ecosystem-governance/skills-classify-dry-run.md",
      },
      null,
      2
    )
  );
}

main();
