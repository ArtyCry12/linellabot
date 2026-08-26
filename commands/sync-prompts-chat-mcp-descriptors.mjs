#!/usr/bin/env node
/** Stub descriptors for prompts.chat remote MCP */
import { mkdir, writeFile } from 'node:fs/promises';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const HUB = join(dirname(fileURLToPath(import.meta.url)), '..');
const OUT = join(HUB, 'projects/c-Users-artyo-cursor/mcps/plugin-prompts-chat');
const TOOLS = join(OUT, 'tools');

const INSTRUCTIONS = `prompts.chat MCP — search and retrieve community prompt templates.
URL: https://prompts.chat/api/mcp
Use when user needs prompt examples, role prompts, or copy frameworks — not every session.
`;

const toolNames = [
  'search_prompts',
  'get_prompt',
  'list_categories',
  'get_random_prompt',
];

await mkdir(TOOLS, { recursive: true });
await writeFile(
  join(OUT, 'SERVER_METADATA.json'),
  JSON.stringify({ serverIdentifier: 'plugin-prompts-chat', serverName: 'prompts.chat' }, null, 2),
);
await writeFile(join(OUT, 'INSTRUCTIONS.md'), INSTRUCTIONS);

for (const name of toolNames) {
  await writeFile(
    join(TOOLS, `${name}.json`),
    JSON.stringify({
      name,
      description: `prompts.chat MCP tool: ${name}. Connect via mcp.json url https://prompts.chat/api/mcp`,
      arguments: { type: 'object', properties: {} },
    }, null, 2),
  );
}
console.log('Wrote prompts.chat stubs to', OUT);
