import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/avatar_model.dart';
import '../models/progress_model.dart';
import '../models/prayer_log_model.dart';

class DatabaseService {
  static Database? _db;
  static const String _dbName = 'oasis_priere.db';
  static const int _dbVersion = 1;

  Future<Database> get db async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        nickname TEXT NOT NULL,
        age_bracket TEXT NOT NULL,
        gender_pref TEXT,
        parent_pin_hash TEXT NOT NULL,
        language TEXT DEFAULT 'fr',
        notifications_enabled INTEGER DEFAULT 1,
        prayer_city TEXT,
        latitude REAL,
        longitude REAL,
        calculation_method TEXT DEFAULT 'UOIF',
        theme_preference TEXT DEFAULT 'auto',
        prayer_reminders TEXT,
        reminder_delays TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE avatars (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        base_skin INTEGER DEFAULT 1,
        outfit_id TEXT,
        prayer_rug_id TEXT,
        lantern_id TEXT,
        camp_decoration_ids TEXT,
        unlocked_items TEXT,
        tree_stage INTEGER DEFAULT 0,
        tree_leaves_count INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE progress (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL UNIQUE,
        current_grade INTEGER DEFAULT 1,
        total_xp INTEGER DEFAULT 0,
        current_streak INTEGER DEFAULT 0,
        longest_streak INTEGER DEFAULT 0,
        last_prayer_date TEXT,
        modules_completed TEXT,
        postures_mastered TEXT,
        suras_memorized TEXT,
        achievements TEXT,
        voice_attempts TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE prayer_logs (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        prayer_name TEXT NOT NULL,
        mode TEXT NOT NULL,
        rakat_count INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        qibla_aligned INTEGER DEFAULT 0,
        tasbih_done INTEGER DEFAULT 0,
        xp_earned INTEGER DEFAULT 0,
        duration_seconds INTEGER DEFAULT 0,
        voice_score REAL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('CREATE INDEX idx_prayer_logs_user ON prayer_logs(user_id)');
    await db.execute('CREATE INDEX idx_prayer_logs_date ON prayer_logs(completed_at)');
  }

  // ── USER ──
  Future<void> saveUser(UserModel user) async {
    final d = await db;
    await d.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser(String id) async {
    final d = await db;
    final rows = await d.query('users', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<UserModel?> getFirstUser() async {
    final d = await db;
    final rows = await d.query('users', limit: 1);
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<void> updateUser(UserModel user) async {
    final d = await db;
    await d.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  // ── AVATAR ──
  Future<void> saveAvatar(AvatarModel avatar) async {
    final d = await db;
    await d.insert('avatars', avatar.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<AvatarModel?> getAvatar(String userId) async {
    final d = await db;
    final rows = await d.query('avatars', where: 'user_id = ?', whereArgs: [userId]);
    if (rows.isEmpty) return null;
    return AvatarModel.fromMap(rows.first);
  }

  Future<void> updateAvatar(AvatarModel avatar) async {
    final d = await db;
    await d.update('avatars', avatar.toMap(), where: 'id = ?', whereArgs: [avatar.id]);
  }

  // ── PROGRESS ──
  Future<void> saveProgress(ProgressModel progress) async {
    final d = await db;
    await d.insert('progress', progress.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ProgressModel?> getProgress(String userId) async {
    final d = await db;
    final rows = await d.query('progress', where: 'user_id = ?', whereArgs: [userId]);
    if (rows.isEmpty) return null;
    return ProgressModel.fromMap(rows.first);
  }

  Future<void> updateProgress(ProgressModel progress) async {
    final d = await db;
    await d.update('progress', progress.toMap(), where: 'user_id = ?', whereArgs: [progress.userId]);
  }

  // ── PRAYER LOGS ──
  Future<void> savePrayerLog(PrayerLogModel log) async {
    final d = await db;
    await d.insert('prayer_logs', log.toMap());
  }

  Future<List<PrayerLogModel>> getPrayerLogsForUser(String userId, {int limit = 100}) async {
    final d = await db;
    final rows = await d.query(
      'prayer_logs',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'completed_at DESC',
      limit: limit,
    );
    return rows.map(PrayerLogModel.fromMap).toList();
  }

  Future<List<PrayerLogModel>> getTodayLogs(String userId) async {
    final d = await db;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day).toIso8601String();
    final end = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    final rows = await d.query(
      'prayer_logs',
      where: 'user_id = ? AND completed_at BETWEEN ? AND ?',
      whereArgs: [userId, start, end],
    );
    return rows.map(PrayerLogModel.fromMap).toList();
  }

  Future<bool> hasPrayedToday(String userId) async {
    final logs = await getTodayLogs(userId);
    return logs.isNotEmpty;
  }
}
