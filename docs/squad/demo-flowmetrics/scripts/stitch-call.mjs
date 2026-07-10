#!/usr/bin/env node
/** One-shot Stitch MCP tool call via hub proxy (bypasses Cursor MCP timeout). */
import { readFileSync } from "fs";
import { spawnSync } from "child_process";
import { join } from "path";
const hub = "C:/Users/Asus/.cursor";
const proxy = join(hub, "commands", "stitch-mcp-proxy.mjs");
const mcpJson = join(hub, "mcp.json");

function loadKey() {
  if (process.env.STITCH_API_KEY) return process.env.STITCH_API_KEY;
  const cfg = JSON.parse(readFileSync(mcpJson, "utf8"));
  return cfg.mcpServers?.stitch?.env?.STITCH_API_KEY ?? cfg.mcpServers?.stitch?.headers?.["X-Goog-Api-Key"];
}

function rpc(id, method, params) {
  const env = { ...process.env, STITCH_API_KEY: loadKey() };
  const init = JSON.stringify({
    jsonrpc: "2.0",
    id: 0,
    method: "initialize",
    params: {
      protocolVersion: "2024-11-05",
      capabilities: {},
      clientInfo: { name: "stitch-call", version: "1" },
    },
  });
  spawnSync("node", [proxy], { input: init, encoding: "utf8", env });

  const initialized = JSON.stringify({ jsonrpc: "2.0", method: "notifications/initialized", params: {} });
  spawnSync("node", [proxy], { input: initialized, encoding: "utf8", env });

  const body = JSON.stringify({ jsonrpc: "2.0", id, method, params });
  const r = spawnSync("node", [proxy], { input: body, encoding: "utf8", env });
  const lines = (r.stdout || "").trim().split("\n").filter(Boolean);
  return JSON.parse(lines[lines.length - 1]);
}

const [tool, argsPath] = process.argv.slice(2);
if (!tool) {
  console.error("Usage: node stitch-call.mjs <toolName> [path-to-args.json]");
  process.exit(1);
}
let args = {};
if (argsPath) {
  args = JSON.parse(readFileSync(argsPath, "utf8"));
}
const out = rpc(2, "tools/call", { name: tool, arguments: args });
console.log(JSON.stringify(out, null, 2));
