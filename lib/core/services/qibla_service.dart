import 'dart:math' as math;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sensors_plus/sensors_plus.dart';

class QiblaService {
  static const double _kaabahLat = 21.4225;
  static const double _kaabahLng = 39.8262;

  double calculateQiblaBearing(double userLat, double userLng) {
    final lat1 = _toRad(userLat);
    final lat2 = _toRad(_kaabahLat);
    final dLng = _toRad(_kaabahLng - userLng);

    final x = math.sin(dLng) * math.cos(lat2);
    final y = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);

    final bearing = _toDeg(math.atan2(x, y));
    return (bearing + 360) % 360;
  }

  // Sur web : pas de magnétomètre, on retourne un stream vide
  Stream<double> get compassStream {
    if (kIsWeb) return const Stream.empty();
    return magnetometerEventStream().map((event) {
      final angle = _toDeg(math.atan2(event.y, event.x));
      return (angle + 360) % 360;
    }).handleError((_) {});
  }

  bool isAligned(double compassHeading, double qiblaBearing, {double tolerance = 5.0}) {
    final diff = ((compassHeading - qiblaBearing + 180) % 360) - 180;
    return diff.abs() <= tolerance;
  }

  double _toRad(double deg) => deg * math.pi / 180;
  double _toDeg(double rad) => rad * 180 / math.pi;

  double distanceToMakkah(double lat, double lng) {
    const R = 6371.0;
    final dLat = _toRad(_kaabahLat - lat);
    final dLng = _toRad(_kaabahLng - lng);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat)) * math.cos(_toRad(_kaabahLat)) *
            math.sin(dLng / 2) * math.sin(dLng / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }
}
