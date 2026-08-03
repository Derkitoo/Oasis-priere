class UserModel {
  final String id;
  final String nickname;
  final String ageBracket; // '7-9' | '10-11' | '12-13'
  final String? genderPref; // 'masc' | 'fem' | null
  final String parentPinHash;
  final String language; // 'fr' | 'ar' | 'fr-ar'
  final bool notificationsEnabled;
  final String prayerCity;
  final double? latitude;
  final double? longitude;
  final String calculationMethod; // 'UOIF' | 'MWL' | ...
  final String themePreference; // 'auto' | 'dark' | 'light'
  final Map<String, bool> prayerReminders; // {'Fajr': true, 'Dhuhr': false, ...}
  final Map<String, int> reminderDelayMinutes; // {'Fajr': 0, 'Dhuhr': 5, ...}
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.nickname,
    required this.ageBracket,
    this.genderPref,
    required this.parentPinHash,
    this.language = 'fr',
    this.notificationsEnabled = true,
    required this.prayerCity,
    this.latitude,
    this.longitude,
    this.calculationMethod = 'UOIF',
    this.themePreference = 'auto',
    required this.prayerReminders,
    required this.reminderDelayMinutes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nickname': nickname,
        'age_bracket': ageBracket,
        'gender_pref': genderPref,
        'parent_pin_hash': parentPinHash,
        'language': language,
        'notifications_enabled': notificationsEnabled ? 1 : 0,
        'prayer_city': prayerCity,
        'latitude': latitude,
        'longitude': longitude,
        'calculation_method': calculationMethod,
        'theme_preference': themePreference,
        'prayer_reminders': _encodeMap(prayerReminders.map((k, v) => MapEntry(k, v ? '1' : '0'))),
        'reminder_delays': _encodeMap(reminderDelayMinutes.map((k, v) => MapEntry(k, v.toString()))),
        'created_at': createdAt.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final remindersRaw = _decodeMap(map['prayer_reminders'] ?? '');
    final delaysRaw = _decodeMap(map['reminder_delays'] ?? '');
    return UserModel(
      id: map['id'],
      nickname: map['nickname'],
      ageBracket: map['age_bracket'],
      genderPref: map['gender_pref'],
      parentPinHash: map['parent_pin_hash'],
      language: map['language'] ?? 'fr',
      notificationsEnabled: (map['notifications_enabled'] ?? 1) == 1,
      prayerCity: map['prayer_city'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      calculationMethod: map['calculation_method'] ?? 'UOIF',
      themePreference: map['theme_preference'] ?? 'auto',
      prayerReminders: remindersRaw.map((k, v) => MapEntry(k, v == '1')),
      reminderDelayMinutes: delaysRaw.map((k, v) => MapEntry(k, int.tryParse(v) ?? 0)),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  UserModel copyWith({
    String? nickname,
    String? ageBracket,
    String? genderPref,
    String? parentPinHash,
    String? language,
    bool? notificationsEnabled,
    String? prayerCity,
    double? latitude,
    double? longitude,
    String? calculationMethod,
    String? themePreference,
    Map<String, bool>? prayerReminders,
    Map<String, int>? reminderDelayMinutes,
  }) =>
      UserModel(
        id: id,
        nickname: nickname ?? this.nickname,
        ageBracket: ageBracket ?? this.ageBracket,
        genderPref: genderPref ?? this.genderPref,
        parentPinHash: parentPinHash ?? this.parentPinHash,
        language: language ?? this.language,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        prayerCity: prayerCity ?? this.prayerCity,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        calculationMethod: calculationMethod ?? this.calculationMethod,
        themePreference: themePreference ?? this.themePreference,
        prayerReminders: prayerReminders ?? this.prayerReminders,
        reminderDelayMinutes: reminderDelayMinutes ?? this.reminderDelayMinutes,
        createdAt: createdAt,
      );

  static String _encodeMap(Map<String, String> map) =>
      map.entries.map((e) => '${e.key}:${e.value}').join(',');

  static Map<String, String> _decodeMap(String encoded) {
    if (encoded.isEmpty) return {};
    return Map.fromEntries(
      encoded.split(',').map((e) {
        final parts = e.split(':');
        return MapEntry(parts[0], parts.length > 1 ? parts[1] : '');
      }),
    );
  }

  static Map<String, bool> defaultReminders() => {
        'Fajr': true,
        'Dhuhr': true,
        'Asr': true,
        'Maghreb': true,
        'Isha': true,
      };

  static Map<String, int> defaultDelays() => {
        'Fajr': 0,
        'Dhuhr': 0,
        'Asr': 0,
        'Maghreb': 0,
        'Isha': 0,
      };
}
