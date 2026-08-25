#!/usr/bin/env node
/**
 * Per-block LIBRARY-INDEX.md: nested SKILL.md under library/repo/template
 * and any SKILL.md deeper than blocks/<id>/skills/<name>/SKILL.md.
 * Discovery stays off (.cursorignore). Accounting stays on.
 */
import { readdirSync, readFileSync, writeFileSync, existsSync } from 'node:fs';
import { join, relative, basename } from 'node:path';
import { fileURLToPath } from 'node:url';

const HUB = join(fileURLToPath(new URL('.', import.meta.url)), '..');
const BLOCKS = join(HUB, 'blocks');

function titleOf(p) {
  try {
    const text = readFileSync(p, 'utf8');
    return text.match(/^name:\s*(.+)$/m)?.[1]?.trim() || basename(dirname(p));
  } catch {
    return basename(dirname(p));
  }
}

function walkSkillFiles(dir, acc) {
  if (!existsSync(dir)) return;
  let ents;
  try {
    ents = readdirSync(dir, { withFileTypes: true });
  } catch {
    return;
  }
  for (const ent of ents) {
    const p = join(dir, ent.name);
    if (ent.isDirectory()) {
      if (ent.name === 'node_modules' || ent.name === '.git' || ent.name === '.cache') continue;
      walkSkillFiles(p, acc);
    } else if (ent.name === 'SKILL.md') {
      acc.push(p);
    }
  }
}

function isRootBlockSkill(rel, blockId) {
  // blocks/<id>/skills/<name>/SKILL.md
  const re = new RegExp(`^blocks/${blockId}/skills/[^/]+/SKILL\\.md$`);
  return re.test(rel);
}

function parentOf(rel, blockId) {
  const m = rel.match(new RegExp(`^blocks/${blockId}/skills/([^/]+)/`));
  if (m) return m[1];
  if (rel.includes('/library/')) return 'library';
  if (rel.includes('/commands/')) return 'commands';
  return blockId;
}

if (!existsSync(BLOCKS)) {
  console.log('No blocks/');
  process.exit(0);
}

for (const block of readdirSync(BLOCKS, { withFileTypes: true })) {
  if (!block.isDirectory()) continue;
  const root = join(BLOCKS, block.name);
  const files = [];
  walkSkillFiles(root, files);
  const nested = files
    .map((p) => relative(HUB, p).replace(/\\/g, '/'))
    .filter((rel) => !isRootBlockSkill(rel, block.name))
    .sort();
  const lines = [
    `# LIBRARY-INDEX — ${block.name}`,
    '',
    'Nested SKILL.md only. Not loaded always-on. Paths are relative to hub root.',
    '',
    '| Path | Name | Parent |',
    '|------|------|--------|',
    ...nested.map((rel) => {
      const abs = join(HUB, rel);
      const name = titleOf(abs).replace(/\|/g, '\\|');
      return `| \`${rel}\` | ${name} | ${parentOf(rel, block.name)} |`;
    }),
    '',
    `Total nested: ${nested.length}`,
    '',
  ];
  const out = join(root, 'LIBRARY-INDEX.md');
  writeFileSync(out, lines.join('\n'), 'utf8');
  console.log(`${block.name}: ${nested.length} nested -> ${out}`);
}
