#!/usr/bin/env node
/**
 * Sync Stitch MCP tool descriptors to projects/c-Users-artyo-cursor/mcps/user-stitch/
 * Uses STITCH_API_KEY env or reads from mcp.json (local only).
 */

import { mkdir, writeFile } from "node:fs/promises";
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { request } from "node:https";

const __dir = dirname(fileURLToPath(import.meta.url));
const HUB = join(__dir, "..");
const OUT = join(HUB, "projects/c-Users-artyo-cursor/mcps/user-stitch");
const TOOLS = join(OUT, "tools");

function loadApiKey() {
  if (process.env.STITCH_API_KEY) return process.env.STITCH_API_KEY;
  try {
    const cfg = JSON.parse(readFileSync(join(HUB, "mcp.json"), "utf8"));
    const s = cfg.mcpServers?.stitch;
    return s?.env?.STITCH_API_KEY ?? s?.headers?.["X-Goog-Api-Key"] ?? null;
  } catch {
    return null;
  }
}

function postToStitch(body, apiKey) {
  return new Promise((resolve, reject) => {
    const data = JSON.stringify(body);
    const req = request(
      {
        hostname: "stitch.googleapis.com",
        path: "/mcp",
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json, text/event-stream",
          "Content-Length": Buffer.byteLength(data),
          "X-Goog-Api-Key": apiKey,
        },
      },
      (res) => {
        let raw = "";
        res.on("data", (c) => (raw += c));
        res.on("end", () => {
          try {
            resolve(JSON.parse(raw));
          } catch (e) {
            reject(new Error(raw.slice(0, 300)));
          }
        });
      },
    );
    req.on("error", reject);
    req.write(data);
    req.end();
  });
}

const apiKey = loadApiKey();
if (!apiKey) {
  console.error("STITCH_API_KEY not set and not found in mcp.json");
  process.exit(1);
}

const res = await postToStitch({ jsonrpc: "2.0", id: 1, method: "tools/list", params: {} }, apiKey);
const tools = res.result?.tools ?? [];

await mkdir(TOOLS, { recursive: true });
await writeFile(
  join(OUT, "SERVER_METADATA.json"),
  `${JSON.stringify({ serverIdentifier: "user-stitch", serverName: "stitch" }, null, 2)}\n`,
);

for (const tool of tools) {
  const { name, description, inputSchema } = tool;
  const descriptor = {
    name,
    description: (description ?? "").trim(),
    arguments: inputSchema ?? { type: "object", properties: {} },
  };
  await writeFile(join(TOOLS, `${name}.json`), `${JSON.stringify(descriptor, null, 2)}\n`);
}

console.log(`Wrote ${tools.length} tools to ${OUT}`);
