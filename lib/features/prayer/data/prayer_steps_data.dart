class PrayerStep {
  final String id;
  final String postureId;
  final String formulaId;
  final String instruction;
  final String? dhikr;        // formule courte à afficher
  final int durationSeconds;
  final bool isPause;
  final bool isRakatStart;    // premier pas d'un nouveau raka'at

  const PrayerStep({
    required this.id,
    required this.postureId,
    required this.formulaId,
    required this.instruction,
    this.dhikr,
    this.durationSeconds = 8,
    this.isPause = false,
    this.isRakatStart = false,
  });
}

class PrayerStepsData {
  // ─── Étapes d'UN raka'at (6 étapes claires) ───────────────────
  static const List<PrayerStep> _rakatCore = [
    PrayerStep(
      id: 'qiyam',
      postureId: 'qiyam',
      formulaId: 'dua_opening',
      instruction: 'Lis Al-Fatiha puis une courte sourate',
      dhikr: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      durationSeconds: 20,
    ),
    PrayerStep(
      id: 'ruku',
      postureId: 'ruku',
      formulaId: 'ruku_dhikr',
      instruction: 'Allahu Akbar → Incline-toi\nDis "Subhana Rabbiya Al-Azim" 3 fois',
      dhikr: 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      durationSeconds: 10,
    ),
    PrayerStep(
      id: 'i_tidal',
      postureId: 'i_tidal',
      formulaId: 'i_tidal_dhikr',
      instruction: 'Relève-toi complètement\n"Sami\'a Allahu liman hamidah"',
      dhikr: 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ',
      durationSeconds: 5,
    ),
    PrayerStep(
      id: 'sujud1',
      postureId: 'sujud',
      formulaId: 'sujud_dhikr',
      instruction: 'Allahu Akbar → Prosterne-toi\nDis "Subhana Rabbiya Al-A\'la" 3 fois',
      dhikr: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      durationSeconds: 10,
    ),
    PrayerStep(
      id: 'joulous',
      postureId: 'joulous',
      formulaId: '',
      instruction: 'Allahu Akbar → Assieds-toi un instant entre les deux prosternations',
      durationSeconds: 4,
      isPause: true,
    ),
    PrayerStep(
      id: 'sujud2',
      postureId: 'sujud',
      formulaId: 'sujud_dhikr',
      instruction: 'Allahu Akbar → Prosterne-toi à nouveau\n"Subhana Rabbiya Al-A\'la" 3 fois',
      dhikr: 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      durationSeconds: 10,
    ),
  ];

  // ─── Takbir d'ouverture (Raka'at 1 uniquement) ────────────────
  static const PrayerStep _openingTakbir = PrayerStep(
    id: 'takbir',
    postureId: 'takbir',
    formulaId: 'takbir_opening',
    instruction: 'Lève les mains, dis\n"Allahu Akbar" pour ouvrir la prière',
    dhikr: 'اللَّهُ أَكْبَرُ',
    durationSeconds: 5,
    isRakatStart: true,
  );

  // ─── Tashahhud court (après Raka'at 2 dans les prières ≥ 3 raka'at) ───
  static const PrayerStep _midTashahhud = PrayerStep(
    id: 'tashahhud_short',
    postureId: 'tashahhud',
    formulaId: 'tashahhud_text',
    instruction: 'Assieds-toi, lis la première partie du Tashahhud\net lève l\'index',
    dhikr: 'التَّحِيَّاتُ لِلَّهِ...',
    durationSeconds: 18,
  );

  // ─── Fin de prière (dernier raka'at) ──────────────────────────
  static const List<PrayerStep> _finalSteps = [
    PrayerStep(
      id: 'tashahhud',
      postureId: 'tashahhud',
      formulaId: 'tashahhud_text',
      instruction: 'Lis le Tashahhud complet\nLève l\'index quand tu dis "illallah"',
      dhikr: 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ...',
      durationSeconds: 25,
    ),
    PrayerStep(
      id: 'salawat',
      postureId: 'tashahhud',
      formulaId: 'salawat',
      instruction: 'Lis le Salawat sur le Prophète ﷺ',
      dhikr: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ...',
      durationSeconds: 15,
    ),
    PrayerStep(
      id: 'salam',
      postureId: 'salam',
      formulaId: 'salam_right',
      instruction: 'Tourne la tête à droite :\n"Assalamu alaykum wa rahmatullah"\nPuis à gauche : idem',
      dhikr: 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
      durationSeconds: 6,
    ),
  ];

  // ─── Construction de la prière complète ───────────────────────
  static List<PrayerStep> buildPrayer(int totalRakat) {
    final steps = <PrayerStep>[];

    // Takbir d'ouverture
    steps.add(_openingTakbir);

    for (int r = 0; r < totalRakat; r++) {
      final isFinal = r == totalRakat - 1;
      final isMid = totalRakat > 2 && r == 1;

      // 6 étapes du raka'at (marquer le début si pas le 1er)
      for (int i = 0; i < _rakatCore.length; i++) {
        final step = _rakatCore[i];
        // Marquer le début de chaque raka'at (sauf le 1er qui a son takbir)
        if (r > 0 && i == 0) {
          steps.add(PrayerStep(
            id: '${step.id}_r$r',
            postureId: step.postureId,
            formulaId: step.formulaId,
            instruction: step.instruction,
            dhikr: step.dhikr,
            durationSeconds: step.durationSeconds,
            isPause: step.isPause,
            isRakatStart: true,
          ));
        } else {
          steps.add(step);
        }
      }

      if (isMid) steps.add(_midTashahhud);
      if (isFinal) steps.addAll(_finalSteps);
    }

    return steps;
  }

  // Calcule dans quel raka'at on est (pour l'affichage)
  static int rakatOf(int stepIndex, List<PrayerStep> steps) {
    int rakat = 0;
    for (int i = 0; i <= stepIndex && i < steps.length; i++) {
      if (steps[i].isRakatStart && i > 0) rakat++;
    }
    return rakat;
  }
}
