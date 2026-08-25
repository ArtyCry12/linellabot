#!/usr/bin/env node
/**
 * Bootstrap Hermes-style personalized agent files into a project directory.
 * Usage: node init-hermes-workspace.mjs [targetDir] [--force]
 */

import { copyFileSync, existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SKILL_ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const TEMPLATE_SOUL = join(SKILL_ROOT, 'template', 'SOUL.md');
const TEMPLATE_AGENTS = join(SKILL_ROOT, 'template', 'AGENTS.hermes.md');

const target = resolve(process.argv[2] || process.cwd());
const force = process.argv.includes('--force');

function ensureDir(p) {
  mkdirSync(p, { recursive: true });
}

function writeIfMissing(path, content, label) {
  if (existsSync(path) && !force) {
    console.log(`skip (exists): ${label} → ${path}`);
    return false;
  }
  writeFileSync(path, content, 'utf8');
  console.log(`wrote: ${label} → ${path}`);
  return true;
}

ensureDir(target);

// SOUL.md
const soulDest = join(target, 'SOUL.md');
if (existsSync(TEMPLATE_SOUL)) {
  if (!existsSync(soulDest) || force) {
    copyFileSync(TEMPLATE_SOUL, soulDest);
    console.log(`wrote: SOUL.md → ${soulDest}`);
  } else {
    console.log(`skip (exists): SOUL.md → ${soulDest}`);
  }
} else {
  writeIfMissing(
    soulDest,
    `# Agent Persona\n\nEdit this file to define how the agent communicates.\n\n- Tone:\n- Boundaries:\n- Priorities:\n`,
    'SOUL.md (fallback)'
  );
}

// AGENTS.hermes.md or merge hint
const agentsHermes = join(target, 'AGENTS.hermes.md');
const agentsMain = join(target, 'AGENTS.md');
if (existsSync(TEMPLATE_AGENTS)) {
  writeIfMissing(agentsHermes, readFileSync(TEMPLATE_AGENTS, 'utf8'), 'AGENTS.hermes.md');
}
if (!existsSync(agentsMain)) {
  const seed = existsSync(TEMPLATE_AGENTS)
    ? readFileSync(TEMPLATE_AGENTS, 'utf8')
    : '## Agent Workflow\n\n- Honor SOUL.md persona.\n- Run impact analysis before symbol edits when GitNexus is available.\n';
  writeFileSync(agentsMain, seed, 'utf8');
  console.log(`wrote: AGENTS.md → ${agentsMain}`);
} else {
  console.log(`keep: AGENTS.md already exists → ${agentsMain}`);
  console.log('  Tip: merge sections from AGENTS.hermes.md if you want Hermes workflow blocks.');
}

// Optional Cursor rule for persona
const rulesDir = join(target, '.cursor', 'rules');
ensureDir(rulesDir);
const personaRule = join(rulesDir, 'hermes-persona.mdc');
const ruleBody = `---
description: Hermes Agent persona — load SOUL.md tone and boundaries for personalized agent behavior.
globs:
alwaysApply: true
---

# Hermes persona

Read \`SOUL.md\` at the start of substantive tasks. Match its tone, boundaries, and priorities.
When the user asks to change personality, edit SOUL.md (not generic defaults).
For multi-step work, prefer imported Hermes workflow skills (@writing-plans, @systematic-debugging).
`;
writeIfMissing(personaRule, ruleBody, 'hermes-persona.mdc');

console.log('\nDone. Next steps:');
console.log(`  1. Edit "${join(target, 'SOUL.md')}" with your agent persona`);
console.log('  2. In Cursor: @hermes-agent for workflows, or invoke imported skills by name');
console.log(
  '  3. Optional: node C:/Users/Asus/.cursor/skills/hermes-agent/scripts/install-cursor-skills.mjs writing-plans'
);
