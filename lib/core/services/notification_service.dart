import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import '../models/user_model.dart';
import 'prayer_time_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (kIsWeb || _initialized) return;
    tzData.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    final android = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return android ?? ios ?? false;
  }

  Future<void> schedulePrayerNotifications(UserModel user, PrayerTimes times) async {
    if (kIsWeb || !user.notificationsEnabled) return;

    // Annule les précédentes
    await cancelAll();

    final prayerTimeMap = times.all;
    int notifId = 0;

    for (final entry in prayerTimeMap.entries) {
      final name = entry.key;
      if (!(user.prayerReminders[name] ?? false)) continue;

      final delay = user.reminderDelayMinutes[name] ?? 0;
      final scheduledTime = entry.value.add(Duration(minutes: delay));

      if (scheduledTime.isBefore(DateTime.now())) {
        notifId++;
        continue;
      }

      await _plugin.zonedSchedule(
        notifId++,
        'وقت الصلاة — ${_arabicName(name)}',
        'Il est l\'heure de $name, ${_getMessage(name)} 🌙',
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times',
            'Horaires de prière',
            channelDescription: 'Rappels pour les 5 prières quotidiennes',
            importance: Importance.high,
            priority: Priority.high,
            color: const Color(0xFFC9A84C),
            styleInformation: const BigTextStyleInformation(''),
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'adhan_short.aiff',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
  }

  String _arabicName(String prayer) => switch (prayer) {
        'Fajr' => 'الفجر',
        'Dhuhr' => 'الظهر',
        'Asr' => 'العصر',
        'Maghreb' => 'المغرب',
        'Isha' => 'العشاء',
        _ => prayer,
      };

  String _getMessage(String prayer) => switch (prayer) {
        'Fajr' => 'Le soleil se lève, l\'Oasis t\'appelle',
        'Dhuhr' => 'Une pause bénie au milieu du jour',
        'Asr' => 'L\'après-midi s\'illumine',
        'Maghreb' => 'Le coucher de soleil t\'attend',
        'Isha' => 'Que la nuit commence dans la paix',
        _ => 'C\'est l\'heure de prier',
      };
}

