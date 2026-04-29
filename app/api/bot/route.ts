import { getBot } from "@/lib/telegram-bot";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

/**
 * Incoming Telegram webhook: POST JSON update.
 * Validates `x-telegram-bot-api-secret-token` against `WEBHOOK_SECRET`
 * (omit `WEBHOOK_SECRET` locally only if webhook is configured without secret).
 */
export async function POST(req: Request) {
  const expected = process.env.WEBHOOK_SECRET;
  const received =
    req.headers.get("x-telegram-bot-api-secret-token") ??
    req.headers.get("X-Telegram-Bot-Api-Secret-Token");

  if (expected && received !== expected) {
    return new Response("Unauthorized", { status: 401 });
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return new Response("Bad Request", { status: 400 });
  }

  try {
    const bot = getBot();
    await bot.handleUpdate(body);
  } catch (e) {
    console.error(e);
    return new Response("Bad Request", { status: 400 });
  }

  return new Response("OK", { status: 200 });
}
