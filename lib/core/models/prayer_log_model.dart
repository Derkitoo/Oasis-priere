class PrayerLogModel {
  final String id;
  final String userId;
  final String prayerName; // Fajr | Dhuhr | Asr | Maghreb | Isha
  final String mode; // 'learning' | 'guided' | 'autonomous'
  final int rakatCount;
  final DateTime completedAt;
  final bool qiblaAligned;
  final bool tasbihDone;
  final int xpEarned;
  final int durationSeconds;
  final double? voiceScore; // 0.0 – 1.0

  const PrayerLogModel({
    required this.id,
    required this.userId,
    required this.prayerName,
    required this.mode,
    required this.rakatCount,
    required this.completedAt,
    this.qiblaAligned = false,
    this.tasbihDone = false,
    required this.xpEarned,
    required this.durationSeconds,
    this.voiceScore,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'prayer_name': prayerName,
        'mode': mode,
        'rakat_count': rakatCount,
        'completed_at': completedAt.toIso8601String(),
        'qibla_aligned': qiblaAligned ? 1 : 0,
        'tasbih_done': tasbihDone ? 1 : 0,
        'xp_earned': xpEarned,
        'duration_seconds': durationSeconds,
        'voice_score': voiceScore,
      };

  factory PrayerLogModel.fromMap(Map<String, dynamic> map) => PrayerLogModel(
        id: map['id'],
        userId: map['user_id'],
        prayerName: map['prayer_name'],
        mode: map['mode'],
        rakatCount: map['rakat_count'],
        completedAt: DateTime.parse(map['completed_at']),
        qiblaAligned: (map['qibla_aligned'] ?? 0) == 1,
        tasbihDone: (map['tasbih_done'] ?? 0) == 1,
        xpEarned: map['xp_earned'] ?? 0,
        durationSeconds: map['duration_seconds'] ?? 0,
        voiceScore: map['voice_score'],
      );

  factory PrayerLogModel.create({
    required String userId,
    required String prayerName,
    required String mode,
    required int rakatCount,
    required int xpEarned,
    required int durationSeconds,
    bool qiblaAligned = false,
    bool tasbihDone = false,
    double? voiceScore,
  }) =>
      PrayerLogModel(
        id: '${userId}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        prayerName: prayerName,
        mode: mode,
        rakatCount: rakatCount,
        completedAt: DateTime.now(),
        qiblaAligned: qiblaAligned,
        tasbihDone: tasbihDone,
        xpEarned: xpEarned,
        durationSeconds: durationSeconds,
        voiceScore: voiceScore,
      );

  bool get isToday {
    final now = DateTime.now();
    return completedAt.year == now.year &&
        completedAt.month == now.month &&
        completedAt.day == now.day;
  }
}
