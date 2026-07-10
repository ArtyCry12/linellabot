#!/usr/bin/env node
/**
 * Write Figma MCP tool descriptor stubs for Cursor agent (plugin-figma-figma).
 * OAuth/connect happens in Cursor Settings after mcp.json includes figma URL.
 */
import { mkdir, writeFile } from "node:fs/promises";
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dir = dirname(fileURLToPath(import.meta.url));
const HUB = join(__dir, "..");
const OUT = join(HUB, "projects/c-Users-Asus-cursor/mcps/plugin-figma-figma");
const TOOLS = join(OUT, "tools");

const PLUGIN_MCP = join(
  HUB,
  "plugins/cache/cursor-public/figma/bea8bea5f676ab2bf76fa822b82f50b66653c098/.mcp.json",
);

const FIGMA_INSTRUCTIONS = `The official Figma MCP server. Use for design-to-code, code-to-design, FigJam, Figma Make, Figma Slides.

WHEN TO USE: UI mockups, figma.com URLs, generate/adapt Figma files, Code Connect.

SKILLS: /figma-use, /figma-generate-design, /figma-generate-library, /figma-code-connect, /figma-generate-diagram

Connect: Cursor Settings → MCP → figma → Connect (OAuth) if tools are empty.
`;

function loadToolNames() {
  try {
    const cfg = JSON.parse(readFileSync(PLUGIN_MCP, "utf8"));
    const titles = cfg.mcpServers?.figma?._meta?.ideToolTitles ?? {};
    return Object.keys(titles);
  } catch {
    return [
      "get_design_context",
      "get_screenshot",
      "get_metadata",
      "generate_figma_design",
      "use_figma",
      "create_new_file",
      "search_design_system",
      "get_libraries",
      "whoami",
    ];
  }
}

const names = loadToolNames();
await mkdir(TOOLS, { recursive: true });

await writeFile(
  join(OUT, "SERVER_METADATA.json"),
  `${JSON.stringify({ serverIdentifier: "plugin-figma-figma", serverName: "figma" }, null, 2)}\n`,
);
await writeFile(join(OUT, "INSTRUCTIONS.md"), `${FIGMA_INSTRUCTIONS.trim()}\n`);

for (const name of names) {
  const descriptor = {
    name,
    description: `Figma MCP tool: ${name}. Requires OAuth connect in Cursor Settings → MCP → figma.`,
    arguments: { type: "object", properties: {} },
  };
  await writeFile(join(TOOLS, `${name}.json`), `${JSON.stringify(descriptor, null, 2)}\n`);
}

console.log(`Wrote ${names.length} Figma tool stubs to ${OUT}`);
