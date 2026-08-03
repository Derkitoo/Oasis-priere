class PostureData {
  final String id;
  final String nameAr;
  final String nameFr;
  final String namePhonetic;
  final String description;
  final String spiritualMeaning;
  final String bodyInstruction;
  final String audioId;
  final String imageAsset;
  final int orderIndex;

  const PostureData({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.namePhonetic,
    required this.description,
    required this.spiritualMeaning,
    required this.bodyInstruction,
    required this.audioId,
    required this.imageAsset,
    required this.orderIndex,
  });
}

class PrayerFormula {
  final String id;
  final String postureId;
  final String arabic;
  final String phonetic;
  final String french;
  final String audioId;
  final bool isRepeated;
  final int repeatCount;

  const PrayerFormula({
    required this.id,
    required this.postureId,
    required this.arabic,
    required this.phonetic,
    required this.french,
    required this.audioId,
    this.isRepeated = false,
    this.repeatCount = 1,
  });
}

class PosturesData {
  static const List<PostureData> all = [
    PostureData(
      id: 'takbir',
      nameAr: 'التكبير',
      nameFr: 'Le Takbir (Ouverture)',
      namePhonetic: 'At-Takbīr',
      description: 'On se tient debout, les mains levées à la hauteur des épaules, paumes tournées vers l\'avant.',
      spiritualMeaning: 'En levant les mains, tu quittes le monde et tu entres dans la conversation avec Allah.',
      bodyInstruction: 'Debout, jambes légèrement écartées, lève les mains jusqu\'aux oreilles, pouces près des lobes.',
      audioId: 'takbir',
      imageAsset: 'images/postures/takbir.png',
      orderIndex: 0,
    ),
    PostureData(
      id: 'qiyam',
      nameAr: 'القيام',
      nameFr: 'Le Qiyam (Debout)',
      namePhonetic: 'Al-Qiyām',
      description: 'On reste debout, la main droite posée sur la main gauche, sur la poitrine ou l\'abdomen.',
      spiritualMeaning: 'Tu te tiens debout devant le Roi des rois. C\'est la posture de l\'honneur et de l\'humilité.',
      bodyInstruction: 'Debout, regard vers le lieu de prosternation. Main droite sur la gauche, posées sur la poitrine.',
      audioId: 'qiyam',
      imageAsset: 'images/postures/qiyam.png',
      orderIndex: 1,
    ),
    PostureData(
      id: 'ruku',
      nameAr: 'الركوع',
      nameFr: 'Le Ruku (Inclinaison)',
      namePhonetic: 'Ar-Rukūʿ',
      description: 'On s\'incline en avant jusqu\'à ce que le dos soit parallèle au sol, mains sur les genoux.',
      spiritualMeaning: 'Tu t\'inclines devant la grandeur d\'Allah. Ton dos plat montre ton respect total.',
      bodyInstruction: 'Incline le tronc à 90°, dos droit, mains sur les genoux, doigts écartés, regard vers le bas.',
      audioId: 'ruku',
      imageAsset: 'images/postures/ruku.png',
      orderIndex: 2,
    ),
    PostureData(
      id: 'i_tidal',
      nameAr: 'الاعتدال',
      nameFr: 'L\'I\'tidal (Redressement)',
      namePhonetic: 'Al-Iʿtidāl',
      description: 'On se redresse complètement après le Ruku, bras le long du corps.',
      spiritualMeaning: 'Tu te relèves pour remercier Allah qui t\'a accordé sa miséricorde.',
      bodyInstruction: 'Redresse-toi complètement, bras le long du corps, dos droit, regard vers le bas.',
      audioId: 'i_tidal',
      imageAsset: 'images/postures/i_tidal.png',
      orderIndex: 3,
    ),
    PostureData(
      id: 'sujud',
      nameAr: 'السجود',
      nameFr: 'Le Sujud (Prosternation)',
      namePhonetic: 'As-Sujūd',
      description: 'On se prosterne en posant le front, le nez, les deux mains, les deux genoux et les orteils au sol.',
      spiritualMeaning: 'La posture la plus proche d\'Allah. Ton front touche la terre — le sommet de l\'humilité.',
      bodyInstruction: '7 points de contact : front, nez, 2 mains, 2 genoux, 2 orteils. Coudes décollés du sol.',
      audioId: 'sujud',
      imageAsset: 'images/postures/sujud.png',
      orderIndex: 4,
    ),
    PostureData(
      id: 'joulous',
      nameAr: 'الجلوس',
      nameFr: 'Le Joulous (Assis)',
      namePhonetic: 'Al-Julūs',
      description: 'On s\'assoit sur le pied gauche replié, le droit dressé, les mains sur les genoux.',
      spiritualMeaning: 'Tu te reposes entre deux prosternations, dans la paix de la présence divine.',
      bodyInstruction: 'Assis sur le pied gauche, droit dressé vers l\'avant. Mains à plat sur les cuisses.',
      audioId: 'joulous',
      imageAsset: 'images/postures/joulous.png',
      orderIndex: 5,
    ),
    PostureData(
      id: 'tashahhud',
      nameAr: 'التشهد',
      nameFr: 'Le Tashahhud (Témoignage)',
      namePhonetic: 'At-Tašahhud',
      description: 'Position assise finale avec l\'index droit levé lors de la profession de foi.',
      spiritualMeaning: 'Tu témoignes qu\'Allah est Unique et que Muhammad ﷺ est Son messager. Un moment solennel et doux.',
      bodyInstruction: 'Assis comme Joulous. Lève l\'index droit lors de "illallah". Regard vers l\'index.',
      audioId: 'tashahhud',
      imageAsset: 'images/postures/tashahhud.png',
      orderIndex: 6,
    ),
    PostureData(
      id: 'salam',
      nameAr: 'السلام',
      nameFr: 'Le Salam (Clôture)',
      namePhonetic: 'As-Salām',
      description: 'On tourne la tête à droite puis à gauche en prononçant le salut.',
      spiritualMeaning: 'Tu salues les anges et les croyants de chaque côté. La prière se termine dans la paix.',
      bodyInstruction: 'Assis en Tashahhud. Tourne la tête à droite : "Assalāmu ʿalaykum wa-raḥmatullāh". Puis à gauche.',
      audioId: 'salam',
      imageAsset: 'images/postures/salam.png',
      orderIndex: 7,
    ),
  ];

  static const List<PrayerFormula> formulas = [
    PrayerFormula(
      id: 'takbir_opening',
      postureId: 'takbir',
      arabic: 'اللَّهُ أَكْبَرُ',
      phonetic: 'Allāhu Akbar',
      french: 'Allah est le Plus Grand',
      audioId: 'formula_takbir',
    ),
    PrayerFormula(
      id: 'dua_opening',
      postureId: 'qiyam',
      arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَهَ غَيْرُكَ',
      phonetic: 'Subḥānaka Allāhumma wa-biḥamdika wa-tabāraka smuka wa-taʿālā jadduka wa-lā ilāha ġayruk',
      french: 'Gloire à Toi, ô Allah, et Ta louange. Que Ton nom soit béni et que Ta majesté soit exaltée. Il n\'y a pas de divinité en dehors de Toi.',
      audioId: 'formula_dua_opening',
    ),
    PrayerFormula(
      id: 'ruku_dhikr',
      postureId: 'ruku',
      arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      phonetic: 'Subḥāna rabbiya l-ʿaẓīm',
      french: 'Gloire à mon Seigneur le Très Grand',
      audioId: 'formula_ruku',
      isRepeated: true,
      repeatCount: 3,
    ),
    PrayerFormula(
      id: 'i_tidal_dhikr',
      postureId: 'i_tidal',
      arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ رَبَّنَا وَلَكَ الْحَمْدُ',
      phonetic: 'Samiʿa llāhu liman ḥamidahu — Rabbanā wa-laka l-ḥamd',
      french: 'Allah entend celui qui Le loue — Notre Seigneur, toute louange T\'appartient',
      audioId: 'formula_i_tidal',
    ),
    PrayerFormula(
      id: 'sujud_dhikr',
      postureId: 'sujud',
      arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      phonetic: 'Subḥāna rabbiya l-aʿlā',
      french: 'Gloire à mon Seigneur le Très Haut',
      audioId: 'formula_sujud',
      isRepeated: true,
      repeatCount: 3,
    ),
    PrayerFormula(
      id: 'tashahhud_text',
      postureId: 'tashahhud',
      arabic: 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      phonetic: 'At-taḥiyyātu lillāhi wa-ṣ-ṣalawātu wa-ṭ-ṭayyibāt. As-salāmu ʿalayka ayyuhā n-nabiyyu wa-raḥmatu llāhi wa-barakātuh. As-salāmu ʿalaynā wa-ʿalā ʿibādi llāhi ṣ-ṣāliḥīn. Ašhadu an lā ilāha illā llāhu wa-ašhadu anna Muḥammadan ʿabduhu wa-rasūluh.',
      french: 'Les salutations appartiennent à Allah, ainsi que les prières et les bonnes œuvres. Que la paix soit sur toi, ô Prophète, ainsi que la miséricorde d\'Allah et Ses bénédictions. Que la paix soit sur nous et sur les serviteurs pieux d\'Allah. Je témoigne qu\'il n\'y a pas de divinité sauf Allah et je témoigne que Muhammad est Son serviteur et Son messager.',
      audioId: 'formula_tashahhud',
    ),
    PrayerFormula(
      id: 'salawat',
      postureId: 'tashahhud',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      phonetic: 'Allāhumma ṣalli ʿalā Muḥammadin wa-ʿalā āli Muḥammadin kamā ṣallayta ʿalā Ibrāhīma wa-ʿalā āli Ibrāhīm. Innaka ḥamīdun majīd.',
      french: 'Ô Allah, bénis Muhammad et la famille de Muhammad comme Tu as béni Ibrahim et la famille d\'Ibrahim. Tu es certes le Digne de louanges, le Glorieux.',
      audioId: 'formula_salawat',
    ),
    PrayerFormula(
      id: 'salam_right',
      postureId: 'salam',
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      phonetic: 'As-salāmu ʿalaykum wa-raḥmatu llāh',
      french: 'Que la paix et la miséricorde d\'Allah soient sur vous',
      audioId: 'formula_salam',
    ),
  ];

  static PostureData? getById(String id) =>
      all.cast<PostureData?>().firstWhere((p) => p?.id == id, orElse: () => null);

  static PrayerFormula? getFormula(String postureId) =>
      formulas.cast<PrayerFormula?>().firstWhere((f) => f?.postureId == postureId, orElse: () => null);
}
