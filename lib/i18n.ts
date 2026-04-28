import type { Lang } from "./types";

const T = {
  welcomeCaption: {
    ru: "Linella — ваш супермаркет каждый день. Выберите язык:",
    ro: "Linella — supermarketul tău zi de zi. Alegeți limba:",
    en: "Linella — your supermarket every day. Choose a language:",
  },
  langSet: {
    ru: "Язык: Русский",
    ro: "Limbă: Română",
    en: "Language: English",
  },
  mainMenuHint: {
    ru: "Главное меню (Bento):",
    ro: "Meniu principal (Bento):",
    en: "Main menu (Bento):",
  },
  fallback: {
    ru: "Не понял команду. Нажмите /start",
    ro: "Nu am înțeles comanda. Apăsați /start",
    en: "I did not understand. Please send /start",
  },
  recipesTitle: {
    ru: "Нейро-рецепты",
    ro: "Rețete neuro",
    en: "Neuro recipes",
  },
  recipesPick: {
    ru: "Ваш рецепт дня:",
    ro: "Rețeta zilei:",
    en: "Your recipe of the day:",
  },
  btnCartWeb: {
    ru: "Собрать корзину в Web App",
    ro: "Colectează coșul în Web App",
    en: "Build cart in Web App",
  },
  scannerTitle: {
    ru: "Сканер чеков",
    ro: "Scanner bonuri",
    en: "Receipt scanner",
  },
  scannerWait: {
    ru: "Анализируем чек…",
    ro: "Analizăm bonul…",
    en: "Analyzing receipt…",
  },
  scannerOk: {
    ru: "Чек принят! Вам начислен 1 билет для мини-игры.",
    ro: "Bon acceptat! Ai primit 1 bilet pentru mini-joc.",
    en: "Receipt accepted! You got 1 ticket for the mini-game.",
  },
  playGameBtn: {
    ru: "Игра «Ловец скидок»",
    ro: "Joc „Prinzător de reduceri”",
    en: "Discount Catcher game",
  },
  listPrompt: {
    ru: "Напишите продукты через запятую (например: молоко, яблоки, йогурт).",
    ro: "Scrieți produsele separate prin virgulă (ex.: lapte, mere, iaurt).",
    en: "List products separated by commas (e.g. milk, apples, yogurt).",
  },
  listTitle: {
    ru: "Найдено в Linella:",
    ro: "Găsite la Linella:",
    en: "Found at Linella:",
  },
  listEmpty: {
    ru: "Ничего не нашли по запросу. Попробуйте другие слова.",
    ro: "Nu am găsit nimic. Încercați alte cuvinte.",
    en: "Nothing found. Try other words.",
  },
  btnCheckout: {
    ru: "Оформить",
    ro: "Finalizează",
    en: "Checkout",
  },
  btnCatalog: {
    ru: "Каталог",
    ro: "Catalog",
    en: "Catalog",
  },
  btnRecipes: {
    ru: "Нейро-рецепты",
    ro: "Rețete",
    en: "Recipes",
  },
  btnScanner: {
    ru: "Сканер чеков",
    ro: "Scanner bon",
    en: "Receipt scan",
  },
  btnList: {
    ru: "Умный список",
    ro: "Listă inteligentă",
    en: "Smart list",
  },
  btnLang: {
    ru: "Язык",
    ro: "Limbă",
    en: "Language",
  },
  scannerHint: {
    ru: "Пришлите фото кассового чека.",
    ro: "Trimiteți o fotografie a bonului fiscal.",
    en: "Send a photo of your receipt.",
  },
} as const;

export function tr<K extends keyof typeof T>(key: K, lang: Lang): string {
  return T[key][lang];
}
