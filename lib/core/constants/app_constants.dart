class AppConstants {
  // Grades RPG
  static const Map<int, String> gradeNames = {
    1: 'Le Gardien des Postures',
    2: 'Le Récitateur',
    3: 'Le Guide (Imam)',
    4: "L'Explorateur du Sens",
  };

  static const Map<int, String> gradeIcons = {
    1: '🛡️',
    2: '📖',
    3: '⭐',
    4: '🌌',
  };

  static const Map<int, int> gradeXpThreshold = {
    1: 0,
    2: 500,
    3: 1500,
    4: 3500,
  };

  // XP par action
  static const int xpGuidedPrayer = 50;
  static const int xpAutonomousPrayer = 80;
  static const int xpPostureModule = 30;
  static const int xpVoiceSuccess = 40;
  static const int xpTasbih = 15;
  static const int xpWelcomeBonus = 100;

  // Streak bonuses
  static const Map<int, int> streakBonusXp = {
    3: 50,
    7: 200,
    14: 500,
    30: 1000,
  };

  // Noms des prières
  static const List<String> prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghreb', 'Isha'];
  static const List<String> prayerNamesAr = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];

  // Nombre de Raka'at par prière
  static const Map<String, int> prayerRakatCount = {
    'Fajr': 2,
    'Dhuhr': 4,
    'Asr': 4,
    'Maghreb': 3,
    'Isha': 4,
  };

  // Mode sombre automatique : Maghreb et Isha
  static const Set<String> nightPrayers = {'Maghreb', 'Isha'};

  // Méthodes de calcul des horaires
  static const Map<String, String> calculationMethods = {
    'UOIF': 'UOIF (France recommandé)',
    'MWL': 'Muslim World League',
    'ISNA': 'ISNA (Amérique du Nord)',
    'Egypt': 'Autorité islamique d\'Égypte',
    'Karachi': 'Université de Karachi',
    'Makkah': 'Oumm Al-Qoura (Mecque)',
  };

  // Paramètres de calcul (angle Fajr / Isha)
  static const Map<String, List<double>> methodAngles = {
    'UOIF': [12.0, 12.0],
    'MWL': [18.0, 17.0],
    'ISNA': [15.0, 15.0],
    'Egypt': [19.5, 17.5],
    'Karachi': [18.0, 18.0],
    'Makkah': [18.5, 0.0], // Isha = 90 min après Maghreb
  };

  // Routes
  static const String routeWelcome = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeDashboard = '/dashboard';
  static const String routePreparation = '/prayer/preparation';
  static const String routeGuidedPrayer = '/prayer/guided';
  static const String routeTasbih = '/prayer/tasbih';
  static const String routeCelebration = '/prayer/celebration';
  static const String routeLearningHub = '/learning';
  static const String routePostureStudio = '/learning/postures';
  static const String routeKaraoke = '/learning/karaoke';
  static const String routeFusionMode = '/learning/fusion';
  static const String routeProfile = '/profile';
}
