#!/usr/bin/env node
/**
 * Ensure Anthropic Cybersecurity Skills library is on disk.
 * Usage: node ensure-library.mjs [--force]
 */

import { existsSync, mkdirSync, readdirSync, rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const LIB_ROOT = join(SKILL_ROOT, 'library', 'Anthropic-Cybersecurity-Skills-main');
const SKILLS_DIR = join(LIB_ROOT, 'skills');
const ZIP_CANDIDATES = [
  join(
    process.env.USERPROFILE || '',
    '.cursor',
    'skills-libraries',
    'Anthropic-Cybersecurity-Skills-main ( security of project ).zip',
  ),
  join(SKILL_ROOT, '..', '..', 'skills-libraries', 'Anthropic-Cybersecurity-Skills-main ( security of project ).zip'),
];

const force = process.argv.includes('--force');

function countSkills() {
  if (!existsSync(SKILLS_DIR)) return 0;
  return readdirSync(SKILLS_DIR, { withFileTypes: true }).filter((d) => d.isDirectory()).length;
}

function findZip() {
  for (const p of ZIP_CANDIDATES) {
    if (existsSync(p)) return p;
  }
  return null;
}

function extractZip(zipPath) {
  const parent = dirname(LIB_ROOT);
  mkdirSync(parent, { recursive: true });
  if (existsSync(LIB_ROOT)) {
    rmSync(LIB_ROOT, { recursive: true, force: true });
  }
  const tmp = join(parent, '_extract-tmp-cybersecurity');
  if (existsSync(tmp)) rmSync(tmp, { recursive: true, force: true });
  mkdirSync(tmp, { recursive: true });

  if (process.platform === 'win32') {
    execSync(
      `powershell -NoProfile -Command "Expand-Archive -LiteralPath '${zipPath.replace(/'/g, "''")}' -DestinationPath '${tmp.replace(/'/g, "''")}' -Force"`,
      { stdio: 'inherit' },
    );
  } else {
    execSync(`unzip -q -o "${zipPath}" -d "${tmp}"`, { stdio: 'inherit' });
  }

  const inner = join(tmp, 'Anthropic-Cybersecurity-Skills-main');
  if (!existsSync(inner)) {
    throw new Error(`Expected folder Anthropic-Cybersecurity-Skills-main inside zip`);
  }
  execSync(process.platform === 'win32' ? `move "${inner}" "${LIB_ROOT}"` : `mv "${inner}" "${LIB_ROOT}"`, {
    stdio: 'inherit',
    shell: true,
  });
  rmSync(tmp, { recursive: true, force: true });
}

const n = countSkills();
if (!force && n >= 700) {
  console.log(`OK: library present (${n} skills) at ${LIB_ROOT}`);
  process.exit(0);
}

const zip = findZip();
if (!zip) {
  console.error('Cybersecurity library missing and zip not found. Place zip at:');
  for (const p of ZIP_CANDIDATES) console.error(`  ${p}`);
  process.exit(1);
}

console.log(`Extracting ${zip} -> ${LIB_ROOT}`);
extractZip(zip);
console.log(`Done: ${countSkills()} skills`);
