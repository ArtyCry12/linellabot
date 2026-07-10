#!/usr/bin/env node
/**
 * Spawns @aaronsb/google-workspace-mcp with OAuth from gitignored JSON.
 * First run: complete browser OAuth in terminal when prompted.
 */
import { spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const hub = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const credPath =
  process.env.GOOGLE_OAUTH_CREDENTIALS_PATH ||
  path.join(hub, "ai-tracking/google-oauth-client.json");

if (!fs.existsSync(credPath)) {
  console.error(`Missing OAuth file: ${credPath}`);
  process.exit(1);
}

const cred = JSON.parse(fs.readFileSync(credPath, "utf8"));
const installed = cred.installed || cred.web || cred;

const env = {
  ...process.env,
  GOOGLE_CLIENT_ID: installed.client_id,
  GOOGLE_CLIENT_SECRET: installed.client_secret,
  GOOGLE_OAUTH_CLIENT_ID: installed.client_id,
  GOOGLE_OAUTH_CLIENT_SECRET: installed.client_secret,
  OAUTHLIB_INSECURE_TRANSPORT: "1",
};

const child = spawn(
  process.platform === "win32" ? "npx.cmd" : "npx",
  ["-y", "@aaronsb/google-workspace-mcp"],
  { stdio: "inherit", env, shell: process.platform === "win32" }
);

child.on("exit", (code) => process.exit(code ?? 1));
