import 'dart:math' as math;

class PrayerTimes {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghreb;
  final DateTime isha;
  final DateTime date;

  const PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghreb,
    required this.isha,
    required this.date,
  });

  DateTime? getNext() {
    final now = DateTime.now();
    final all = [fajr, dhuhr, asr, maghreb, isha];
    for (final t in all) {
      if (t.isAfter(now)) return t;
    }
    return null;
  }

  String? getNextName() {
    final now = DateTime.now();
    final all = {'Fajr': fajr, 'Dhuhr': dhuhr, 'Asr': asr, 'Maghreb': maghreb, 'Isha': isha};
    for (final entry in all.entries) {
      if (entry.value.isAfter(now)) return entry.key;
    }
    return null;
  }

  bool isPrayerDone(String name) {
    final now = DateTime.now();
    final t = _getTime(name);
    if (t == null) return false;
    final nextPrayer = _getNextAfter(name);
    return now.isAfter(t) && (nextPrayer == null || now.isBefore(nextPrayer));
  }

  DateTime? _getTime(String name) => switch (name) {
        'Fajr' => fajr,
        'Dhuhr' => dhuhr,
        'Asr' => asr,
        'Maghreb' => maghreb,
        'Isha' => isha,
        _ => null,
      };

  DateTime? _getNextAfter(String name) => switch (name) {
        'Fajr' => dhuhr,
        'Dhuhr' => asr,
        'Asr' => maghreb,
        'Maghreb' => isha,
        'Isha' => null,
        _ => null,
      };

  Map<String, DateTime> get all => {
        'Fajr': fajr,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghreb': maghreb,
        'Isha': isha,
      };
}

class PrayerTimeService {
  // Implémentation de l'algorithme Adhan (basé sur les éphémérides solaires)
  PrayerTimes calculate({
    required double latitude,
    required double longitude,
    required DateTime date,
    required String method, // 'UOIF' | 'MWL' | 'ISNA' | ...
  }) {
    final angles = _methodAngles(method);
    final fajrAngle = angles[0];
    final ishaAngle = angles[1];
    final makkaMode = method == 'Makkah'; // Isha = 90min après Maghreb

    final jd = _julianDate(date.year, date.month, date.day);
    final d = jd - 2451545.0;

    // Anomalie moyenne du soleil
    final g = _toRad((357.529 + 0.98560028 * d) % 360);
    // Longitude écliptique
    final q = _toRad((280.459 + 0.98564736 * d) % 360);
    final L = q + _toRad(1.915) * math.sin(g) + _toRad(0.020) * math.sin(2 * g);
    // Obliquité de l'écliptique
    final e = _toRad(23.439 - 0.00000036 * d);
    // Ascension droite
    final RA = _toDeg(math.atan2(math.cos(e) * math.sin(L), math.cos(L))) / 15;
    // Déclinaison du soleil
    final D = _toDeg(math.asin(math.sin(e) * math.sin(L)));
    // Équation du temps
    final EqT = _toDeg(q) / 15 - RA;

    // Midi solaire (transit)
    final transit = 12 - longitude / 15 - EqT;

    final latRad = _toRad(latitude);
    final DRad = _toRad(D);

    // Dhuhr
    final dhuhrTime = transit;
    // Asr (méthode Shafi'i : ombre = longueur + 1)
    final asrTime = transit + _hourAngle(latRad, DRad, _shadowAngle(1, latRad, DRad));
    // Maghreb (coucher du soleil)
    final maghrebTime = transit + _hourAngle(latRad, DRad, _toRad(-0.8333));
    // Fajr
    final fajrTime = transit - _hourAngle(latRad, DRad, _toRad(-fajrAngle));
    // Isha
    final ishaTime = makkaMode
        ? maghrebTime + 90.0 / 60.0
        : transit + _hourAngle(latRad, DRad, _toRad(-ishaAngle));

    final tzOffset = date.timeZoneOffset.inHours.toDouble() +
        date.timeZoneOffset.inMinutes.remainder(60) / 60.0;

    return PrayerTimes(
      fajr: _toDateTime(date, fajrTime + tzOffset),
      dhuhr: _toDateTime(date, dhuhrTime + tzOffset),
      asr: _toDateTime(date, asrTime + tzOffset),
      maghreb: _toDateTime(date, maghrebTime + tzOffset),
      isha: _toDateTime(date, ishaTime + tzOffset),
      date: date,
    );
  }

  double _hourAngle(double lat, double dec, double angle) {
    final cosVal = (math.sin(angle) - math.sin(lat) * math.sin(dec)) /
        (math.cos(lat) * math.cos(dec));
    if (cosVal < -1 || cosVal > 1) return 0;
    return _toDeg(math.acos(cosVal)) / 15;
  }

  double _shadowAngle(int factor, double lat, double dec) {
    final targetShadow = factor + math.tan((lat - dec).abs());
    return _toRad(math.atan(1.0 / targetShadow));
  }

  double _julianDate(int year, int month, int day) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final A = (y / 100).floor();
    final B = 2 - A + (A / 4).floor();
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        B -
        1524.5;
  }

  DateTime _toDateTime(DateTime base, double decimalHours) {
    final h = decimalHours.floor();
    final m = ((decimalHours - h) * 60).floor();
    final s = (((decimalHours - h) * 60 - m) * 60).round();
    return DateTime(base.year, base.month, base.day, h.clamp(0, 23), m.clamp(0, 59), s.clamp(0, 59));
  }

  double _toRad(double deg) => deg * math.pi / 180;
  double _toDeg(double rad) => rad * 180 / math.pi;

  List<double> _methodAngles(String method) => switch (method) {
        'UOIF' => [12.0, 12.0],
        'MWL' => [18.0, 17.0],
        'ISNA' => [15.0, 15.0],
        'Egypt' => [19.5, 17.5],
        'Karachi' => [18.0, 18.0],
        'Makkah' => [18.5, 0.0],
        _ => [12.0, 12.0],
      };
}
