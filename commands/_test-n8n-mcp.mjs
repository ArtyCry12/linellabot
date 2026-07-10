const URL = "https://artycry12.app.n8n.cloud/mcp-server/http";
const token =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiN2EwZjcxNi1jNWUxLTRiNmQtOTE3MC0zYmUxMGQ0YTg1M2UiLCJpc3MiOiJuOG4iLCJhdWQiOiJtY3Atc2Vcn-abc";

async function rpc(method, params) {
  const r = await fetch(URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json, text/event-stream",
      Authorization: `Bearer ${token}`,
    },
    body: JSON.stringify({ jsonrpc: "2.0", id: Date.now(), method, params }),
  });
  const text = await r.text();
  console.log(method, "status", r.status);
  console.log(text.slice(0, 2000));
}

await rpc("initialize", {
  protocolVersion: "2024-11-05",
  capabilities: {},
  clientInfo: { name: "cursor-test", version: "1.0.0" },
});
await rpc("tools/list", {});
