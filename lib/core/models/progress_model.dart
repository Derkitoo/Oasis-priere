class ProgressModel {
  final String id;
  final String userId;
  final int currentGrade; // 1–4
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastPrayerDate;
  final List<String> modulesCompleted;
  final List<String> posturesMastered;
  final List<String> surasMemorized;
  final List<AchievementEntry> achievements;
  final Map<String, dynamic> voiceAttempts; // suraId -> {attempts, successes}

  const ProgressModel({
    required this.id,
    required this.userId,
    this.currentGrade = 1,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPrayerDate,
    this.modulesCompleted = const [],
    this.posturesMastered = const [],
    this.surasMemorized = const [],
    this.achievements = const [],
    this.voiceAttempts = const {},
  });

  int get gradeXpProgress {
    const thresholds = [0, 500, 1500, 3500, 9999999];
    final current = thresholds[currentGrade - 1];
    final next = thresholds[currentGrade];
    return totalXp - current < 0 ? 0 : totalXp - current > (next - current) ? (next - current) : totalXp - current;
  }

  int get gradeXpRequired {
    const thresholds = [0, 500, 1500, 3500, 9999999];
    return thresholds[currentGrade] - thresholds[currentGrade - 1];
  }

  double get gradeProgressPercent =>
      gradeXpRequired == 0 ? 1.0 : (gradeXpProgress / gradeXpRequired).clamp(0.0, 1.0);

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'current_grade': currentGrade,
        'total_xp': totalXp,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_prayer_date': lastPrayerDate?.toIso8601String(),
        'modules_completed': modulesCompleted.join(','),
        'postures_mastered': posturesMastered.join(','),
        'suras_memorized': surasMemorized.join(','),
        'achievements': achievements.map((a) => a.toEncoded()).join('|'),
        'voice_attempts': _encodeVoiceAttempts(),
      };

  factory ProgressModel.fromMap(Map<String, dynamic> map) => ProgressModel(
        id: map['id'],
        userId: map['user_id'],
        currentGrade: map['current_grade'] ?? 1,
        totalXp: map['total_xp'] ?? 0,
        currentStreak: map['current_streak'] ?? 0,
        longestStreak: map['longest_streak'] ?? 0,
        lastPrayerDate: map['last_prayer_date'] != null
            ? DateTime.parse(map['last_prayer_date'])
            : null,
        modulesCompleted: _splitList(map['modules_completed']),
        posturesMastered: _splitList(map['postures_mastered']),
        surasMemorized: _splitList(map['suras_memorized']),
        achievements: _decodeAchievements(map['achievements'] ?? ''),
        voiceAttempts: {},
      );

  ProgressModel copyWith({
    int? currentGrade,
    int? totalXp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPrayerDate,
    List<String>? modulesCompleted,
    List<String>? posturesMastered,
    List<String>? surasMemorized,
    List<AchievementEntry>? achievements,
  }) =>
      ProgressModel(
        id: id,
        userId: userId,
        currentGrade: currentGrade ?? this.currentGrade,
        totalXp: totalXp ?? this.totalXp,
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastPrayerDate: lastPrayerDate ?? this.lastPrayerDate,
        modulesCompleted: modulesCompleted ?? this.modulesCompleted,
        posturesMastered: posturesMastered ?? this.posturesMastered,
        surasMemorized: surasMemorized ?? this.surasMemorized,
        achievements: achievements ?? this.achievements,
        voiceAttempts: voiceAttempts,
      );

  factory ProgressModel.initial(String userId) => ProgressModel(
        id: '${userId}_progress',
        userId: userId,
      );

  static List<String> _splitList(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return [];
    return raw.toString().split(',').where((s) => s.isNotEmpty).toList();
  }

  static List<AchievementEntry> _decodeAchievements(String raw) {
    if (raw.isEmpty) return [];
    return raw.split('|').map(AchievementEntry.fromEncoded).where((a) => a != null).cast<AchievementEntry>().toList();
  }

  String _encodeVoiceAttempts() => '';
}

class AchievementEntry {
  final String id;
  final DateTime unlockedAt;

  const AchievementEntry({required this.id, required this.unlockedAt});

  String toEncoded() => '$id@${unlockedAt.toIso8601String()}';

  static AchievementEntry? fromEncoded(String s) {
    final parts = s.split('@');
    if (parts.length < 2) return null;
    return AchievementEntry(
      id: parts[0],
      unlockedAt: DateTime.tryParse(parts[1]) ?? DateTime.now(),
    );
  }
}
