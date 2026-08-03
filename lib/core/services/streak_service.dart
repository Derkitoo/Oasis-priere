import '../models/progress_model.dart';
import '../constants/app_constants.dart';

class StreakResult {
  final int newStreak;
  final int bonusXp;
  final bool isNewRecord;
  final int? milestoneReached; // 3, 7, 14, 30

  const StreakResult({
    required this.newStreak,
    this.bonusXp = 0,
    this.isNewRecord = false,
    this.milestoneReached,
  });
}

class StreakService {
  StreakResult updateStreak(ProgressModel progress) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (progress.lastPrayerDate == null) {
      return StreakResult(newStreak: 1, isNewRecord: 1 > progress.longestStreak);
    }

    final lastDate = DateTime(
      progress.lastPrayerDate!.year,
      progress.lastPrayerDate!.month,
      progress.lastPrayerDate!.day,
    );
    final diff = today.difference(lastDate).inDays;

    if (diff == 0) {
      // Même jour — streak inchangé
      return StreakResult(newStreak: progress.currentStreak);
    }

    if (diff == 1) {
      // Jour consécutif — streak +1
      final newStreak = progress.currentStreak + 1;
      final bonus = _checkMilestoneBonus(progress.currentStreak, newStreak);
      final milestone = _getMilestone(progress.currentStreak, newStreak);
      return StreakResult(
        newStreak: newStreak,
        bonusXp: bonus,
        isNewRecord: newStreak > progress.longestStreak,
        milestoneReached: milestone,
      );
    }

    // Plus d'un jour manqué — remise à zéro
    return StreakResult(newStreak: 1);
  }

  int _checkMilestoneBonus(int oldStreak, int newStreak) {
    int bonus = 0;
    for (final entry in AppConstants.streakBonusXp.entries) {
      if (oldStreak < entry.key && newStreak >= entry.key) {
        bonus += entry.value;
      }
    }
    return bonus;
  }

  int? _getMilestone(int oldStreak, int newStreak) {
    for (final milestone in [3, 7, 14, 30]) {
      if (oldStreak < milestone && newStreak >= milestone) return milestone;
    }
    return null;
  }

  // Intensité du feu de camp (0.0 – 1.0)
  double campfireIntensity(int streak) {
    if (streak == 0) return 0.05; // braise
    if (streak < 3) return 0.2;
    if (streak < 7) return 0.45;
    if (streak < 14) return 0.65;
    if (streak < 30) return 0.85;
    return 1.0; // feu magique doré
  }

  bool isGoldenFire(int streak) => streak >= 30;
  bool isBigFire(int streak) => streak >= 7;
}
