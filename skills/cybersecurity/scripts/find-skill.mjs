#!/usr/bin/env node
/**
 * Search the 754-skill index by keyword.
 * Usage: node find-skill.mjs <query> [--limit 15]
 */

import { readFileSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const INDEX = join(SKILL_ROOT, 'library', 'Anthropic-Cybersecurity-Skills-main', 'index.json');

const args = process.argv.slice(2).filter((a) => a !== '--json');
const limitIdx = args.indexOf('--limit');
const limit = limitIdx >= 0 ? parseInt(args[limitIdx + 1], 10) : 15;
const query = (limitIdx >= 0 ? args.filter((_, i) => i !== limitIdx && i !== limitIdx + 1) : args)
  .join(' ')
  .trim()
  .toLowerCase();

if (!query) {
  console.error('Usage: node find-skill.mjs <keywords> [--limit N]');
  process.exit(1);
}

if (!existsSync(INDEX)) {
  console.error(`Missing index. Run: node ${join(SKILL_ROOT, 'scripts', 'ensure-library.mjs')}`);
  process.exit(1);
}

const { skills } = JSON.parse(readFileSync(INDEX, 'utf8'));
const terms = query.split(/\s+/).filter(Boolean);

const scored = skills
  .map((s) => {
    const hay = `${s.name} ${s.description} ${s.path}`.toLowerCase();
    let score = 0;
    for (const t of terms) {
      if (hay.includes(t)) score += t.length > 3 ? 2 : 1;
    }
    return { ...s, score };
  })
  .filter((s) => s.score > 0)
  .sort((a, b) => b.score - a.score)
  .slice(0, limit);

if (process.argv.includes('--json')) {
  console.log(JSON.stringify(scored, null, 2));
  process.exit(0);
}

for (const s of scored) {
  console.log(`${s.name}\n  ${s.description.slice(0, 120)}...\n  library/Anthropic-Cybersecurity-Skills-main/${s.path}/SKILL.md\n`);
}

if (!scored.length) console.log('No matches. Try broader terms (e.g. kubernetes, sast, phishing).');
