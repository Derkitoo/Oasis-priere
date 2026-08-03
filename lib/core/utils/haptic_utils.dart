import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vibration/vibration.dart';

Future<void> vibrate({int duration = 50, int amplitude = 60, List<int>? pattern}) async {
  if (kIsWeb) return;
  try {
    if (pattern != null) {
      await Vibration.vibrate(pattern: pattern, duration: duration, amplitude: amplitude);
    } else {
      await Vibration.vibrate(duration: duration, amplitude: amplitude);
    }
  } catch (_) {}
}
