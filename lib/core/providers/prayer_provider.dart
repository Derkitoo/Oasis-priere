import 'package:flutter/foundation.dart';
import '../services/prayer_time_service.dart';
import '../models/user_model.dart';

class PrayerProvider extends ChangeNotifier {
  final PrayerTimeService _service = PrayerTimeService();

  PrayerTimes? _todayTimes;
  String? _currentPrayerName;
  bool _isLoading = false;

  PrayerTimes? get todayTimes => _todayTimes;
  String? get currentPrayerName => _currentPrayerName;
  bool get isLoading => _isLoading;

  Future<void> loadTimes(UserModel user) async {
    if (user.latitude == null || user.longitude == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      _todayTimes = _service.calculate(
        latitude: user.latitude!,
        longitude: user.longitude!,
        date: DateTime.now(),
        method: user.calculationMethod,
      );
      _currentPrayerName = _todayTimes?.getNextName();
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _currentPrayerName = _todayTimes?.getNextName();
    notifyListeners();
  }

  String formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Map<String, String> get formattedTimes {
    if (_todayTimes == null) return {};
    return {
      'Fajr': formatTime(_todayTimes!.fajr),
      'Dhuhr': formatTime(_todayTimes!.dhuhr),
      'Asr': formatTime(_todayTimes!.asr),
      'Maghreb': formatTime(_todayTimes!.maghreb),
      'Isha': formatTime(_todayTimes!.isha),
    };
  }
}
