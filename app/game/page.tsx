import Link from "next/link";
import { DiscountScratch } from "@/components/DiscountScratch";

export const metadata = {
  title: "Linella · Ловец скидок",
};

export default function GamePage() {
  return (
    <main className="mx-auto flex min-h-dvh max-w-lg flex-col gap-6 px-4 py-10">
      <div className="flex items-center justify-between gap-3">
        <div>
          <p className="text-xs uppercase tracking-[0.25em] text-white/50">Linella</p>
          <h1 className="text-2xl font-semibold">Ловец скидок</h1>
        </div>
        <Link href="/" className="text-sm text-white/70 underline-offset-4 hover:text-white hover:underline">
          Каталог
        </Link>
      </div>
      <DiscountScratch />
    </main>
  );
}
