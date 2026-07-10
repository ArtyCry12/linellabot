#!/usr/bin/env node
/** Generate rules/agency/_INDEX.md from installed .mdc files */
import { readdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const HUB = 'C:/Users/Asus/.cursor';
const dir = join(HUB, 'rules/agency');
const files = readdirSync(dir).filter((f) => f.endsWith('.mdc')).sort();

const rows = files.map((f) => {
  const text = readFileSync(join(dir, f), 'utf8');
  const slug = f.replace(/\.mdc$/, '');
  const desc = text.match(/^description:\s*(.+)$/m)?.[1]?.trim() || '';
  return { slug, desc: desc.slice(0, 100) };
});

const lines = [
  '# Agency rules index (auto-generated)',
  '',
  `Count: ${rows.length} · Source: [agency-agents](https://github.com/msitarzewski/agency-agents)`,
  '',
  '| @slug | Description |',
  '|-------|-------------|',
  ...rows.map((r) => `| @${r.slug} | ${r.desc.replace(/\|/g, '\\|')} |`),
  '',
];

writeFileSync(join(dir, '_INDEX.md'), lines.join('\n'), 'utf8');
console.log('Wrote', rows.length, 'entries to rules/agency/_INDEX.md');
