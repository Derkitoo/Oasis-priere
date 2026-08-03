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
  {
    id: 'nas',
    name: 'An-Nas',
    arabicName: 'الناس',
    verses: [
      { arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',                      transliteration: 'Qul aʿūḏu bi-rabbi n-nās',              translation: 'Dis : Je cherche la protection du Seigneur des hommes', audioUrl: ayah(114,1) },
      { arabic: 'مَلِكِ النَّاسِ',                                    transliteration: 'Maliki n-nās',                          translation: 'Le Roi suprême des hommes', audioUrl: ayah(114,2) },
      { arabic: 'إِلَٰهِ النَّاسِ',                                   transliteration: 'Ilāhi n-nās',                           translation: 'Le Dieu adoré des hommes', audioUrl: ayah(114,3) },
      { arabic: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',                transliteration: 'Min šarri l-waswāsi l-ḫannās',          translation: 'Contre le mal du mauvais conseiller qui s\'esquive', audioUrl: ayah(114,4) },
      { arabic: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',            transliteration: 'Allaḏī yuwaswisu fī ṣudūri n-nās',     translation: 'Qui souffle le mal dans le cœur des hommes', audioUrl: ayah(114,5) },
      { arabic: 'مِنَ الْجِنَّةِ وَالنَّاسِ',                        transliteration: 'Mina l-jinnati wa-n-nās',               translation: 'Qu\'il soit parmi les djinns ou parmi les hommes', audioUrl: ayah(114,6) },
    ],
  },
  {
    id: 'falaq',
    name: 'Al-Falaq',
    arabicName: 'الفلق',
    verses: [
      { arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',                    transliteration: 'Qul aʿūḏu bi-rabbi l-falaq',            translation: 'Dis : Je cherche la protection du Seigneur de l\'aube naissante', audioUrl: ayah(113,1) },
      { arabic: 'مِن شَرِّ مَا خَلَقَ',                              transliteration: 'Min šarri mā ḫalaq',                   translation: 'Contre le mal des êtres qu\'Il a créés', audioUrl: ayah(113,2) },
      { arabic: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',                   transliteration: 'Wa-min šarri ġāsiqin iḏā waqab',        translation: 'Contre le mal de l\'obscurité quand elle s\'installe', audioUrl: ayah(113,3) },
      { arabic: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',           transliteration: 'Wa-min šarri n-naffāṯāti fī l-ʿuqad',   translation: 'Contre le mal de celles qui soufflent sur les nœuds', audioUrl: ayah(113,4) },
      { arabic: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',                   transliteration: 'Wa-min šarri ḥāsidin iḏā ḥasad',        translation: 'Et contre le mal de l\'envieux quand il envie', audioUrl: ayah(113,5) },
    ],
  },
  {
    id: 'nasr',
    name: 'An-Nasr',
    arabicName: 'النصر',
    verses: [
      { arabic: 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',             transliteration: 'Iḏā jāʾa naṣru llāhi wa-l-fatḥ',        translation: 'Lorsque viennent le secours d\'Allah et la victoire', audioUrl: ayah(110,1) },
      { arabic: 'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا', transliteration: 'Wa-raʾayta n-nāsa yadḫulūna fī dīni llāhi afwājā', translation: 'Et que tu vois les gens entrer en foule dans la religion d\'Allah', audioUrl: ayah(110,2) },
      { arabic: 'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا', transliteration: 'Fa-sabbiḥ bi-ḥamdi rabbika wa-staġfirh innahū kāna tawwābā', translation: 'Alors célèbre les louanges de ton Seigneur et demande Son pardon. Il accepte toujours le repentir !', audioUrl: ayah(110,3) },
    ],
  },
  {
    id: 'asr',
    name: 'Al-Asr',
    arabicName: 'العصر',
    verses: [
      { arabic: 'وَالْعَصْرِ',                                        transliteration: 'Wa-l-ʿaṣr',                             translation: 'Par le Temps qui passe !', audioUrl: ayah(103,1) },
      { arabic: 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',                     transliteration: 'Inna l-insāna la-fī ḫusr',              translation: 'L\'être humain est vraiment en train de tout perdre', audioUrl: ayah(103,2) },
      { arabic: 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ', transliteration: 'Illā llaḏīna āmanū wa-ʿamilū ṣ-ṣāliḥāti wa-tawāṣaw bi-l-ḥaqqi wa-tawāṣaw bi-ṣ-ṣabr', translation: 'Sauf ceux qui croient, font de bonnes actions, et s\'encouragent à la vérité et à la patience', audioUrl: ayah(103,3) },
    ],
  },
];
