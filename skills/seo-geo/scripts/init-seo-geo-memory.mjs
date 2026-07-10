#!/usr/bin/env node
/**
 * Bootstrap SEO/GEO project memory layout (HOT/WARM/COLD + wiki index).
 * Usage: node init-seo-geo-memory.mjs [targetDir]
 */

import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

const target = resolve(process.argv[2] || process.cwd());
const memory = join(target, 'memory');

const dirs = [
  'memory',
  'memory/research',
  'memory/audits',
  'memory/monitoring',
  'memory/wiki',
  'memory/archive',
];

for (const rel of dirs) {
  mkdirSync(join(target, rel), { recursive: true });
}

const hotCache = join(memory, 'hot-cache.md');
if (!existsSync(hotCache)) {
  writeFileSync(
    hotCache,
    `# SEO/GEO hot cache

> Auto-maintained summary (≤80 lines). See memory-management skill.

## Active objective

-

## Last handoff

-

## Open loops

-

`,
    'utf8'
  );
}

const wikiIndex = join(memory, 'wiki', 'index.md');
if (!existsSync(wikiIndex)) {
  writeFileSync(
    wikiIndex,
    `# Wiki index (Phase 1)

Compiled from WARM memory. See \`cross-cutting/memory-management\` in the seo-geo library.

`,
    'utf8'
  );
}

console.log(`SEO/GEO memory layout ready at: ${memory}`);
console.log('Invoke @seo-geo and use memory-management for multi-session campaigns.');
