export interface PrayerStep {
  id: string;
  label: string;
  arabic: string;
  transliteration: string;
  description: string;
  posture: string;
  image: string;
  isRakatStart?: boolean;
}

export interface Prayer {
  id: string;
  name: string;
  arabicName: string;
  rakats: number;
  steps: PrayerStep[];
}

const buildRakatSteps = (
  r: number,
  opts: {
    isFirst: boolean;
    withSourate: boolean;
    hasInterTashahhud: boolean;
    isLast: boolean;
  }
): PrayerStep[] => {
  const steps: PrayerStep[] = [];

  // --- Début du raka'at ---
  if (opts.isFirst) {
    steps.push({
      id: `r${r}_takbir_ihram`,
      label: 'Takbîrat al-Ihrâm',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allâhou Akbar',
      description:
        "Debout face à la Qibla. Lève les mains jusqu'aux épaules (ou aux oreilles), doigts joints. Prononce « Allâhou Akbar » puis pose ta main droite sur ta main gauche, au-dessus de la poitrine. Regarde l'endroit de prosternation.",
      posture: 'takbir',
      image: 'takbir_3.png',
      isRakatStart: true,
    });
  } else {
    steps.push({
      id: `r${r}_rise`,
      label: `${r}ème Raka'at — Debout`,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allâhou Akbar',
      description: `Lève-toi pour la ${r}ème raka'at en disant « Allâhou Akbar ». Place tes mains sur ta poitrine, main droite sur main gauche.`,
      posture: 'takbir',
      image: 'takbir_3.png',
      isRakatStart: true,
    });
  }

  // --- Qiyam : Al-Fatiha (+ sourate) ---
  steps.push({
    id: `r${r}_qiyam`,
    label: opts.withSourate ? 'Al-Fâtiha + Sourate' : 'Al-Fâtiha',
    arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
    transliteration: 'Bismi-llâhi-r-rahmâni-r-rahîm...',
    description: opts.withSourate
      ? "Debout, mains sur la poitrine. Récite Al-Fâtiha (7 versets) puis une courte sourate (ex. Al-Ikhlâs, Al-Kawthar, Al-'Asr)."
      : 'Debout, mains sur la poitrine. Récite Al-Fâtiha (7 versets) uniquement.',
    posture: 'qiyam',
    image: 'takbir_4.png',
  });

  // --- Ruku' ---
  steps.push({
    id: `r${r}_ruku`,
    label: "Ruku'",
    arabic: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
    transliteration: "Soubhêna Rabbyal 'aDhîme (× 3)",
    description:
      "Dis « Allâhou Akbar » en t'inclinant. Pose les mains sur les genoux, dos bien droit, tête dans l'axe du dos. Répète 3 fois la formule.",
    posture: 'ruku',
    image: 'ruku_0.png',
  });

  // --- I'tidal ---
  steps.push({
    id: `r${r}_itidal`,
    label: "I'tidâl — Redressement",
    arabic: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ\nرَبَّنَا وَلَكَ الْحَمْدُ',
    transliteration: "Sami'aLlâhou liman Hamidah\nRabbanê wa lakal Hamd",
    description:
      'Redresse-toi en disant « Sami\'aLlâhou liman Hamidah ». Une fois bien debout, dis « Rabbanê wa lakal Hamd ».',
    posture: 'itidal',
    image: 'ruku_2.png',
  });

  // --- 1er Sujoud ---
  steps.push({
    id: `r${r}_sujud1`,
    label: '1er Soujoud',
    arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
    transliteration: "SoubHêna Rabbyal a'laa (× 3)",
    description:
      "Dis « Allâhou Akbar » en te prosternant. Pose 7 parties du corps : front + nez, les 2 paumes (alignées vers la Qibla), les 2 genoux, les orteils des 2 pieds. Répète 3 fois la formule.",
    posture: 'sujud',
    image: 'sujud_0.png',
  });

  // --- Joulous (assis entre les deux prosternations) ---
  steps.push({
    id: `r${r}_julus`,
    label: 'Joulous — Position assise',
    arabic: 'رَبِّ اغْفِرْ لِي',
    transliteration: 'Rabbighfir lî (× 3)',
    description:
      'Dis « Allâhou Akbar » et assieds-toi. Pied gauche à plat, pied droit dressé (orteils vers la Qibla). Pose les mains sur les genoux. Répète 3 fois la formule.',
    posture: 'julus',
    image: 'sujud_2.png',
  });

  // --- 2ème Sujoud ---
  steps.push({
    id: `r${r}_sujud2`,
    label: '2ème Soujoud',
    arabic: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
    transliteration: "SoubHêna Rabbyal a'laa (× 3)",
    description:
      'Dis « Allâhou Akbar » et prosterne-toi à nouveau, exactement comme le premier. Répète 3 fois la formule.',
    posture: 'sujud',
    image: 'sujud_0.png',
  });

  // --- Tachahhoud intermédiaire (après le 2ème raka'at si la prière en comporte plus) ---
  if (opts.hasInterTashahhud) {
    steps.push({
      id: `r${r}_tashahhud_int`,
      label: 'Tachahhoud intermédiaire',
      arabic:
        'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ\nالسَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ\nالسَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ\nأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      transliteration:
        "Attahyyêtou lillahi wassalawatou wattayyibatou\nAssalêmou 'alayka ayyouha-n-nabiyyou wa rahmatoullahi wa barakatouh\nAssalêmou 'alayna wa 'ala 'ibadillahi-s-sâlihine\nAchhado an lâ ilêha illAllâh wa achhado anna Mouhammadan 'abdouhou wa rasoûlouhou",
      description:
        'Dis « Allâhou Akbar » et assieds-toi (comme entre les deux prosternations). Main droite : pouce sur le majeur formant un anneau, index levé vers la Qibla. Récite le Tachahhoud.',
      posture: 'tashahhud',
      image: 'tashahhud_3.png',
    });
  }

  // --- Dernier raka'at : Tashahhoud final + Taslim ---
  if (opts.isLast) {
    steps.push({
      id: `r${r}_tashahhud_final`,
      label: 'Dernier Tachahhoud',
      arabic:
        'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ\nالسَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ\nالسَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ\nأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ\nاللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
      transliteration:
        "Attahyyêtou lillahi... (Tachahhoud)\nAllâhoumma Salli 'ala Mouhammad wa 'ala âli Mouhammad\nKamâ Sallayta 'ala Ibrahîm wa 'ala âli Ibrahîm innaka Hamîdoun Majîd",
      description:
        'Assieds-toi en Tawarruk : jambe gauche sortie par le côté droit, assis sur le sol (pas sur le pied). Récite le Tachahhoud puis la Salât Ibrahimiyya.',
      posture: 'tashahhud_final',
      image: 'sujud_2.png',
    });

    steps.push({
      id: `r${r}_taslim_right`,
      label: 'Salâm à droite',
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      transliteration: "Assalêmou 'alaykum warahmatuLlah",
      description: 'Tourne la tête vers la droite en prononçant la formule. Les anges enregistreurs reçoivent ton salut.',
      posture: 'taslim_right',
      image: 'taslim_1.png',
    });

    steps.push({
      id: `r${r}_taslim_left`,
      label: 'Salâm à gauche',
      arabic: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      transliteration: "Assalêmou 'alaykum warahmatuLlah",
      description: 'Tourne la tête vers la gauche en prononçant la formule. Ta prière est terminée. Masha\'Allah !',
      posture: 'taslim_left',
      image: 'taslim_2.png',
    });
  }

  return steps;
};

const buildPrayer = (
  id: string,
  name: string,
  arabicName: string,
  totalRakats: number
): Prayer => {
  const steps: PrayerStep[] = [];
  for (let r = 1; r <= totalRakats; r++) {
    steps.push(
      ...buildRakatSteps(r, {
        isFirst: r === 1,
        withSourate: r <= 2,
        hasInterTashahhud: r === 2 && totalRakats >= 3,
        isLast: r === totalRakats,
      })
    );
  }
  return { id, name, arabicName, rakats: totalRakats, steps };
};

export const PRAYERS: Prayer[] = [
  buildPrayer('fajr', 'Fajr', 'الفجر', 2),
  buildPrayer('dhuhr', 'Dhuhr', 'الظهر', 4),
  buildPrayer('asr', 'Asr', 'العصر', 4),
  buildPrayer('maghrib', 'Maghrib', 'المغرب', 3),
  buildPrayer('isha', 'Isha', 'العشاء', 4),
];

export const getCurrentPrayer = (): Prayer => {
  const h = new Date().getHours();
  if (h >= 5 && h < 12) return PRAYERS[0];
  if (h >= 12 && h < 15) return PRAYERS[1];
  if (h >= 15 && h < 18) return PRAYERS[2];
  if (h >= 18 && h < 20) return PRAYERS[3];
  return PRAYERS[4];
};
