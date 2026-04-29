import { getBot } from "@/lib/telegram-bot";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function isWebhookSecretValid(req: Request): boolean {
  const expected = process.env.WEBHOOK_SECRET;
  if (!expected) return true;
  const received =
    req.headers.get("x-telegram-bot-api-secret-token") ??
    req.headers.get("X-Telegram-Bot-Api-Secret-Token");
  return received === expected;
}

export async function POST(req: Request) {
  if (!isWebhookSecretValid(req)) {
    return new Response("Unauthorized", { status: 401 });
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return new Response("Bad Request", { status: 400 });
  }

  const bot = getBot();
  try {
    await bot.handleUpdate(body);
  } catch (e) {
    console.error(e);
    return new Response("Bad Request", { status: 400 });
  }
  return new Response("OK", { status: 200 });
}
