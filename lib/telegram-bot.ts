import { readFile } from "node:fs/promises";
import path from "node:path";
import { Telegraf, Markup } from "telegraf";
import { tr } from "./i18n";
import { findProductsByText, productLabel } from "./products";
import { randomRecipe } from "./recipes";
import type { Lang } from "./types";
import { getLang, isListMode, setLang, setListMode } from "./user-state";

function appOrigin(): string {
  const u = process.env.NEXT_PUBLIC_APP_URL?.replace(/\/$/, "");
  if (u) return u;
  const v = process.env.VERCEL_URL;
  if (v) return `https://${v}`;
  return "http://localhost:3000";
}

function webAppUrl(pathname: string, query?: Record<string, string>): string {
  const o = new URL(appOrigin());
  o.pathname = pathname;
  if (query) {
    for (const [k, v] of Object.entries(query)) o.searchParams.set(k, v);
  }
  return o.toString();
}

let botInstance: Telegraf | null = null;

/** Token: set `BOT_TOKEN` in `.env` / Vercel (BotFather). */
export function getBot(): Telegraf {
  const token = process.env.BOT_TOKEN;
  if (!token) {
    throw new Error("BOT_TOKEN is not set");
  }
  if (!botInstance) {
    botInstance = new Telegraf(token);
    register(botInstance);
  }
  return botInstance;
}

function langKb() {
  return Markup.inlineKeyboard([
    [
      Markup.button.callback("🇷🇺 RU", "lang:ru"),
      Markup.button.callback("🇲🇩 RO", "lang:ro"),
    ],
    [Markup.button.callback("🇬🇧 EN", "lang:en")],
  ]);
}

function mainMenuKb(lang: Lang) {
  const origin = appOrigin();
  return Markup.inlineKeyboard([
    [
      Markup.button.webApp(tr("btnCatalog", lang), `${origin}/`),
      Markup.button.callback(tr("btnRecipes", lang), "feat:recipes"),
    ],
    [
      Markup.button.callback(tr("btnScanner", lang), "feat:scanner_info"),
      Markup.button.callback(tr("btnList", lang), "feat:list_start"),
    ],
    [Markup.button.callback(tr("btnLang", lang), "menu:lang")],
  ]);
}

function register(bot: Telegraf) {
  bot.start(async (ctx) => {
    const uid = ctx.from?.id;
    if (!uid) return;

    try {
      const welcomePath = path.join(process.cwd(), "public", "welcome.png");
      const photo = await readFile(welcomePath);

      await ctx.replyWithPhoto(
        { source: photo },
        { caption: tr("welcomeCaption", "ro"), ...langKb() }
      );
    } catch {
      console.log("Картинка не найдена, отправляем просто текст.");
      await ctx.reply(tr("welcomeCaption", "ro"), langKb());
    }
  });

  bot.action(/^lang:(ru|ro|en)$/, async (ctx) => {
    await ctx.answerCbQuery();
    const lang = ctx.match[1] as Lang;
    const uid = ctx.from!.id;
    setLang(uid, lang);
    await ctx.editMessageCaption(`✅ ${tr("langSet", lang)}`, {
      reply_markup: { inline_keyboard: [] },
    }).catch(async () => {
      await ctx.editMessageText(`✅ ${tr("langSet", lang)}`, {
        reply_markup: { inline_keyboard: [] },
      });
    });
    await ctx.reply(`${tr("mainMenuHint", lang)}`, mainMenuKb(lang));
  });

  bot.action("menu:lang", async (ctx) => {
    await ctx.answerCbQuery();
    const uid = ctx.from!.id;
    const lang = getLang(uid);
    await ctx.reply(tr("welcomeCaption", lang), langKb());
  });

  bot.action("menu:main", async (ctx) => {
    await ctx.answerCbQuery();
    const uid = ctx.from!.id;
    const lang = getLang(uid);
    await ctx.reply(tr("mainMenuHint", lang), mainMenuKb(lang));
  });

  bot.action("feat:recipes", async (ctx) => {
    await ctx.answerCbQuery();
    const uid = ctx.from!.id;
    const lang = getLang(uid);
    const r = randomRecipe();
    const text = `🍳 ${tr("recipesTitle", lang)}\n\n${tr("recipesPick", lang)}\n<b>${r.title[lang]}</b>\n\n${r.body[lang]}`;
    const cartUrl = webAppUrl("/", { intent: "recipe", rid: r.id });
    await ctx.replyWithHTML(
      text,
      Markup.inlineKeyboard([
        [Markup.button.webApp(tr("btnCartWeb", lang), cartUrl), Markup.button.callback("↩️", "menu:main")],
      ])
    );
  });

  bot.action("feat:scanner_info", async (ctx) => {
    await ctx.answerCbQuery();
    const uid = ctx.from!.id;
    const lang = getLang(uid);
    await ctx.reply(`🧾 ${tr("scannerTitle", lang)}\n\n📷 ${tr("scannerHint", lang)}`);
  });

  bot.action("feat:list_start", async (ctx) => {
    await ctx.answerCbQuery();
    const uid = ctx.from!.id;
    const lang = getLang(uid);
    setListMode(uid, true);
    await ctx.reply(`📝 ${tr("listPrompt", lang)}`);
  });

  bot.on("photo", async (ctx) => {
    const uid = ctx.from?.id;
    if (!uid) return;
    const lang = getLang(uid);
    const wait = await ctx.reply(`🧾 ${tr("scannerWait", lang)}`);
    await new Promise((r) => setTimeout(r, 2000));
    const gameUrl = webAppUrl("/game");
    try {
      await ctx.telegram.deleteMessage(wait.chat.id, wait.message_id);
    } catch {}
    await ctx.reply(`✅ ${tr("scannerOk", lang)}`, Markup.inlineKeyboard([[Markup.button.webApp(tr("playGameBtn", lang), gameUrl)]]));
  });

  bot.on("text", async (ctx, next) => {
    const text = ctx.message.text ?? "";
    if (text.startsWith("/")) return next();

    const uid = ctx.from!.id;
    const lang = getLang(uid);

    if (isListMode(uid)) {
      setListMode(uid, false);
      const found = findProductsByText(text);
      if (found.length === 0) {
        await ctx.reply(tr("listEmpty", lang));
        return;
      }
      const lines = found.map((p) => `• ${productLabel(p, lang)} — ${p.priceLei.toFixed(2)} MDL`);
      const body = `${tr("listTitle", lang)}\n\n${lines.join("\n")}`;
      const ids = found.map((p) => p.id).join(",");
      const checkout = webAppUrl("/checkout", { ids });
      await ctx.reply(body, Markup.inlineKeyboard([[Markup.button.webApp(tr("btnCheckout", lang), checkout)]]));
      return;
    }

    await ctx.reply(tr("fallback", lang));
  });

  bot.catch((err) => {
    console.error("telegraf error", err);
  });
}

export function assertSecret(header: string | null): boolean {
  const expected = process.env.WEBHOOK_SECRET;
  if (!expected) return true;
  return header === expected;
}