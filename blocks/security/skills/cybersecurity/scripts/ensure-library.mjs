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
import { spawnSync } from 'node:child_process';
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
const GITHUB_REPO = 'https://github.com/mukul975/Anthropic-Cybersecurity-Skills.git';

const force = process.argv.includes('--force');
const MIN_SKILLS = 700;

function countSkills() {
  if (!existsSync(SKILLS_DIR)) return 0;
  return readdirSync(SKILLS_DIR, { withFileTypes: true }).filter((d) => d.isDirectory()).length;
}

function findZip() {
  const candidates = [
    join(LIBS_DIR, GITHUB_ZIP_NAME),
    join(LIBS_DIR, 'Anthropic-Cybersecurity-Skills-main ( security of project ).zip'),
  ];
  for (const p of candidates) {
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
  const dest = join(LIBS_DIR, GITHUB_ZIP_NAME);
  const existing = findZip();
  if (existing && !force) {
    const n = countSkills();
    if (n >= MIN_SKILLS) return existing;
    // Partial/corrupt library — prefer fresh GitHub zip
    if (existing !== dest) {
      console.log('WARN: replacing local zip with GitHub archive');
    }
  }
  if (existsSync(dest) && !force && statSync(dest).size > 1_000_000) return dest;
  await downloadZip(dest);
  return dest;
}

function runPowerShellExpand(zipPath, tmp) {
  const ps = spawnSync(
    'powershell.exe',
    [
      '-NoProfile',
      '-Command',
      `Expand-Archive -LiteralPath '${zipPath.replace(/'/g, "''")}' -DestinationPath '${tmp.replace(/'/g, "''")}' -Force`,
    ],
    { stdio: 'inherit', timeout: 0, windowsHide: true },
  );
  if (ps.error) throw ps.error;
  if (ps.status !== 0) throw new Error(`Expand-Archive failed (code ${ps.status})`);
}

function cloneFromGit(tmp) {
  console.log(`Cloning ${GITHUB_REPO} (depth 1) ...`);
  if (existsSync(tmp)) rmSync(tmp, { recursive: true, force: true });
  mkdirSync(tmp, { recursive: true });
  const r = spawnSync('git', ['clone', '--depth', '1', GITHUB_REPO, tmp], {
    stdio: 'inherit',
    timeout: 0,
    cwd: dirname(tmp),
  });
  if (r.error) throw r.error;
  if (r.status !== 0) throw new Error(`git clone failed (code ${r.status})`);
  return join(tmp, 'Anthropic-Cybersecurity-Skills');
}

function resolveInnerDir(tmp) {
  const names = [
    'Anthropic-Cybersecurity-Skills-main',
    'Anthropic-Cybersecurity-Skills-main-main',
    'Anthropic-Cybersecurity-Skills',
  ];
  for (const n of names) {
    const p = join(tmp, n);
    if (existsSync(p)) return p;
  }
  const dirs = readdirSync(tmp, { withFileTypes: true }).filter((d) => d.isDirectory());
  if (dirs.length === 1) return join(tmp, dirs[0].name);
  throw new Error('Expected single root folder inside archive');
}

function installLibrary(sourceDir) {
  const parent = dirname(LIB_ROOT);
  mkdirSync(parent, { recursive: true });
  if (existsSync(LIB_ROOT)) rmSync(LIB_ROOT, { recursive: true, force: true });
  renameSync(sourceDir, LIB_ROOT);
}

function extractZip(zipPath) {
  console.log(`Extracting ${zipPath} -> ${LIB_ROOT}`);
  const parent = dirname(LIB_ROOT);
  const tmp = join(parent, '_extract-tmp-cybersecurity');
  if (existsSync(tmp)) rmSync(tmp, { recursive: true, force: true });
  mkdirSync(tmp, { recursive: true });

  try {
    if (process.platform === 'win32') {
      runPowerShellExpand(zipPath, tmp);
    } else {
      const r = spawnSync('unzip', ['-q', '-o', zipPath, '-d', tmp], { stdio: 'inherit', timeout: 0 });
      if (r.status !== 0) throw new Error('unzip failed');
    }
    installLibrary(resolveInnerDir(tmp));
  } finally {
    if (existsSync(tmp)) rmSync(tmp, { recursive: true, force: true });
  }
}

function extractViaGit() {
  const parent = dirname(LIB_ROOT);
  const tmp = join(parent, '_clone-tmp-cybersecurity');
  try {
    const inner = cloneFromGit(tmp);
    installLibrary(inner);
  } finally {
    if (existsSync(tmp)) rmSync(tmp, { recursive: true, force: true });
  }
}

async function main() {
  const n = countSkills();
  if (!force && n >= MIN_SKILLS) {
    console.log(`OK: library present (${n} skills) at ${LIB_ROOT}`);
    process.exit(0);
  }
  if (n > 0 && n < MIN_SKILLS) {
    console.log(`WARN: only ${n}/${MIN_SKILLS} skills — refreshing`);
  }

  try {
    const zip = await ensureZipAvailable();
    extractZip(zip);
  } catch (zipErr) {
    console.warn(`Zip path failed: ${zipErr.message}`);
    console.log('Fallback: git clone');
    extractViaGit();
  }

  const final = countSkills();
  console.log(`Done: ${final} skills at ${SKILLS_DIR}`);
  if (final < MIN_SKILLS) {
    console.warn(`WARN: expected >= ${MIN_SKILLS}, got ${final}`);
    process.exit(final > 0 ? 0 : 1);
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
