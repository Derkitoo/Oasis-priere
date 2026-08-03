class SuraLine {
  final String arabic;
  final String phonetic;
  final String french;

  const SuraLine({required this.arabic, required this.phonetic, required this.french});
}

class SuraData {
  final String id;
  final String nameAr;
  final String nameFr;
  final String number;
  final List<SuraLine> verses;
  final int gradeRequired;

  const SuraData({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.number,
    required this.verses,
    required this.gradeRequired,
  });
}

class SurasData {
  static const SuraData fatiha = SuraData(
    id: 'fatiha',
    nameAr: 'الفاتحة',
    nameFr: 'L\'Ouvrante',
    number: '1',
    gradeRequired: 2,
    verses: [
      SuraLine(
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        phonetic: 'Bismillāhi r-raḥmāni r-raḥīm',
        french: 'Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux',
      ),
      SuraLine(
        arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        phonetic: 'Al-ḥamdu lillāhi rabbi l-ʿālamīn',
        french: 'Louange à Allah, Seigneur des mondes',
      ),
      SuraLine(
        arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
        phonetic: 'Ar-raḥmāni r-raḥīm',
        french: 'Le Tout Miséricordieux, le Très Miséricordieux',
      ),
      SuraLine(
        arabic: 'مَالِكِ يَوْمِ الدِّينِ',
        phonetic: 'Māliki yawmi d-dīn',
        french: 'Maître du Jour de la Rétribution',
      ),
      SuraLine(
        arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        phonetic: 'Iyyāka naʿbudu wa-iyyāka nastaʿīn',
        french: 'C\'est Toi que nous adorons et c\'est Toi dont nous implorons le secours',
      ),
      SuraLine(
        arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        phonetic: 'Ihdinā ṣ-ṣirāṭa l-mustaqīm',
        french: 'Guide-nous dans le droit chemin',
      ),
      SuraLine(
        arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        phonetic: 'Ṣirāṭa llaḏīna anʿamta ʿalayhim ġayri l-maġḍūbi ʿalayhim wa-lā ḍ-ḍāllīn',
        french: 'Le chemin de ceux que Tu as comblés de bienfaits, pas de ceux qui ont encouru Ta colère, ni des égarés',
      ),
    ],
  );

  static const SuraData ikhlas = SuraData(
    id: 'ikhlas',
    nameAr: 'الإخلاص',
    nameFr: 'La Pureté',
    number: '112',
    gradeRequired: 2,
    verses: [
      SuraLine(
        arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        phonetic: 'Qul huwa llāhu aḥad',
        french: 'Dis : "Il est Allah, Unique"',
      ),
      SuraLine(
        arabic: 'اللَّهُ الصَّمَدُ',
        phonetic: 'Allāhu ṣ-ṣamad',
        french: 'Allah, le Seul à être imploré pour ce que nous désirons',
      ),
      SuraLine(
        arabic: 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        phonetic: 'Lam yalid wa-lam yūlad',
        french: 'Il n\'a jamais engendré, n\'a pas été engendré non plus',
      ),
      SuraLine(
        arabic: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        phonetic: 'Wa-lam yakun lahu kufuwan aḥad',
        french: 'Et nul n\'est égal à Lui',
      ),
    ],
  );

  static const SuraData kawthar = SuraData(
    id: 'kawthar',
    nameAr: 'الكوثر',
    nameFr: 'L\'Abondance',
    number: '108',
    gradeRequired: 2,
    verses: [
      SuraLine(
        arabic: 'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ',
        phonetic: 'Innā aʿṭaynāka l-kawṯar',
        french: 'Nous t\'avons accordé l\'Abondance',
      ),
      SuraLine(
        arabic: 'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
        phonetic: 'Faṣalli li-rabbika wa-nḥar',
        french: 'Accomplis la prière pour ton Seigneur et sacrifie',
      ),
      SuraLine(
        arabic: 'إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
        phonetic: 'Inna šāni\'aka huwa l-abtar',
        french: 'Car c\'est bien ton ennemi qui sera sans postérité',
      ),
    ],
  );

  static const SuraData nas = SuraData(
    id: 'nas',
    nameAr: 'الناس',
    nameFr: 'Les Hommes',
    number: '114',
    gradeRequired: 2,
    verses: [
      SuraLine(
        arabic: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
        phonetic: 'Qul aʿūḏu bi-rabbi n-nās',
        french: 'Dis : "Je cherche protection auprès du Seigneur des hommes"',
      ),
      SuraLine(
        arabic: 'مَلِكِ النَّاسِ',
        phonetic: 'Maliki n-nās',
        french: '"Le Maître des hommes"',
      ),
      SuraLine(
        arabic: 'إِلَٰهِ النَّاسِ',
        phonetic: 'Ilāhi n-nās',
        french: '"Le Dieu des hommes"',
      ),
      SuraLine(
        arabic: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ',
        phonetic: 'Min šarri l-waswāsi l-ḫannās',
        french: '"Contre le mal du tentateur sournois"',
      ),
      SuraLine(
        arabic: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ',
        phonetic: 'Allaḏī yuwaswisu fī ṣudūri n-nās',
        french: '"Qui souffle le mal dans les poitrines des hommes"',
      ),
      SuraLine(
        arabic: 'مِنَ الْجِنَّةِ وَالنَّاسِ',
        phonetic: 'Mina l-jinnati wa-n-nās',
        french: '"Qu\'il soit djinn ou être humain"',
      ),
    ],
  );

  static const SuraData falaq = SuraData(
    id: 'falaq',
    nameAr: 'الفلق',
    nameFr: 'L\'Aube naissante',
    number: '113',
    gradeRequired: 2,
    verses: [
      SuraLine(
        arabic: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ',
        phonetic: 'Qul aʿūḏu bi-rabbi l-falaq',
        french: 'Dis : "Je cherche protection auprès du Seigneur de l\'aube naissante"',
      ),
      SuraLine(
        arabic: 'مِن شَرِّ مَا خَلَقَ',
        phonetic: 'Min šarri mā khalaq',
        french: 'Contre le mal des êtres qu\'Il a créés',
      ),
      SuraLine(
        arabic: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ',
        phonetic: 'Wa-min šarri ġāsiqin iḏā waqab',
        french: 'Contre le mal de l\'obscurité quand elle s\'approfondit',
      ),
      SuraLine(
        arabic: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ',
        phonetic: 'Wa-min šarri n-naffāṯāti fī l-ʿuqad',
        french: 'Contre le mal de celles qui soufflent sur les nœuds',
      ),
      SuraLine(
        arabic: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        phonetic: 'Wa-min šarri ḥāsidin iḏā ḥasad',
        french: 'Et contre le mal de l\'envieux quand il envie',
      ),
    ],
  );

  static const SuraData nasr = SuraData(
    id: 'nasr',
    nameAr: 'النصر',
    nameFr: 'Le Secours',
    number: '110',
    gradeRequired: 3,
    verses: [
      SuraLine(
        arabic: 'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ',
        phonetic: 'Iḏā jā\'a naṣru llāhi wa-l-fatḥ',
        french: 'Lorsque viennent le secours d\'Allah et la victoire',
      ),
      SuraLine(
        arabic: 'وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا',
        phonetic: 'Wa-ra\'ayta n-nāsa yadḫulūna fī dīni llāhi afwājā',
        french: 'Et que tu vois les gens entrer en foule dans la religion d\'Allah',
      ),
      SuraLine(
        arabic: 'فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا',
        phonetic: 'Fa-sabbiḥ bi-ḥamdi rabbika wa-staġfirh, innahū kāna tawwābā',
        french: 'Alors célèbre les louanges de ton Seigneur, implore Son pardon. Car Il est Grand Accueillant au repentir',
      ),
    ],
  );

  static const SuraData asr = SuraData(
    id: 'asr',
    nameAr: 'العصر',
    nameFr: 'Le Temps',
    number: '103',
    gradeRequired: 3,
    verses: [
      SuraLine(
        arabic: 'وَالْعَصْرِ',
        phonetic: 'Wa-l-ʿaṣr',
        french: 'Par le Temps !',
      ),
      SuraLine(
        arabic: 'إِنَّ الْإِنسَانَ لَفِي خُسْرٍ',
        phonetic: 'Inna l-insāna la-fī ḫusr',
        french: 'L\'homme est certes en perdition',
      ),
      SuraLine(
        arabic: 'إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
        phonetic: 'Illā llaḏīna āmanū wa-ʿamilū ṣ-ṣāliḥāti wa-tawāṣaw bi-l-ḥaqqi wa-tawāṣaw bi-ṣ-ṣabr',
        french: 'Sauf ceux qui croient et accomplissent les bonnes œuvres, s\'enjoignent mutuellement la vérité et s\'enjoignent mutuellement la patience',
      ),
    ],
  );

  static List<SuraData> get all => [fatiha, ikhlas, kawthar, nas, falaq, nasr, asr];

  static SuraData? getById(String id) =>
      all.cast<SuraData?>().firstWhere((s) => s?.id == id, orElse: () => null);
}

