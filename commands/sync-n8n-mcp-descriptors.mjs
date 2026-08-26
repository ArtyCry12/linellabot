#!/usr/bin/env node
/**
 * Sync n8n MCP tool descriptors to projects/c-Users-artyo-cursor/mcps/user-n8n-mcp/
 * Tries live tools/list; falls back to official tool manifest if stream resets.
 */

import { mkdir, writeFile } from "node:fs/promises";
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { loadN8nConfig, n8nMcpSession, n8nRpc } from "./n8n-mcp-utils.mjs";

const __dir = dirname(fileURLToPath(import.meta.url));
const HUB = join(__dir, "..");
const OUT = join(HUB, "projects/c-Users-artyo-cursor/mcps/user-n8n-mcp");
const TOOLS = join(OUT, "tools");
const MANIFEST = join(__dir, "n8n-mcp-tools-manifest.json");

async function tryLiveTools() {
  const { url, token } = loadN8nConfig();
  const { sessionHeaders } = await n8nMcpSession(url, token);
  const list = await n8nRpc(url, token, "tools/list", {}, 1, sessionHeaders);
  return list.data?.result?.tools ?? [];
}

async function writeDescriptors(tools, source) {
  await mkdir(TOOLS, { recursive: true });
  await writeFile(
    join(OUT, "SERVER_METADATA.json"),
    `${JSON.stringify({ serverIdentifier: "user-n8n-mcp", serverName: "n8n-mcp", descriptorSource: source }, null, 2)}\n`,
  );

  for (const tool of tools) {
    const name = typeof tool === "string" ? tool : tool.name;
    const description =
      typeof tool === "string"
        ? `n8n instance MCP tool (${name}). See docs.n8n.io MCP tools reference.`
        : (tool.description ?? "").trim();
    const inputSchema =
      typeof tool === "string"
        ? { type: "object", properties: {} }
        : (tool.inputSchema ?? { type: "object", properties: {} });

    const descriptor = { name, description, arguments: inputSchema };
    await writeFile(join(TOOLS, `${name}.json`), `${JSON.stringify(descriptor, null, 2)}\n`);
  }
  console.log(`Wrote ${tools.length} tools to ${OUT} (${source})`);
}

try {
  const live = await tryLiveTools();
  if (live.length > 0) {
    await writeDescriptors(live, "live-tools/list");
    process.exit(0);
  }
} catch (e) {
  console.warn(`live tools/list unavailable: ${e.message}`);
}

const manifest = JSON.parse(readFileSync(MANIFEST, "utf8"));
await writeDescriptors(manifest, "manifest-fallback");
console.warn("Used manifest fallback — Reload Window in Cursor for live tool schemas.");
