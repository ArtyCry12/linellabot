#!/usr/bin/env node
/**
 * Create Cursor-discoverable stub skills that point to library phase folders
 * Usage: node link-subskills.mjs [--force]
 */

import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const LIBRARY = join(SKILL_ROOT, 'library');
const CURSOR_SKILLS = join(process.env.USERPROFILE || process.env.HOME, '.cursor', 'skills');

const PHASES = ['research', 'build', 'optimize', 'monitor', 'cross-cutting'];
const force = process.argv.includes('--force');

function listSkills() {
  const out = [];
  for (const phase of PHASES) {
    const phaseDir = join(LIBRARY, phase);
    if (!existsSync(phaseDir)) continue;
    for (const name of readdirSync(phaseDir)) {
      const skillMd = join(phaseDir, name, 'SKILL.md');
      if (existsSync(skillMd)) out.push({ phase, name, skillMd });
    }
  }
  return out;
}

mkdirSync(CURSOR_SKILLS, { recursive: true });

let linked = 0;
for (const { phase, name, skillMd } of listSkills()) {
  const destDir = join(CURSOR_SKILLS, `seo-geo-${name}`);
  const destSkill = join(destDir, 'SKILL.md');
  const relLib = `../seo-geo/library/${phase}/${name}`;

  if (existsSync(destDir) && !force) {
    console.log(`skip (exists): seo-geo-${name}`);
    continue;
  }

  mkdirSync(destDir, { recursive: true });

  const body = readFileSync(skillMd, 'utf8');
  let description = 'SEO/GEO specialist skill from aaron-he-zhu/seo-geo-claude-skills.';
  const block = body.match(/^description:\s*>-\s*\n((?:\s+.+\n?)+)/m);
  if (block) {
    description = block[1]
      .split('\n')
      .map((l) => l.trim())
      .filter(Boolean)
      .join(' ');
  } else {
    const line = body.split('\n').find((l) => l.startsWith('description:'));
    if (line) {
      const raw = line.replace(/^description:\s*/, '').trim();
      if (
        (raw.startsWith("'") && raw.endsWith("'")) ||
        (raw.startsWith('"') && raw.endsWith('"'))
      ) {
        description = raw.slice(1, -1);
      }
    }
  }

  const wrapper = `---
name: seo-geo-${name}
description: >-
  ${description.replace(/"/g, "'")} Use @seo-geo-${name} or @seo-geo. Pack path:
  seo-geo/library/${phase}/${name}.
user-invocable: true
---

# ${name} (SEO/GEO pack)

Read and follow the authoritative skill file:

\`C:/Users/Asus/.cursor/skills/seo-geo/library/${phase}/${name}/SKILL.md\`

Also load references from that directory when the skill instructs you to.

Parent orchestrator: \`C:/Users/Asus/.cursor/skills/seo-geo/SKILL.md\`
`;

  writeFileSync(destSkill, wrapper, 'utf8');

  const refDest = join(destDir, 'library-link.txt');
  writeFileSync(refDest, join(SKILL_ROOT, 'library', phase, name), 'utf8');

  linked++;
  console.log(`linked: seo-geo-${name}`);
}

console.log(`\nDone. ${linked} stub skill(s) under ${CURSOR_SKILLS}`);
console.log('Restart Cursor or start a new chat to refresh skill discovery.');
