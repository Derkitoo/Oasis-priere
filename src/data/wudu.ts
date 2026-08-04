export interface WuduStep {
  id: string;
  label: string;
  arabic: string;
  transliteration: string;
  description: string;
  image: string | null;
  times?: number;
  audioUrl?: string;
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
    audioUrl: 'https://everyayah.com/data/Alafasy_128kbps/001001.mp3',
  },
  {
    id: 'mains',
    label: '① Mains',
    arabic: '3×',
    transliteration: '3 fois',
    description:
      "Lave tes deux mains jusqu'aux poignets. Frotte bien entre les doigts. Commence par la main droite.",
    image: 'wudu_mains.png',
    times: 3,
  },
  {
    id: 'bouche',
    label: '② Bouche',
    arabic: '3×',
    transliteration: '3 fois',
    description:
      "Prends de l'eau dans ta main droite, rince ta bouche en la remuant bien, puis recrache. Répète 3 fois.",
    image: 'wudu_bouche.png',
    times: 3,
  },
  {
    id: 'nez',
    label: '③ Nez',
    arabic: '3×',
    transliteration: '3 fois',
    description:
      "Aspire doucement de l'eau dans les narines avec la main droite, puis souffle-la avec la main gauche. Répète 3 fois.",
    image: 'wudu_nez.png',
    times: 3,
  },
  {
    id: 'visage',
    label: '④ Visage',
    arabic: '3×',
    transliteration: '3 fois',
    description:
      "Lave tout ton visage avec les deux mains : du front jusqu'au menton, d'une oreille à l'autre. Répète 3 fois.",
    image: 'wudu_visage.png',
    times: 3,
  },
  {
    id: 'bras',
    label: '⑤ Avant-bras',
    arabic: '3× — يَمِين ثُمَّ يَسَار',
    transliteration: "3 fois — droit d'abord, puis gauche",
    description:
      "Lave l'avant-bras droit jusqu'au coude inclus (3 fois), puis l'avant-bras gauche (3 fois). Commence toujours par le côté droit.",
    image: 'wudu_bras.png',
    times: 3,
  },
  {
    id: 'tete_aller',
    label: '⑥ Tête — vers la nuque',
    arabic: '1×',
    transliteration: 'Premier mouvement',
    description:
      "Pose tes deux mains mouillées à la naissance des cheveux, au-dessus du front, puis fais-les glisser ensemble jusqu'à la nuque.",
    image: 'wudu_tete_aller.png',
    times: 1,
  },
  {
    id: 'tete_retour',
    label: '⑥ Tête — retour au front',
    arabic: '1×',
    transliteration: 'Deuxième mouvement',
    description:
      "Sans remouiller tes mains, ramène-les de la nuque jusqu'au point de départ, à la naissance des cheveux au-dessus du front.",
    image: 'wudu_tete_retour.png',
    times: 1,
  },
  {
    id: 'oreilles',
    label: '⑧ Oreilles',
    arabic: '1×',
    transliteration: '1 fois',
    description:
      "Avec les mains encore mouillées : index à l'intérieur de l'oreille, pouce à l'extérieur. Une fois pour chaque oreille.",
    image: 'wudu_oreilles.png',
    times: 1,
  },
  {
    id: 'pieds',
    label: '⑨ Pieds',
    arabic: '3× — يَمِين ثُمَّ يَسَار',
    transliteration: "3 fois — droit d'abord, puis gauche",
    description:
      "Lave le pied droit jusqu'à la cheville (3 fois) en passant le petit doigt entre les orteils, puis le pied gauche (3 fois).",
    image: 'wudu_pieds.png',
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
    image: 'wudu_dua.png',
    audioUrl:
      'https://translate.google.com/translate_tts?ie=UTF-8&q=%D8%A3%D8%B4%D9%87%D8%AF%20%D8%A3%D9%86%20%D9%84%D8%A7%20%D8%A5%D9%84%D9%87%20%D8%A5%D9%84%D8%A7%20%D8%A7%D9%84%D9%84%D9%87%20%D9%88%D8%AD%D8%AF%D9%87%20%D9%84%D8%A7%20%D8%B4%D8%B1%D9%8A%D9%83%20%D9%84%D9%87%20%D9%88%D8%A3%D8%B4%D9%87%D8%AF%20%D8%A3%D9%86%20%D9%85%D8%AD%D9%85%D8%AF%D8%A7%20%D8%B9%D8%A8%D8%AF%D9%87%20%D9%88%D8%B1%D8%B3%D9%88%D9%84%D9%87&tl=ar&client=tw-ob&ttsspeed=0.6',
  },
];
