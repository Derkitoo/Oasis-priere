import '../models/progress_model.dart';
import '../constants/app_constants.dart';

class XpResult {
  final int xpGained;
  final int totalXp;
  final int oldGrade;
  final int newGrade;
  final bool leveledUp;
  final List<String> newAchievements;

  const XpResult({
    required this.xpGained,
    required this.totalXp,
    required this.oldGrade,
    required this.newGrade,
    this.leveledUp = false,
    this.newAchievements = const [],
  });
}

class XpService {
  XpResult addXp(ProgressModel progress, int xpToAdd, {int streakBonus = 0}) {
    final totalGained = xpToAdd + streakBonus;
    final newTotal = progress.totalXp + totalGained;
    final oldGrade = progress.currentGrade;
    final newGrade = _computeGrade(newTotal);

    final achievements = <String>[];
    if (newTotal >= 100 && progress.totalXp < 100) achievements.add('first_100xp');
    if (newTotal >= 1000 && progress.totalXp < 1000) achievements.add('xp_1000');

    return XpResult(
      xpGained: totalGained,
      totalXp: newTotal,
      oldGrade: oldGrade,
      newGrade: newGrade,
      leveledUp: newGrade > oldGrade,
      newAchievements: achievements,
    );
  }

  int _computeGrade(int totalXp) {
    if (totalXp >= AppConstants.gradeXpThreshold[4]!) return 4;
    if (totalXp >= AppConstants.gradeXpThreshold[3]!) return 3;
    if (totalXp >= AppConstants.gradeXpThreshold[2]!) return 2;
    return 1;
  }

  int xpForPrayer(String mode, {bool tasbihDone = false}) {
    int base = switch (mode) {
      'guided' => AppConstants.xpGuidedPrayer,
      'autonomous' => AppConstants.xpAutonomousPrayer,
      _ => AppConstants.xpGuidedPrayer,
    };
    if (tasbihDone) base += AppConstants.xpTasbih;
    return base;
  }

  // Renvoie l'XP restant avant le prochain grade
  int xpToNextGrade(int totalXp, int currentGrade) {
    if (currentGrade >= 4) return 0;
    final next = AppConstants.gradeXpThreshold[currentGrade + 1] ?? 0;
    return (next - totalXp).clamp(0, next);
  }
}
