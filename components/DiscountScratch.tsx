"use client";

import { useCallback, useEffect, useRef, useState } from "react";

const CODE = "LINELLA5";
const W = 320;
const H = 180;

export function DiscountScratch() {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const [done, setDone] = useState(false);
  const [progress, setProgress] = useState(0);
  const drawing = useRef(false);

  const paint = useCallback((x: number, y: number) => {
    const c = canvasRef.current;
    if (!c) return;
    const ctx = c.getContext("2d");
    if (!ctx) return;
    ctx.globalCompositeOperation = "destination-out";
    ctx.beginPath();
    ctx.arc(x, y, 16, 0, Math.PI * 2);
    ctx.fill();
  }, []);

  useEffect(() => {
    const c = canvasRef.current;
    if (!c) return;
    const ctx = c.getContext("2d");
    if (!ctx) return;
    const g = ctx.createLinearGradient(0, 0, W, H);
    g.addColorStop(0, "#e30613");
    g.addColorStop(1, "#9f040d");
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, W, H);
    ctx.fillStyle = "rgba(255,255,255,0.35)";
    ctx.font = "700 16px system-ui";
    ctx.fillText("Сотри слой", W / 2 - 48, H / 2);
  }, []);

  useEffect(() => {
    const id = window.setInterval(() => {
      const c = canvasRef.current;
      if (!c) return;
      const ctx = c.getContext("2d");
      if (!ctx) return;
      const d = ctx.getImageData(0, 0, W, H).data;
      let clear = 0;
      for (let i = 3; i < d.length; i += 4) if (d[i] === 0) clear++;
      const p = clear / (W * H);
      setProgress(Math.min(100, Math.round(p * 120)));
      if (p > 0.38 && !done) setDone(true);
    }, 320);
    return () => clearInterval(id);
  }, [done]);

  const onMove = (e: React.MouseEvent | React.TouchEvent) => {
    const c = canvasRef.current;
    if (!c || !drawing.current) return;
    const r = c.getBoundingClientRect();
    const cx = "touches" in e ? e.touches[0]!.clientX : e.clientX;
    const cy = "touches" in e ? e.touches[0]!.clientY : e.clientY;
    paint(cx - r.left, cy - r.top);
  };

  return (
    <div className="glass-panel mx-auto w-full max-w-[360px] p-4">
      <p className="text-sm text-white/80">Скрач-карта: сотрите серебряный слой.</p>
      <div className="relative mx-auto mt-4 h-[180px] w-[320px] overflow-hidden rounded-2xl border border-white/15">
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-zinc-900/80 text-center">
          <p className="text-xs uppercase tracking-[0.2em] text-white/50">Промокод</p>
          <p className="mt-2 text-3xl font-black tracking-widest text-emerald-300">{CODE}</p>
          <p className="mt-1 text-sm text-white/70">−5% la cumpărături</p>
        </div>
        <canvas
          ref={canvasRef}
          width={W}
          height={H}
          className="absolute inset-0 cursor-crosshair touch-none"
          onMouseDown={() => {
            drawing.current = true;
          }}
          onMouseUp={() => {
            drawing.current = false;
          }}
          onMouseLeave={() => {
            drawing.current = false;
          }}
          onMouseMove={onMove}
          onTouchStart={(e) => {
            drawing.current = true;
            onMove(e);
          }}
          onTouchEnd={() => {
            drawing.current = false;
          }}
          onTouchMove={onMove}
        />
      </div>
      <p className="mt-3 text-xs text-white/55">Прогресс: {progress}%</p>
      {done && (
        <p className="mt-2 rounded-xl border border-white/15 bg-white/5 px-3 py-2 text-xs text-white/80">
          Скидка действует при чеке от 300 леев. Покажите код на кассе Linella (demo).
        </p>
      )}
    </div>
  );
}
