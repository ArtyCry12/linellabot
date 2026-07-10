import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { request } from "node:https";

export function parseSseJson(raw) {
  const trimmed = raw.trim();
  if (trimmed.startsWith("{")) return JSON.parse(trimmed);
  for (const line of raw.split(/\r?\n/)) {
    if (line.startsWith("data:")) {
      const payload = line.slice(5).trim();
      if (payload) return JSON.parse(payload);
    }
  }
  throw new Error(`No JSON in SSE response: ${raw.slice(0, 400)}`);
}

export function loadN8nConfig() {
  const hub = join(dirname(fileURLToPath(import.meta.url)), "..");
  const cfg = JSON.parse(readFileSync(join(hub, "mcp.json"), "utf8"));
  const n8n = cfg.mcpServers?.["n8n-mcp"];
  if (!n8n?.url) throw new Error("n8n-mcp not configured in mcp.json");
  const auth = n8n.headers?.Authorization ?? "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : auth;
  if (!token || token.length < 100) throw new Error("n8n-mcp Bearer token missing or truncated");
  return { url: new URL(n8n.url), token };
}

export function n8nRpc(url, token, method, params, id, extraHeaders = {}) {
  return new Promise((resolve, reject) => {
    const payload = { jsonrpc: "2.0", method, params };
    if (id !== undefined) payload.id = id;
    const body = JSON.stringify(payload);
    const req = request(
      {
        hostname: url.hostname,
        path: url.pathname,
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json, text/event-stream",
          Authorization: `Bearer ${token}`,
          "Content-Length": Buffer.byteLength(body),
          ...extraHeaders,
        },
      },
      (res) => {
        let raw = "";
        res.on("data", (c) => (raw += c));
        res.on("end", () => {
          if (!raw.trim()) {
            resolve({ status: res.statusCode, data: null, bytes: 0, headers: res.headers });
            return;
          }
          try {
            resolve({
              status: res.statusCode,
              data: parseSseJson(raw),
              bytes: raw.length,
              headers: res.headers,
            });
          } catch (e) {
            reject(new Error(`HTTP ${res.statusCode}: ${e.message}`));
          }
        });
      },
    );
    req.on("error", reject);
    req.setTimeout(120_000, () => req.destroy(new Error("request timeout")));
    req.write(body);
    req.end();
  });
}

export async function n8nMcpSession(url, token) {
  const init = await n8nRpc(
    url,
    token,
    "initialize",
    {
      protocolVersion: "2024-11-05",
      capabilities: {},
      clientInfo: { name: "cursor-hub", version: "1" },
    },
    1,
  );
  if (!init.data?.result) throw new Error(`initialize failed: ${JSON.stringify(init.data)}`);

  const sessionId =
    init.headers?.["mcp-session-id"] ??
    init.headers?.["Mcp-Session-Id"] ??
    init.headers?.["x-mcp-session-id"];

  const sessionHeaders = sessionId ? { "Mcp-Session-Id": sessionId } : {};

  await n8nRpc(url, token, "notifications/initialized", {}, undefined, sessionHeaders);

  return { init, sessionHeaders };
}
