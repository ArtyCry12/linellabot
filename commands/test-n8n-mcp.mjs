#!/usr/bin/env node
import { loadN8nConfig, n8nMcpSession, n8nRpc } from "./n8n-mcp-utils.mjs";

const { url, token } = loadN8nConfig();

const { init, sessionHeaders } = await n8nMcpSession(url, token);
const info = init.data.result.serverInfo;
console.log(`OK initialize: ${info?.name ?? "n8n"} v${info?.version ?? "?"}`);

try {
  const list = await n8nRpc(url, token, "tools/list", {}, 2, sessionHeaders);
  const tools = list.data?.result?.tools ?? [];
  console.log(`OK tools/list: ${tools.length} tools (${list.bytes} bytes)`);
  for (const t of tools.slice(0, 10)) console.log(" -", t.name);
  if (tools.length === 0) process.exit(1);
} catch (e) {
  console.warn(`WARN tools/list: ${e.message}`);
  console.warn("Auth + initialize OK — Cursor HTTP MCP may still list tools after Reload Window.");
  console.warn("Run: node commands/sync-n8n-mcp-descriptors.mjs (uses manifest fallback if needed).");
}
