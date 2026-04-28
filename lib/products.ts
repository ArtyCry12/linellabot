import productsRaw from "../data/products.json";
import type { Lang, Product } from "./types";

const products = productsRaw as Product[];

export function getProducts(): Product[] {
  return products;
}

export function productLabel(p: Product, lang: Lang): string {
  switch (lang) {
    case "ru":
      return p.nameRu;
    case "ro":
      return p.nameRo;
    default:
      return p.nameEn;
  }
}

function matchToken(p: Product, tok: string): boolean {
  const tk = tok.toLowerCase();
  return (
    p.nameRu.toLowerCase().includes(tk) ||
    p.nameRo.toLowerCase().includes(tk) ||
    p.nameEn.toLowerCase().includes(tk) ||
    p.category.toLowerCase().includes(tk)
  );
}

/** Heuristic “NLP”: comma/newline-separated tokens → union of matches. */
export function findProductsByText(query: string): Product[] {
  const raw = query.trim();
  if (!raw) return [];
  let tokens = raw.split(/[,\n;]+/).map((t) => t.trim()).filter(Boolean);
  if (tokens.length === 0) tokens = [raw];

  const byId = new Map<string, Product>();
  for (const tok of tokens) {
    for (const p of products) {
      if (matchToken(p, tok)) byId.set(p.id, p);
    }
  }
  return Array.from(byId.values());
}
