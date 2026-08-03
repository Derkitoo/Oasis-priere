import 'package:flutter/foundation.dart';
import '../models/progress_model.dart';
import '../models/prayer_log_model.dart';
import '../models/avatar_model.dart';
import '../services/database_service.dart';
import '../services/streak_service.dart';
import '../services/xp_service.dart';

class PrayerCompletionResult {
  final int xpGained;
  final int newStreak;
  final bool leveledUp;
  final int newGrade;
  final bool newRecord;
  final int? streakMilestone;
  final List<String> newAchievements;

  const PrayerCompletionResult({
    required this.xpGained,
    required this.newStreak,
    required this.leveledUp,
    required this.newGrade,
    this.newRecord = false,
    this.streakMilestone,
    this.newAchievements = const [],
  });
}

class ProgressProvider extends ChangeNotifier {
  final DatabaseService _db;
  final StreakService _streakService;
  final XpService _xpService;

  ProgressModel? _progress;
  List<PrayerLogModel> _todayLogs = [];

  ProgressProvider(this._db)
      : _streakService = StreakService(),
        _xpService = XpService();

  ProgressModel? get progress => _progress;
  List<PrayerLogModel> get todayLogs => _todayLogs;

  Future<void> loadProgress(String userId) async {
    _progress = await _db.getProgress(userId);
    _todayLogs = await _db.getTodayLogs(userId);
    notifyListeners();
  }

  Future<PrayerCompletionResult> completePrayer({
    required String userId,
    required String prayerName,
    required String mode,
    required int rakatCount,
    required int durationSeconds,
    bool qiblaAligned = false,
    bool tasbihDone = false,
    double? voiceScore,
  }) async {
    if (_progress == null) return const PrayerCompletionResult(xpGained: 0, newStreak: 0, leveledUp: false, newGrade: 1);

    // 1. Calcul XP de base
    final baseXp = _xpService.xpForPrayer(mode, tasbihDone: tasbihDone);

    // 2. Mise à jour streak
    final streakResult = _streakService.updateStreak(_progress!);

    // 3. XP total (base + bonus streak)
    final xpResult = _xpService.addXp(_progress!, baseXp, streakBonus: streakResult.bonusXp);

    // 4. Mise à jour du Progress
    final updatedProgress = _progress!.copyWith(
      totalXp: xpResult.totalXp,
      currentGrade: xpResult.newGrade,
      currentStreak: streakResult.newStreak,
      longestStreak: streakResult.isNewRecord ? streakResult.newStreak : _progress!.longestStreak,
      lastPrayerDate: DateTime.now(),
      achievements: [
        ..._progress!.achievements,
        ...xpResult.newAchievements.map((id) => AchievementEntry(id: id, unlockedAt: DateTime.now())),
      ],
    );

    await _db.updateProgress(updatedProgress);
    _progress = updatedProgress;

    // 5. Enregistrement du log
    final log = PrayerLogModel.create(
      userId: userId,
      prayerName: prayerName,
      mode: mode,
      rakatCount: rakatCount,
      xpEarned: xpResult.xpGained,
      durationSeconds: durationSeconds,
      qiblaAligned: qiblaAligned,
      tasbihDone: tasbihDone,
      voiceScore: voiceScore,
    );
    await _db.savePrayerLog(log);
    _todayLogs = await _db.getTodayLogs(userId);

    notifyListeners();

    return PrayerCompletionResult(
      xpGained: xpResult.xpGained,
      newStreak: streakResult.newStreak,
      leveledUp: xpResult.leveledUp,
      newGrade: xpResult.newGrade,
      newRecord: streakResult.isNewRecord,
      streakMilestone: streakResult.milestoneReached,
      newAchievements: xpResult.newAchievements,
    );
  }

  Future<void> completeModule(String userId, String moduleId) async {
    if (_progress == null) return;
    if (_progress!.modulesCompleted.contains(moduleId)) return;

    final updated = _progress!.copyWith(
      modulesCompleted: [..._progress!.modulesCompleted, moduleId],
      totalXp: _progress!.totalXp + 30,
    );
    await _db.updateProgress(updated);
    _progress = updated;
    notifyListeners();
  }

  Future<void> masterPosture(String userId, String postureId) async {
    if (_progress == null) return;
    if (_progress!.posturesMastered.contains(postureId)) return;

    final updated = _progress!.copyWith(
      posturesMastered: [..._progress!.posturesMastered, postureId],
    );
    await _db.updateProgress(updated);
    _progress = updated;
    notifyListeners();
  }

  Future<void> memorizeSura(String userId, String suraId) async {
    if (_progress == null) return;
    if (_progress!.surasMemorized.contains(suraId)) return;

    final updated = _progress!.copyWith(
      surasMemorized: [..._progress!.surasMemorized, suraId],
      totalXp: _progress!.totalXp + 80,
    );
    await _db.updateProgress(updated);
    _progress = updated;
    notifyListeners();
  }

  Set<String> get todayPrayersDone => _todayLogs.map((l) => l.prayerName).toSet();

  bool isPrayerDoneToday(String name) => todayPrayersDone.contains(name);
}
