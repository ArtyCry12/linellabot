#!/usr/bin/env node
/**
 * Ensures C:/Users/Asus/.cursor/lib/21st has catalog files from the skills-libraries zip.
 */
import { existsSync, mkdirSync, copyFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { execSync } from "node:child_process";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..", "..", "..");
const LIB = join(ROOT, "lib", "21st");
const ZIP = join(ROOT, "skills-libraries", "21st-main ( design ).zip");
const CATALOG = join(LIB, "search_results.json");
const README = join(LIB, "PLATFORM_README.md");

function extractFromZip() {
  const tmp = join(ROOT, "skills-libraries", "_tmp-21st-extract");
  execSync(
    `powershell -NoProfile -Command "Expand-Archive -LiteralPath '${ZIP.replace(/'/g, "''")}' -DestinationPath '${tmp.replace(/'/g, "''")}' -Force"`,
    { stdio: "inherit" },
  );
  const inner = join(tmp, "21st-main");
  mkdirSync(LIB, { recursive: true });
  copyFileSync(join(inner, "search_results.json"), CATALOG);
  copyFileSync(join(inner, "README.md"), README);
  execSync(
    `powershell -NoProfile -Command "Remove-Item -LiteralPath '${tmp.replace(/'/g, "''")}' -Recurse -Force"`,
    { stdio: "ignore" },
  );
}

function main() {
  if (existsSync(CATALOG) && existsSync(README)) {
    console.log(`OK: catalog already at ${LIB}`);
    return;
  }
  if (!existsSync(ZIP)) {
    console.error(`Missing archive: ${ZIP}`);
    process.exit(1);
  }
  console.log(`Extracting catalog from ${ZIP} ...`);
  extractFromZip();
  console.log(`Done: ${LIB}`);
}

main();
