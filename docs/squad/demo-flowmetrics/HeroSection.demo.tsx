/**
 * FlowMetrics hero — symbiosis demo (not wired to a Next app).
 *
 * Sources:
 * - ui-ux-pro-max: tokens + bento pattern
 * - 21st-design: kinfe123/hero-section-dark (layout inspiration)
 * - huashu-design: motion timing from hero-motion-ref.html
 * - stitch: layout brief in design-tokens-demo.md (MCP was offline)
 */
import type { CSSProperties } from "react";

const tokens = {
  bg: "#0A0E17",
  surface: "rgba(255,255,255,0.06)",
  primary: "#3B82F6",
  cta: "#F59E0B",
  text: "#E2E8F0",
  muted: "#94A3B8",
} as const;

const metrics = [
  { label: "Active users", value: "12.4k" },
  { label: "Deploy / week", value: "47" },
  { label: "Error rate", value: "0.02%" },
  { label: "Uptime", value: "99.97" },
] as const;

const staggerMs = 80; // huashu ref

export function HeroSectionDemo() {
  return (
    <section
      style={{
        position: "relative",
        background: tokens.bg,
        color: tokens.text,
        padding: "4rem 1.5rem",
        overflow: "hidden",
        fontFamily: "'Fira Sans', system-ui, sans-serif",
      }}
    >
      {/* huashu orbs — CSS-only in production */}
      <div aria-hidden style={orbStyle("#1E40AF", "10%", "-5%")} />
      <div aria-hidden style={orbStyle("#3B82F6", "auto", "10%", "15%")} />

      <div
        style={{
          maxWidth: 1100,
          margin: "0 auto",
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(280px, 1fr))",
          gap: "2.5rem",
          alignItems: "center",
        }}
      >
        <div>
          <h1
            style={{
              fontFamily: "'Fira Code', monospace",
              fontSize: "clamp(1.75rem, 4vw, 2.75rem)",
              textShadow: "0 0 24px rgba(59,130,246,0.35)",
              lineHeight: 1.15,
            }}
          >
            See what your team <span style={{ color: tokens.cta }}>ships</span>
          </h1>
          <p style={{ color: tokens.muted, margin: "1rem 0 1.5rem", maxWidth: "28rem" }}>
            Analytics for engineering teams — one bento view for deploys, errors, and uptime.
          </p>
          <div style={{ display: "flex", gap: "0.75rem", flexWrap: "wrap" }}>
            <button type="button" style={btnPrimary}>
              Start free trial
            </button>
            <button type="button" style={btnGhost}>
              View demo
            </button>
          </div>
        </div>

        {/* bento — ui-ux pattern + stitch brief */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: "0.75rem",
          }}
        >
          {metrics.map((m, i) => (
            <div
              key={m.label}
              style={{
                background: tokens.surface,
                border: "1px solid rgba(255,255,255,0.08)",
                borderRadius: "1rem",
                padding: "1.25rem",
                animation: `fmReveal 0.5s ease ${i * staggerMs}ms forwards`,
                opacity: 0,
              }}
            >
              <div
                style={{
                  fontSize: "0.75rem",
                  color: tokens.muted,
                  textTransform: "uppercase",
                  letterSpacing: "0.06em",
                }}
              >
                {m.label}
              </div>
              <div
                style={{
                  fontFamily: "'Fira Code', monospace",
                  fontSize: "1.5rem",
                  fontWeight: 700,
                  color: tokens.primary,
                  marginTop: "0.35rem",
                }}
              >
                {m.value}
              </div>
            </div>
          ))}
        </div>
      </div>

      <style>{`
        @keyframes fmReveal { to { opacity: 1; transform: translateY(0); } }
        @media (prefers-reduced-motion: reduce) {
          [style*="fmReveal"] { animation: none !important; opacity: 1 !important; }
        }
      `}</style>
    </section>
  );
}

function orbStyle(color: string, top: string, left: string, bottom?: string, right?: string): CSSProperties {
  return {
    position: "absolute",
    width: 240,
    height: 240,
    borderRadius: "50%",
    background: color,
    filter: "blur(60px)",
    opacity: 0.4,
    top,
    left,
    bottom,
    right,
    pointerEvents: "none",
  };
}

const btnPrimary: CSSProperties = {
  padding: "0.65rem 1.25rem",
  borderRadius: 9999,
  fontWeight: 600,
  background: tokens.cta,
  color: tokens.bg,
  border: "none",
  cursor: "pointer",
};

const btnGhost: CSSProperties = {
  ...btnPrimary,
  background: "rgba(255,255,255,0.08)",
  color: tokens.text,
  border: "1px solid rgba(255,255,255,0.12)",
};
