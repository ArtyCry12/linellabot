/**
 * Apply an MCP profile: copy selected servers from mcp.json.store → mcp.json.
 * Usage: node lib/mcp-router/apply-mcp-profile.mjs <profileId>
 */
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const hub = join(fileURLToPath(new URL(".", import.meta.url)), "..", "..");
const profileId = process.argv[2];
if (!profileId) {
  console.error("usage: apply-mcp-profile.mjs <core|design|qa|ops>");
  process.exit(2);
}

const storePath = join(hub, "mcp.json.store");
const mcpPath = join(hub, "mcp.json");
const profilePath = join(hub, "lib", "mcp-router", "profiles", `${profileId}.json`);
const statePath = join(hub, "ai-tracking", "mcp-active-profile.json");

if (!existsSync(storePath)) {
  console.error("missing mcp.json.store — run phase 1 backup first");
  process.exit(1);
}
if (!existsSync(profilePath)) {
  console.error("unknown profile:", profileId);
  process.exit(1);
}

const store = JSON.parse(readFileSync(storePath, "utf8"));
const profile = JSON.parse(readFileSync(profilePath, "utf8"));
const allIds = Object.keys(store.mcpServers || {});
const ids = profile.ids?.[0] === "*" ? allIds : profile.ids;
const heap = Number(profile.gitnexusHeapMb) || 1536;

const missing = ids.filter((id) => !store.mcpServers[id]);
if (missing.length) {
  console.error("store missing servers:", missing.join(", "));
  process.exit(1);
}

const mcpServers = {};
for (const id of ids) {
  mcpServers[id] = structuredClone(store.mcpServers[id]);
}

if (mcpServers.gitnexus) {
  mcpServers.gitnexus.env = {
    ...(mcpServers.gitnexus.env || {}),
    NODE_OPTIONS: `--max-old-space-size=${heap}`,
  };
}

writeFileSync(mcpPath, JSON.stringify({ mcpServers }, null, 2) + "\n", "utf8");
const state = {
  appliedAt: new Date().toISOString(),
  profile: profileId,
  ids,
  gitnexusHeapMb: heap,
  store: "mcp.json.store",
  reloadWindow: true,
};
writeFileSync(statePath, JSON.stringify(state, null, 2) + "\n", "utf8");
console.log("PROFILE=" + profileId);
console.log("COUNT=" + ids.length);
console.log("IDS=" + ids.join(","));
console.log("HEAP=" + heap);
console.log("RELOAD=Reload Window to drop old MCP processes");
