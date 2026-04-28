import type { Lang } from "./types";

export type Recipe = {
  id: string;
  title: Record<Lang, string>;
  body: Record<Lang, string>;
};

export const MOCK_RECIPES: Recipe[] = [
  {
    id: "r1",
    title: {
      ru: "Салат «Линелла свежесть»",
      ro: "Salată „Prospețime Linella”",
      en: "Linella Freshness salad",
    },
    body: {
      ru: "Смешайте томаты черри, рукколу, оливковое масло, пармезан. Подавайте с хлебом.",
      ro: "Amestecați roșii cherry, rucola, ulei de măsline, parmezan. Serviți cu franzelă.",
      en: "Toss cherry tomatoes, arugula, olive oil, parmesan. Serve with bread.",
    },
  },
  {
    id: "r2",
    title: {
      ru: "Куриная грудка с овощами",
      ro: "Piept de pui cu legume",
      en: "Chicken breast with vegetables",
    },
    body: {
      ru: "Обжарьте курицу, добавьте яблоки и бананы отдельно как десерт. К овощам — томаты и брокколи из Linella.",
      ro: "Prăjiți puiul. Fructele serviți separat. La garnitură folosiți roșii și legume proaspete.",
      en: "Pan-sear chicken. Pair with fresh produce from the store — tomatoes, apples, bananas for dessert.",
    },
  },
  {
    id: "r3",
    title: {
      ru: "Паста с лососем и сливками",
      ro: "Paste cu somon și smântână",
      en: "Salmon cream pasta",
    },
    body: {
      ru: "Отварите спагетти. Обжарьте филе лосося, добавьте сыр и зелень. Подавайте горячим.",
      ro: "Fierbeți pastele. Sotați somonul, adăugați brânză și verdeață. Serviți fierbinte.",
      en: "Cook spaghetti. Sear salmon, fold in cheese and herbs. Serve hot.",
    },
  },
  {
    id: "r4",
    title: {
      ru: "Завтрак: йогурт и фрукты",
      ro: "Mic dejun: iaurt și fructe",
      en: "Breakfast: yogurt & fruit",
    },
    body: {
      ru: "Греческий йогурт + нарезанные бананы и яблоки. Мёд по желанию.",
      ro: "Iaurt grecesc + banane și mere tăiate. Miere opțional.",
      en: "Greek yogurt + sliced bananas and apples. Honey optional.",
    },
  },
];

export function randomRecipe(): Recipe {
  const i = Math.floor(Math.random() * MOCK_RECIPES.length);
  return MOCK_RECIPES[i]!;
}
