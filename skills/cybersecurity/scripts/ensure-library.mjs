#!/usr/bin/env node
/**
 * Ensure Anthropic Cybersecurity Skills library is on disk.
 * Usage: node ensure-library.mjs [--force]
 */

import {
  createWriteStream,
  existsSync,
  mkdirSync,
  readdirSync,
  renameSync,
  rmSync,
  statSync,
} from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execSync } from 'node:child_process';
import { pipeline } from 'node:stream/promises';
import { Readable } from 'node:stream';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const HUB_ROOT = join(SKILL_ROOT, '..', '..');
const LIB_ROOT = join(SKILL_ROOT, 'library', 'Anthropic-Cybersecurity-Skills-main');
const SKILLS_DIR = join(LIB_ROOT, 'skills');
const LIBS_DIR = join(HUB_ROOT, 'skills-libraries');
const GITHUB_ZIP =
  'https://github.com/mukul975/Anthropic-Cybersecurity-Skills/archive/refs/heads/main.zip';
const GITHUB_ZIP_NAME = 'Anthropic-Cybersecurity-Skills-main.zip';

const ZIP_CANDIDATES = [
  join(LIBS_DIR, 'Anthropic-Cybersecurity-Skills-main ( security of project ).zip'),
  join(LIBS_DIR, GITHUB_ZIP_NAME),
];

const force = process.argv.includes('--force');
const MIN_SKILLS = 700;

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

async function downloadZip(destPath) {
  console.log(`Downloading ${GITHUB_ZIP} ...`);
  mkdirSync(dirname(destPath), { recursive: true });
  const res = await fetch(GITHUB_ZIP, { redirect: 'follow' });
  if (!res.ok) throw new Error(`Download failed: ${res.status} ${res.statusText}`);
  const total = Number(res.headers.get('content-length') || 0);
  let done = 0;
  const body = Readable.fromWeb(res.body);
  body.on('data', (chunk) => {
    done += chunk.length;
    if (total > 0 && done % (512 * 1024) < chunk.length) {
      process.stdout.write(`\r  ${Math.round((done / total) * 100)}% (${(done / 1e6).toFixed(1)} MB)`);
    }
  });
  await pipeline(body, createWriteStream(destPath));
  console.log(`\nSaved ${destPath} (${(statSync(destPath).size / 1e6).toFixed(1)} MB)`);
}

async function ensureZipAvailable() {
  const existing = findZip();
  if (existing && !force) return existing;

  const dest = join(LIBS_DIR, GITHUB_ZIP_NAME);
  if (existsSync(dest) && !force) return dest;

  await downloadZip(dest);
  return dest;
}

function extractZip(zipPath) {
  console.log(`Extracting ${zipPath} -> ${LIB_ROOT}`);
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
      { stdio: 'inherit', timeout: 600_000 },
    );
  } else {
    execSync(`unzip -q -o "${zipPath}" -d "${tmp}"`, { stdio: 'inherit', timeout: 600_000 });
  }

  let inner = join(tmp, 'Anthropic-Cybersecurity-Skills-main');
  if (!existsSync(inner)) {
    inner = join(tmp, 'Anthropic-Cybersecurity-Skills-main-main');
  }
  if (!existsSync(inner)) {
    const dirs = readdirSync(tmp, { withFileTypes: true }).filter((d) => d.isDirectory());
    if (dirs.length === 1) inner = join(tmp, dirs[0].name);
  }
  if (!existsSync(inner)) {
    throw new Error('Expected Anthropic-Cybersecurity-Skills-main folder inside zip');
  }

  renameSync(inner, LIB_ROOT);
  rmSync(tmp, { recursive: true, force: true });
}

async function main() {
  const n = countSkills();
  if (!force && n >= MIN_SKILLS) {
    console.log(`OK: library present (${n} skills) at ${LIB_ROOT}`);
    process.exit(0);
  }

  if (n > 0 && n < MIN_SKILLS) {
    console.log(`WARN: only ${n}/${MIN_SKILLS} skills — refreshing library`);
  }

  const zip = await ensureZipAvailable();
  extractZip(zip);
  const final = countSkills();
  console.log(`Done: ${final} skills`);
  if (final < MIN_SKILLS) {
    console.warn(`WARN: expected >= ${MIN_SKILLS} skills, got ${final}`);
    process.exit(final > 0 ? 0 : 1);
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
