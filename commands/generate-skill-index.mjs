#!/usr/bin/env node
/**
 * Generate skills/_INDEX.md from hub skills/ plus blocks/<id>/skills (root SKILL.md only).
 * Skips: library, template, repo, _archive, _quarantine, node_modules, .git
 */
import { readdirSync, readFileSync, statSync, writeFileSync, existsSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const HUB = join(fileURLToPath(new URL('.', import.meta.url)), '..');
const OUT = join(HUB, 'skills', '_INDEX.md');
const SKIP_DIR = new Set([
  'node_modules', 'library', 'template', 'repo', '.git', '_archive', '_quarantine', '.cache',
]);

function readMeta(p, rel) {
  const text = readFileSync(p, 'utf8');
  const name = text.match(/^name:\s*(.+)$/m)?.[1]?.trim() || rel;
  const desc = text.match(/^description:\s*(.+)$/m)?.[1]?.trim()
    || text.match(/^description:\s*>-\s*\n([\s\S]*?)(?=\n\w|\n---)/m)?.[1]?.replace(/\n\s+/g, ' ').trim()
    || '(no description)';
  return { name, rel, desc: desc.slice(0, 120) };
}

function addRootSkill(dir, relDir, rows, group) {
  const skill = join(dir, 'SKILL.md');
  if (!existsSync(skill)) return;
  const rel = relative(HUB, skill).replace(/\\/g, '/');
  rows.push({ ...readMeta(skill, rel), group });
}

function walkHubSkills(root) {
  const rows = [];
  if (!existsSync(root)) return rows;
  for (const ent of readdirSync(root, { withFileTypes: true })) {
    if (!ent.isDirectory()) continue;
    if (SKIP_DIR.has(ent.name) || ent.name.startsWith('_')) {
      if (ent.name === '_quarantine' || ent.name === '_archive') continue;
    }
    addRootSkill(join(root, ent.name), ent.name, rows, 'hub');
  }
  return rows;
}

function walkBlocks(blocksRoot) {
  const rows = [];
  if (!existsSync(blocksRoot)) return rows;
  for (const block of readdirSync(blocksRoot, { withFileTypes: true })) {
    if (!block.isDirectory()) continue;
    const skillsDir = join(blocksRoot, block.name, 'skills');
    if (!existsSync(skillsDir)) continue;
    for (const sk of readdirSync(skillsDir, { withFileTypes: true })) {
      if (!sk.isDirectory()) continue;
      addRootSkill(join(skillsDir, sk.name), sk.name, rows, `block:${block.name}`);
    }
  }
  return rows;
}

function walkSkillsCursor(root) {
  const rows = [];
  if (!existsSync(root)) return rows;
  for (const ent of readdirSync(root, { withFileTypes: true })) {
    if (!ent.isDirectory()) continue;
    addRootSkill(join(root, ent.name), ent.name, rows, 'skills-cursor');
  }
  return rows;
}

const all = [
  ...walkHubSkills(join(HUB, 'skills')),
  ...walkBlocks(join(HUB, 'blocks')),
  ...walkSkillsCursor(join(HUB, 'skills-cursor')),
].sort((a, b) => a.rel.localeCompare(b.rel));

const lines = [
  '# Skills index (auto-generated)',
  '',
  `Generated: ${new Date().toISOString()}`,
  '',
  'Hub-only roots + `blocks/<id>/skills/<name>/SKILL.md`. Nested `library/` / `repo/` are in LIBRARY-INDEX, not here.',
  '',
  '| Skill | Path | Group | Description |',
  '|-------|------|-------|-------------|',
  ...all.map((r) => `| ${r.name} | \`${r.rel}\` | ${r.group} | ${r.desc.replace(/\|/g, '\\|')} |`),
  '',
  `Total: ${all.length} skills`,
  '',
];

writeFileSync(OUT, lines.join('\n'), 'utf8');
console.log(`Wrote ${OUT} (${all.length} skills)`);
