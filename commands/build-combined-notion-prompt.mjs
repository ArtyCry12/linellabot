#!/usr/bin/env node
/** Build verbatim combined Notion prompt from cached fetch + inline JSON */
import fs from "node:fs";
import path from "node:path";

const hub = process.argv[2] || "C:/Users/artyo/.cursor";
const out = path.join(hub, "ai-tracking/COMBINED-NOTION-PROMPT.md");

const p1Path = path.join(
  hub,
  "projects/c-Users-artyo-cursor/agent-tools/e763ab39-6794-45bf-b26e-7752cdedc70f.txt"
);
const p1 = JSON.parse(fs.readFileSync(p1Path, "utf8"));

const pages = [
  {
    block: 1,
    url: "https://app.notion.com/p/3966689eb5b880658227ee3f0c0f5680",
    title: p1.title || "1",
    raw: p1.text,
  },
  {
    block: 2,
    url: "https://app.notion.com/p/3966689eb5b8808786bff35cc4c25e7f",
    title: "Production Studio",
    raw: process.env.NOTION_P2 || "",
  },
  {
    block: 3,
    url: "https://app.notion.com/p/3966689eb5b880f7bf21c9f8e78c71b1",
    title: "Design-Stack",
    raw: process.env.NOTION_P3 || "",
  },
];

function extractContent(text) {
  const m = text.match(/<content>([\s\S]*?)<\/content>/);
  return m ? m[1].trim() : text;
}

const header = `# COMBINED NOTION PROMPT (verbatim concat)

> Собрано из 3 Notion-страниц без изменения формулировок внутри блоков.
> Порядок: Page 1 → Page 2 → Page 3

`;

let body = header;
for (const p of pages) {
  body += `\n---\n\n## BLOCK ${p.block}: ${p.title}\n\n**URL:** ${p.url}\n\n`;
  body += extractContent(p.raw);
  body += "\n";
}

// Inline p2/p3 from this run if env empty — read from sibling json files
const p2file = path.join(hub, "ai-tracking/_notion-fetch-p2.json");
const p3file = path.join(hub, "ai-tracking/_notion-fetch-p3.json");
if (fs.existsSync(p2file)) {
  const j = JSON.parse(fs.readFileSync(p2file, "utf8"));
  body = header;
  const all = [
    { ...pages[0], raw: p1.text },
    { ...pages[1], raw: j.text },
    {
      ...pages[2],
      raw: fs.existsSync(p3file)
        ? JSON.parse(fs.readFileSync(p3file, "utf8")).text
        : pages[2].raw,
    },
  ];
  for (const p of all) {
    body += `\n---\n\n## BLOCK ${p.block}: ${p.title}\n\n**URL:** ${p.url}\n\n`;
    body += extractContent(p.raw);
    body += "\n";
  }
}

fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, body, "utf8");
console.log("Wrote", out, "bytes:", Buffer.byteLength(body));
