export interface WuduStep {
  id: string;
  label: string;
  arabic: string;
  transliteration: string;
  description: string;
  image: string | null; // null = pas d'image PDF (étape textuelle)
  times?: number;
}

export const WUDU_STEPS: WuduStep[] = [
  {
    id: 'niyyah',
    label: 'Intention & Bismillâh',
    arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
    transliteration: 'Bismi-llâhi r-rahmâni r-rahîm',
    description:
      "Fais l'intention dans ton cœur de faire les ablutions pour la prière. Prononce « BismiLlâh » à voix basse avant de commencer.",
    image: null,
  },
  {
    id: 'mains',
    label: '① Mains',
    arabic: '٣×',
    transliteration: '3 fois',
    description:
      "Lave tes deux mains jusqu'aux poignets. Frotte bien entre les doigts. Commence par la main droite.",
    image: 'wudu_p2_1.png',
    times: 3,
  },
  {
    id: 'bouche',
    label: '② Bouche',
    arabic: '٣×',
    transliteration: '3 fois',
    description:
      "Prends de l'eau dans ta main droite, rince ta bouche en la remuant bien, puis recrache. Répète 3 fois.",
    image: 'wudu_p2_2.jpg',
    times: 3,
  },
  {
    id: 'nez',
    label: '③ Nez',
    arabic: '٣×',
    transliteration: '3 fois',
    description:
      "Aspire doucement de l'eau dans les narines avec la main droite, puis souffle-la avec la main gauche. Répète 3 fois.",
    image: 'wudu_p2_3.jpg',
    times: 3,
  },
  {
    id: 'visage',
    label: '④ Visage',
    arabic: '٣×',
    transliteration: '3 fois',
    description:
      "Lave tout ton visage avec les deux mains : du front jusqu'au menton, d'une oreille à l'autre. Répète 3 fois.",
    image: 'wudu_p2_4.jpg',
    times: 3,
  },
  {
    id: 'bras',
    label: '⑤ Avant-bras',
    arabic: '٣× يَمِين ثُمَّ يَسَار',
    transliteration: '3 fois — droit d\'abord, puis gauche',
    description:
      "Lave l'avant-bras droit jusqu'au coude inclus (3 fois), puis l'avant-bras gauche (3 fois). Commence toujours par le côté droit.",
    image: 'wudu_p2_5.jpg',
    times: 3,
  },
  {
    id: 'cheveux',
    label: '⑥ Cheveux (Massah)',
    arabic: '١×',
    transliteration: '1 fois',
    description:
      "Mouille tes deux mains et passe-les sur toute la tête : de l'avant vers l'arrière, puis retour. Une seule fois suffit.",
    image: 'wudu_p2_6.jpg',
    times: 1,
  },
  {
    id: 'oreilles',
    label: '⑦ Oreilles',
    arabic: '١×',
    transliteration: '1 fois',
    description:
      "Avec les mains encore mouillées : index à l'intérieur de l'oreille, pouce à l'extérieur. Une fois pour chaque oreille.",
    image: 'wudu_p3_0.jpg',
    times: 1,
  },
  {
    id: 'pieds',
    label: '⑧ Pieds',
    arabic: '٣× يَمِين ثُمَّ يَسَار',
    transliteration: '3 fois — droit d\'abord, puis gauche',
    description:
      "Lave le pied droit jusqu'à la cheville (3 fois) en passant le petit doigt entre les orteils, puis le pied gauche (3 fois).",
    image: 'wudu_p3_1.jpg',
    times: 3,
  },
  {
    id: 'dua',
    label: 'Dua final',
    arabic:
      'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ\nوَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
    transliteration:
      "Achhado an lâ ilêha illAllâhou waHdahou lâ charîka lah\nwa achhado anna Mouhammadan 'abdouhou wa rasoûlouhou",
    description:
      "Lève les yeux vers le ciel et récite cette invocation. Tes ablutions sont complètes — tu peux maintenant faire la prière !",
    image: 'wudu_p3_2.jpg',
  },
];
