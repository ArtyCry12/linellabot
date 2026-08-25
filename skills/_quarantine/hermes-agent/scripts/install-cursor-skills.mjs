#!/usr/bin/env node
/**
 * Copy a Hermes bundled skill into ~/.cursor/skills/<name>/ for Cursor discovery.
 * Usage: node install-cursor-skills.mjs <skill-name> [skill-name2 ...]
 *        node install-cursor-skills.mjs --list
 */

import { cpSync, existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { basename, dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const LIBRARY_ROOTS = [
  join(
    dirname(SKILL_ROOT),
    '..',
    'skills-libraries',
    '_extract-hermes-agent',
    'hermes-agent-main'
  ),
  'C:/Users/Asus/.cursor/skills-libraries/_extract-hermes-agent/hermes-agent-main',
].map((p) => resolve(p));

const CURSOR_SKILLS = join(homedir(), '.cursor', 'skills');

function findLibraryRoot() {
  for (const root of LIBRARY_ROOTS) {
    if (existsSync(join(root, 'skills'))) return root;
  }
  return null;
}

function walkForSkillMd(dir, results = []) {
  if (!existsSync(dir)) return results;
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const st = statSync(full);
    if (st.isDirectory()) {
      walkForSkillMd(full, results);
    } else if (name === 'SKILL.md') {
      results.push(full);
    }
  }
  return results;
}

function skillNameFromPath(skillMdPath) {
  const text = readFileSync(skillMdPath, 'utf8');
  const m = text.match(/^---[\s\S]*?\nname:\s*["']?([^"'\n]+)["']?/m);
  if (m) return m[1].trim();
  return basename(dirname(skillMdPath));
}

function findSkill(libraryRoot, wanted) {
  const roots = [
    join(libraryRoot, 'skills'),
    join(libraryRoot, 'optional-skills'),
  ];
  const needle = wanted.toLowerCase();
  for (const root of roots) {
    for (const skillMd of walkForSkillMd(root)) {
      const dir = dirname(skillMd);
      const folder = basename(dir).toLowerCase();
      const name = skillNameFromPath(skillMd).toLowerCase();
      if (folder === needle || name === needle) {
        return dir;
      }
    }
  }
  return null;
}

function copySkillDir(srcDir, destDir) {
  mkdirSync(destDir, { recursive: true });
  for (const name of readdirSync(srcDir)) {
    const from = join(srcDir, name);
    const to = join(destDir, name);
    const st = statSync(from);
    if (st.isDirectory()) {
      copySkillDir(from, to);
    } else {
      cpSync(from, to);
    }
  }
}

const args = process.argv.slice(2);
if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
  console.log('Usage: node install-cursor-skills.mjs <skill-name> [...]');
  console.log('       node install-cursor-skills.mjs --list');
  process.exit(args.length === 0 ? 1 : 0);
}

const libraryRoot = findLibraryRoot();
if (!libraryRoot) {
  console.error(
    'Hermes source not found. Extract the zip to:\n' +
      '  C:/Users/Asus/.cursor/skills-libraries/_extract-hermes-agent/hermes-agent-main'
  );
  process.exit(1);
}

if (args.includes('--list')) {
  const seen = new Set();
  for (const root of ['skills', 'optional-skills']) {
    for (const skillMd of walkForSkillMd(join(libraryRoot, root))) {
      seen.add(skillNameFromPath(skillMd));
    }
  }
  console.log([...seen].sort().join('\n'));
  process.exit(0);
}

mkdirSync(CURSOR_SKILLS, { recursive: true });

let ok = 0;
let fail = 0;
for (const wanted of args) {
  const src = findSkill(libraryRoot, wanted);
  if (!src) {
    console.error(`not found: ${wanted}`);
    fail++;
    continue;
  }
  const name = skillNameFromPath(join(src, 'SKILL.md'));
  const dest = join(CURSOR_SKILLS, name);
  copySkillDir(src, dest);
  console.log(`installed: ${name}\n  from: ${src}\n  to:   ${dest}`);
  ok++;
}

console.log(`\n${ok} installed, ${fail} failed.`);
if (fail > 0) process.exit(1);
