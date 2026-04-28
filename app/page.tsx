import Link from "next/link";
import products from "@/data/products.json";
import type { Product } from "@/lib/types";

const list = products as Product[];

function GlassCard({ children, className = "" }: { children: React.ReactNode; className?: string }) {
  return <div className={`glass-panel p-4 sm:p-5 ${className}`}>{children}</div>;
}

export default async function HomePage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const q = await searchParams;
  const intent = typeof q.intent === "string" ? q.intent : undefined;
  const cats = [...new Set(list.map((p) => p.category))];

  return (
    <main className="relative mx-auto max-w-6xl px-4 py-8 sm:py-12">
      <div className="pointer-events-none absolute inset-0 opacity-60">
        <div className="absolute left-[-20%] top-[-10%] h-96 w-96 rounded-full bg-[#e30613]/25 blur-[120px]" />
        <div className="absolute bottom-[-20%] right-[-15%] h-96 w-96 rounded-full bg-white/10 blur-[120px]" />
      </div>

      <header className="relative bento sm:grid-cols-[1.2fr_1fr]">
        <GlassCard className="sm:col-span-2">
          <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <p className="text-xs uppercase tracking-[0.3em] text-white/50">Linella</p>
              <h1 className="mt-2 text-3xl font-semibold sm:text-4xl">Catalog</h1>
              <p className="mt-2 max-w-xl text-sm text-white/70">
                Glassmorphism + bento layout. Brand: #e30613 + white.
              </p>
            </div>
            <div className="flex flex-wrap gap-2">
              <Link
                href="/game"
                className="rounded-xl border border-white/15 bg-[#e30613]/90 px-4 py-2 text-sm font-medium text-white shadow-lg shadow-[#e30613]/30 transition hover:bg-[#e30613]"
              >
                Ловец скидок
              </Link>
              <a
                className="rounded-xl border border-white/15 bg-white/10 px-4 py-2 text-sm font-medium text-white/90"
                href="https://linella.md/ro"
                target="_blank"
                rel="noreferrer"
              >
                linella.md
              </a>
            </div>
          </div>
          {intent === "recipe" && (
            <p className="mt-4 rounded-xl border border-[#e30613]/30 bg-[#e30613]/10 px-3 py-2 text-sm text-white/90">
              Рецепт открыт из бота — добавьте товары в корзину вручную (mock).
            </p>
          )}
        </GlassCard>

        <GlassCard>
          <p className="text-xs uppercase tracking-widest text-white/50">Категории</p>
          <ul className="mt-3 flex flex-wrap gap-2">
            {cats.map((c) => (
              <li
                key={c}
                className="rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs capitalize text-white/80"
              >
                {c}
              </li>
            ))}
          </ul>
        </GlassCard>

        <GlassCard>
          <p className="text-xs uppercase tracking-widest text-white/50">Мини-игра</p>
          <p className="mt-2 text-sm text-white/70">Скрач-карта — промокод 5% при чеке от 300 lei.</p>
          <Link
            href="/game"
            className="mt-4 inline-flex rounded-xl bg-white/90 px-4 py-2 text-sm font-semibold text-zinc-900"
          >
            Играть
          </Link>
        </GlassCard>
      </header>

      <section className="relative mt-8">
        <h2 className="mb-4 text-lg font-medium text-white/90">Товары</h2>
        <div className="bento sm:grid-cols-2 lg:grid-cols-3">
          {list.map((p) => (
            <GlassCard key={p.id}>
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="text-sm font-semibold leading-snug">{p.nameRu}</p>
                  <p className="mt-1 text-xs capitalize text-white/50">{p.category}</p>
                </div>
                {p.isPromo && (
                  <span className="shrink-0 rounded-full border border-[#e30613]/40 bg-[#e30613]/20 px-2 py-0.5 text-[10px] font-semibold uppercase tracking-wide text-[#ffb4b9]">
                    promo
                  </span>
                )}
              </div>
              <p className="mt-4 text-2xl font-bold text-white">
                {p.priceLei.toFixed(2)}{" "}
                <span className="text-sm font-normal text-white/60">MDL</span>
              </p>
            </GlassCard>
          ))}
        </div>
      </section>
    </main>
  );
}
