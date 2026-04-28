import { getBot, assertSecret } from "@/lib/telegram-bot";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

export async function POST(req: Request) {
  if (!assertSecret(req.headers.get("X-Telegram-Bot-Api-Secret-Token"))) {
    return new Response("Unauthorized", { status: 401 });
  }

  try {
    const update = await req.json();
    await getBot().handleUpdate(update);
  } catch (e) {
    console.error(e);
    return new Response("Bad Request", { status: 400 });
  }
  return new Response("OK", { status: 200 });
}

export async function GET() {
  return new Response("Linella webhook: POST only", { status: 200 });
}
