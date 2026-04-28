export type Lang = "ru" | "ro" | "en";

export type Product = {
  id: string;
  nameRu: string;
  nameRo: string;
  nameEn: string;
  priceLei: number;
  category: string;
  isPromo: boolean;
};
