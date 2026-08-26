#!/usr/bin/env node
/** Stub descriptors for Notion hosted MCP */
import { mkdir, writeFile } from 'node:fs/promises';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const HUB = join(dirname(fileURLToPath(import.meta.url)), '..');
const OUT = join(HUB, 'projects/c-Users-artyo-cursor/mcps/plugin-notion-notion');
const TOOLS = join(OUT, 'tools');

const INSTRUCTIONS = `Notion official hosted MCP — https://mcp.notion.com/mcp
OAuth via Cursor Settings → MCP → Connect on first use.
Use to read/write Notion pages shared with your workspace.
`;

const toolNames = [
  'search',
  'fetch',
  'create-pages',
  'update-page',
  'move-pages',
  'duplicate-page',
  'create-database',
  'update-database',
  'create-comment',
  'get-comments',
  'get-users',
  'get-self',
  'get-teams',
];

await mkdir(TOOLS, { recursive: true });
await writeFile(
  join(OUT, 'SERVER_METADATA.json'),
  JSON.stringify({ serverIdentifier: 'plugin-notion-notion', serverName: 'notion' }, null, 2),
);
await writeFile(join(OUT, 'INSTRUCTIONS.md'), INSTRUCTIONS);

for (const name of toolNames) {
  await writeFile(
    join(TOOLS, `${name}.json`),
    JSON.stringify({
      name,
      description: `Notion MCP: ${name}`,
      arguments: { type: 'object', properties: {} },
    }, null, 2),
  );
}
console.log('Wrote Notion MCP stubs to', OUT);
