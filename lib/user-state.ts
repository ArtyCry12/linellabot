import type { Lang } from "./types";

declare global {
  var __linellaLang: Map<number, Lang> | undefined;
  var __linellaListMode: Set<number> | undefined;
}

export function getLang(uid: number): Lang {
  return globalThis.__linellaLang?.get(uid) ?? "ro";
}

export function setLang(uid: number, lang: Lang): void {
  if (!globalThis.__linellaLang) globalThis.__linellaLang = new Map();
  globalThis.__linellaLang.set(uid, lang);
}

export function isListMode(uid: number): boolean {
  return globalThis.__linellaListMode?.has(uid) ?? false;
}

export function setListMode(uid: number, on: boolean): void {
  if (!globalThis.__linellaListMode) globalThis.__linellaListMode = new Set();
  if (on) globalThis.__linellaListMode.add(uid);
  else globalThis.__linellaListMode.delete(uid);
}
