export interface Sura {
  id: string;
  name: string;
  arabicName: string;
  verses: { arabic: string; transliteration: string; translation: string }[];
}

export const SURAS: Sura[] = [
  {
    id: 'fatiha',
    name: 'Al-Fatiha',
    arabicName: 'الفاتحة',
    verses: [
      { arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ', transliteration: 'Bismillāhi r-raḥmāni r-raḥīm', translation: 'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux' },
      { arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', transliteration: 'Al-ḥamdu lillāhi rabbi l-ʿālamīn', translation: 'Louange à Allah, Seigneur de l\'univers' },
      { arabic: 'الرَّحْمَنِ الرَّحِيمِ', transliteration: 'Ar-raḥmāni r-raḥīm', translation: 'Le Tout Miséricordieux, le Très Miséricordieux' },
      { arabic: 'مَالِكِ يَوْمِ الدِّينِ', transliteration: 'Māliki yawmi d-dīn', translation: 'Maître du Jour de la rétribution' },
      { arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', transliteration: 'Iyyāka naʿbudu wa-iyyāka nastaʿīn', translation: 'C\'est Toi [Seul] que nous adorons, et c\'est Toi [Seul] dont nous implorons le secours' },
      { arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', transliteration: 'Ihdinā ṣ-ṣirāṭa l-mustaqīm', translation: 'Guide-nous dans le droit chemin' },
      { arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ', transliteration: 'Ṣirāṭa llaḏīna anʿamta ʿalayhim', translation: 'Le chemin de ceux que Tu as comblés de bienfaits' },
    ],
  },
  {
    id: 'ikhlas',
    name: 'Al-Ikhlas',
    arabicName: 'الإخلاص',
    verses: [
      { arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ', transliteration: 'Qul huwa llāhu aḥad', translation: 'Dis : "Il est Allah, Unique"' },
      { arabic: 'اللَّهُ الصَّمَدُ', transliteration: 'Allāhu ṣ-ṣamad', translation: 'Allah, le Seul à être imploré pour ce que nous désirons' },
      { arabic: 'لَمْ يَلِدْ وَلَمْ يُولَدْ', transliteration: 'Lam yalid wa-lam yūlad', translation: 'Il n\'a jamais engendré, n\'a pas été engendré non plus' },
      { arabic: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', transliteration: 'Wa-lam yakun lahu kufuwan aḥad', translation: 'Et nul n\'est égal à Lui' },
    ],
  },
  {
    id: 'kawthar',
    name: 'Al-Kawthar',
    arabicName: 'الكوثر',
    verses: [
      { arabic: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ', transliteration: 'Innā aʿṭaynāka l-kawṯar', translation: 'Nous t\'avons certes donné l\'Abondance' },
      { arabic: 'فَصَلِّ لِرَبِّكَ وَانْحَرْ', transliteration: 'Faṣalli li-rabbika wa-nḥar', translation: 'Accomplis donc la Salat pour ton Seigneur et sacrifie' },
      { arabic: 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ', transliteration: 'Inna šāniʾaka huwa l-abtar', translation: 'C\'est bien ton ennemi qui est sans postérité' },
    ],
  },
];
