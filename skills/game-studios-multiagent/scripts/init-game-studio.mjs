#!/usr/bin/env node
/**
 * Bootstrap Claude Code Game Studios into a game project directory.
 * Usage: node init-game-studio.mjs [targetDir]
 * Default targetDir: process.cwd()
 */

import { cpSync, existsSync, mkdirSync, readdirSync, statSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const FALLBACK_TEMPLATE =
  'C:/Users/Asus/.cursor/skills-libraries/_extract-game-studios/Claude-Code-Game-Studios-main';
const TEMPLATE = [join(SKILL_ROOT, 'template'), FALLBACK_TEMPLATE].find((p) =>
  existsSync(join(p, 'CLAUDE.md'))
);

const SKIP = new Set([
  'node_modules',
  '.git',
  '.next',
  'dist',
  'out',
  'coverage',
  '.turbo',
  'CCGS Skill Testing Framework',
]);

function copyFiltered(src, dest) {
  mkdirSync(dest, { recursive: true });
  for (const name of readdirSync(src)) {
    if (SKIP.has(name)) continue;
    const from = join(src, name);
    const to = join(dest, name);
    if (statSync(from).isDirectory()) {
      copyFiltered(from, to);
    } else {
      cpSync(from, to);
    }
  }
}

const target = resolve(process.argv[2] || process.cwd());

if (!TEMPLATE) {
  console.error(
    `Template not found. Expected:\n  ${join(SKILL_ROOT, 'template')}\n  or ${FALLBACK_TEMPLATE}`
  );
  process.exit(1);
}

const hasStudio =
  existsSync(join(target, 'CLAUDE.md')) &&
  existsSync(join(target, '.claude', 'agents'));

if (hasStudio && !process.argv.includes('--force')) {
  console.error(
    `Game Studios layout already exists at ${target}\n` +
      'Re-run with --force to merge-copy (skips node_modules/.git only).'
  );
  process.exit(1);
}

console.log(`Bootstrapping Game Studios:\n  from: ${TEMPLATE}\n  to:   ${target}`);
copyFiltered(TEMPLATE, target);
console.log('\nDone. Next steps:');
console.log(`  cd "${target}"`);
console.log('  Open in Cursor and invoke @game-studios-multiagent');
console.log('  Say: "Run studio onboarding" or paste your game idea');
console.log('\nOptional: use Claude Code in this repo for native /slash skills and hooks.');
