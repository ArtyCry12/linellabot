import Link from "next/link";
import products from "@/data/products.json";
import type { Product } from "@/lib/types";

const all = products as Product[];

export default async function CheckoutPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const q = await searchParams;
  const raw = typeof q.ids === "string" ? q.ids : "";
  const ids = new Set(raw.split(",").map((s) => s.trim()).filter(Boolean));
  const items = all.filter((p) => ids.has(p.id));
  const total = items.reduce((s, p) => s + p.priceLei, 0);

  return (
    <main className="mx-auto max-w-xl px-4 py-10">
      <div className="glass-panel p-6">
        <p className="text-xs uppercase tracking-[0.25em] text-white/50">Checkout</p>
        <h1 className="mt-2 text-2xl font-semibold">Оформление (mock)</h1>
        <ul className="mt-4 space-y-2 text-sm text-white/85">
          {items.length === 0 && <li className="text-white/60">Нет позиций — вернитесь к боту.</li>}
          {items.map((p) => (
            <li key={p.id} className="flex justify-between gap-3 border-b border-white/10 py-2">
              <span>{p.nameRu}</span>
              <span className="tabular-nums text-white/70">{p.priceLei.toFixed(2)} MDL</span>
            </li>
          ))}
        </ul>
        <p className="mt-4 text-lg font-semibold">
          Итого: <span className="tabular-nums">{total.toFixed(2)}</span> MDL
        </p>
        <Link href="/" className="mt-6 inline-flex rounded-xl bg-[#e30613] px-4 py-2 text-sm font-medium text-white">
          Назад в каталог
        </Link>
      </div>
    </main>
  );
}
