import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Linella · Web App",
  description: "Linella supermarket Web App",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ro">
      <body className="min-h-dvh antialiased bg-gradient-to-br from-zinc-950 via-zinc-900 to-zinc-950 text-white">
        {children}
      </body>
    </html>
  );
}
