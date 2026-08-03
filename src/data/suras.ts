const CDN = 'https://everyayah.com/data/Alafasy_128kbps';
const ayah = (s: number, v: number) =>
  `${CDN}/${String(s).padStart(3, '0')}${String(v).padStart(3, '0')}.mp3`;

export interface Verse {
  arabic: string;
  transliteration: string;
  translation: string;
  audioUrl: string;
}

export interface Sura {
  id: string;
  name: string;
  arabicName: string;
  verses: Verse[];
}

export const SURAS: Sura[] = [
  {
    id: 'fatiha',
    name: 'Al-Fatiha',
    arabicName: 'الفاتحة',
    verses: [
      { arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',              transliteration: 'Bismillāhi r-raḥmāni r-raḥīm',          translation: 'Je commence au nom d\'Allah, Il est très doux et très généreux envers nous', audioUrl: ayah(1,1) },
      { arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',             transliteration: 'Al-ḥamdu lillāhi rabbi l-ʿālamīn',        translation: 'Toutes les louanges appartiennent à Allah, le Maître de tout ce qui existe', audioUrl: ayah(1,2) },
      { arabic: 'الرَّحْمَنِ الرَّحِيمِ',                             transliteration: 'Ar-raḥmāni r-raḥīm',                    translation: 'Il est très doux et très généreux envers nous', audioUrl: ayah(1,3) },
      { arabic: 'مَالِكِ يَوْمِ الدِّينِ',                            transliteration: 'Māliki yawmi d-dīn',                    translation: 'C\'est Lui le Maître du grand Jour où tout le monde sera jugé', audioUrl: ayah(1,4) },
      { arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',         transliteration: 'Iyyāka naʿbudu wa-iyyāka nastaʿīn',     translation: 'C\'est Toi seul qu\'on adore, et c\'est à Toi seul qu\'on demande de l\'aide', audioUrl: ayah(1,5) },
      { arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',                transliteration: 'Ihdinā ṣ-ṣirāṭa l-mustaqīm',           translation: 'Guide-nous sur le bon chemin, le chemin tout droit', audioUrl: ayah(1,6) },
      { arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ',          transliteration: 'Ṣirāṭa llaḏīna anʿamta ʿalayhim',      translation: 'Le chemin de ceux que Tu as comblés de Tes bienfaits', audioUrl: ayah(1,7) },
    ],
  },
  {
    id: 'ikhlas',
    name: 'Al-Ikhlas',
    arabicName: 'الإخلاص',
    verses: [
      { arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',                          transliteration: 'Qul huwa llāhu aḥad',                   translation: 'Dis : Allah est l\'Unique, il n\'y en a qu\'Un seul !', audioUrl: ayah(112,1) },
      { arabic: 'اللَّهُ الصَّمَدُ',                                  transliteration: 'Allāhu ṣ-ṣamad',                      translation: 'Allah n\'a besoin de personne, mais tout le monde a besoin de Lui', audioUrl: ayah(112,2) },
      { arabic: 'لَمْ يَلِدْ وَلَمْ يُولَدْ',                        transliteration: 'Lam yalid wa-lam yūlad',              translation: 'Il n\'a pas d\'enfant, et Lui-même n\'est l\'enfant de personne', audioUrl: ayah(112,3) },
      { arabic: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',                 transliteration: 'Wa-lam yakun lahu kufuwan aḥad',       translation: 'Rien ni personne ne Lui ressemble dans toute la création', audioUrl: ayah(112,4) },
    ],
  },
  {
    id: 'kawthar',
    name: 'Al-Kawthar',
    arabicName: 'الكوثر',
    verses: [
      { arabic: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',                  transliteration: 'Innā aʿṭaynāka l-kawṯar',             translation: 'Nous t\'avons accordé beaucoup de bonnes choses et de bienfaits', audioUrl: ayah(108,1) },
      { arabic: 'فَصَلِّ لِرَبِّكَ وَانْحَرْ',                       transliteration: 'Faṣalli li-rabbika wa-nḥar',           translation: 'Alors fais la prière pour ton Seigneur et offre un sacrifice', audioUrl: ayah(108,2) },
      { arabic: 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',                  transliteration: 'Inna šāniʾaka huwa l-abtar',           translation: 'C\'est celui qui te déteste qui n\'aura rien, pas toi !', audioUrl: ayah(108,3) },
    ],
  },
];
