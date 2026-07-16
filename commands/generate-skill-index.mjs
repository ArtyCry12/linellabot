#!/usr/bin/env node
/**
 * Generate skills/_INDEX.md from SKILL.md files under skills/ and skills-cursor/
 */
import { readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const HUB = join(fileURLToPath(new URL('.', import.meta.url)), '..');
const OUT = join(HUB, 'skills', '_INDEX.md');

function walkSkills(root, label) {
  const rows = [];
  if (!statSync(root, { throwIfNoEntry: false })?.isDirectory()) return rows;

  function scan(dir) {
    for (const ent of readdirSync(dir, { withFileTypes: true })) {
      const p = join(dir, ent.name);
      if (ent.isDirectory()) {
        if (['node_modules', 'library', 'template', '.git', '_archive'].includes(ent.name)) continue;
        scan(p);
      } else if (ent.name === 'SKILL.md') {
        const rel = relative(HUB, p).replace(/\\/g, '/');
        // Skip nested clone paths: skills/foo/foo/SKILL.md (prefer skills/foo/SKILL.md)
        const parts = rel.split('/');
        if (parts.length >= 4 && parts[parts.length - 2] === parts[parts.length - 3]) continue;
        const text = readFileSync(p, 'utf8');
        const name = text.match(/^name:\s*(.+)$/m)?.[1]?.trim()
          || relative(join(root, '..'), join(dir, '')).replace(/\\/g, '/');
        const desc = text.match(/^description:\s*(.+)$/m)?.[1]?.trim()
          || text.match(/^description:\s*>\s*\n([\s\S]*?)(?=\n\w|\n---)/m)?.[1]?.replace(/\n\s+/g, ' ').trim()
          || '(no description)';
        rows.push({ name, rel, desc: desc.slice(0, 120) });
      }
    }
  }
  scan(root);
  return rows.map((r) => ({ ...r, group: label }));
}

const all = [
  ...walkSkills(join(HUB, 'skills'), 'personal'),
  ...walkSkills(join(HUB, 'skills-cursor'), 'skills-cursor'),
].sort((a, b) => a.rel.localeCompare(b.rel));

const lines = [
  '# Skills index (auto-generated)',
  '',
  `Generated: ${new Date().toISOString()}`,
  '',
  '| Skill | Path | Description |',
  '|-------|------|-------------|',
  ...all.map((r) => `| ${r.name} | \`${r.rel}\` | ${r.desc.replace(/\|/g, '\\|')} |`),
  '',
  `Total: ${all.length} skills`,
  '',
];

writeFileSync(OUT, lines.join('\n'), 'utf8');
console.log(`Wrote ${OUT} (${all.length} skills)`);
