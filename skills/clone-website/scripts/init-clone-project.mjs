#!/usr/bin/env node
/**
 * Copy the AI Website Cloner Next.js scaffold into any directory.
 * Usage: node init-clone-project.mjs [targetDir]
 * Default targetDir: process.cwd()
 */

import { cpSync, existsSync, mkdirSync, readdirSync, statSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const FALLBACK_TEMPLATE = 'C:/Users/Asus/.cursor/skills/clone-website/template';
const TEMPLATE = [join(SKILL_ROOT, 'template'), FALLBACK_TEMPLATE].find((p) =>
  existsSync(join(p, 'package.json'))
);

const SKIP = new Set([
  'node_modules',
  '.git',
  '.next',
  'dist',
  'out',
  'coverage',
  '.turbo',
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

const pkg = join(target, 'package.json');
if (existsSync(pkg)) {
  console.error(
    `Refusing to overwrite existing project at ${target}\n` +
      'Use an empty directory or remove package.json first.'
  );
  process.exit(1);
}

console.log(`Scaffolding clone project:\n  from: ${TEMPLATE}\n  to:   ${target}`);
copyFiltered(TEMPLATE, target);
console.log('\nDone. Next steps:');
console.log(`  cd "${target}"`);
console.log('  npm install');
console.log('  npm run build');
console.log('\nThen invoke @clone-website with your target URL(s).');
