import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/services/qibla_service.dart';
import '../../../core/theme/app_theme.dart';

class QiblaCompassWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final void Function(bool aligned)? onAlignmentChange;

  const QiblaCompassWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.onAlignmentChange,
  });

  @override
  State<QiblaCompassWidget> createState() => _QiblaCompassWidgetState();
}

class _QiblaCompassWidgetState extends State<QiblaCompassWidget> with SingleTickerProviderStateMixin {
  final QiblaService _qibla = QiblaService();
  late double _qiblaBearing;
  double _compassHeading = 0;
  bool _isAligned = false;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _qiblaBearing = _qibla.calculateQiblaBearing(widget.latitude, widget.longitude);
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);

    _qibla.compassStream.listen((heading) {
      if (!mounted) return;
      final aligned = _qibla.isAligned(heading, _qiblaBearing);
      if (aligned && !_isAligned) {
        vibrate(duration: 100, amplitude: 80);
        widget.onAlignmentChange?.call(true);
      } else if (!aligned && _isAligned) {
        widget.onAlignmentChange?.call(false);
      }
      setState(() {
        _compassHeading = heading;
        _isAligned = aligned;
      });
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(
                  color: _isAligned
                      ? AppColors.gold.withValues(alpha: 0.5 + _glowCtrl.value * 0.5)
                      : AppColors.textMuted.withValues(alpha: 0.2),
                  width: _isAligned ? 3 : 1.5,
                ),
                boxShadow: _isAligned
                    ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.3 * _glowCtrl.value), blurRadius: 30)]
                    : null,
              ),
              child: CustomPaint(
                painter: _CompassPainter(
                  compassHeading: _compassHeading,
                  qiblaBearing: _qiblaBearing,
                  isAligned: _isAligned,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isAligned
                ? Container(
                    key: const ValueKey('aligned'),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 18),
                        SizedBox(width: 8),
                        Text('Orienté vers la Qibla ✦', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  )
                : Text(
                    key: const ValueKey('not-aligned'),
                    'Tourne-toi vers ${_qiblaBearing.round()}° (Nord)',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            'Distance de La Mecque : ${_qibla.distanceToMakkah(widget.latitude, widget.longitude).round()} km',
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
        ],
      );
}

class _CompassPainter extends CustomPainter {
  final double compassHeading;
  final double qiblaBearing;
  final bool isAligned;

  _CompassPainter({required this.compassHeading, required this.qiblaBearing, required this.isAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 12;

    // Cercle de fond
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = AppColors.bgCard3);

    // Graduations
    for (int i = 0; i < 36; i++) {
      final angle = i * 10.0 * math.pi / 180 - compassHeading * math.pi / 180;
      final isMajor = i % 9 == 0;
      final len = isMajor ? 10.0 : 5.0;
      canvas.drawLine(
        Offset(cx + (r - len) * math.sin(angle), cy - (r - len) * math.cos(angle)),
        Offset(cx + r * math.sin(angle), cy - r * math.cos(angle)),
        Paint()..color = (isMajor ? AppColors.textMuted : AppColors.textMuted.withValues(alpha: 0.3))..strokeWidth = isMajor ? 2 : 1,
      );
    }

    // Points cardinaux N S E O
    _drawCardinal(canvas, cx, cy, r - 20, 'N', -compassHeading * math.pi / 180);
    _drawCardinal(canvas, cx, cy, r - 20, 'S', math.pi - compassHeading * math.pi / 180);
    _drawCardinal(canvas, cx, cy, r - 20, 'E', math.pi / 2 - compassHeading * math.pi / 180);
    _drawCardinal(canvas, cx, cy, r - 20, 'O', -math.pi / 2 - compassHeading * math.pi / 180);

    // Rayon doré vers la Qibla
    final qiblaAngle = (qiblaBearing - compassHeading) * math.pi / 180;
    final rayPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.bgCard3, isAligned ? AppColors.goldLight : AppColors.gold],
        begin: Alignment.center,
        end: Alignment.topCenter,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.8 * math.sin(qiblaAngle), cy - r * 0.8 * math.cos(qiblaAngle)),
      rayPaint,
    );

    // Kaaba au bout
    final kaabaX = cx + r * 0.82 * math.sin(qiblaAngle);
    final kaabaY = cy - r * 0.82 * math.cos(qiblaAngle);
    canvas.drawCircle(Offset(kaabaX, kaabaY), 8,
        Paint()..color = isAligned ? AppColors.gold : AppColors.goldDim);

    final tp = TextPainter(
      text: const TextSpan(text: '🕌', style: TextStyle(fontSize: 10)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(kaabaX - 5, kaabaY - 5));

    // Centre
    canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = AppColors.bgCard2);
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = AppColors.gold);
  }

  void _drawCardinal(Canvas canvas, double cx, double cy, double r, String letter, double angle) {
    final x = cx + r * math.sin(angle);
    final y = cy - r * math.cos(angle);
    final tp = TextPainter(
      text: TextSpan(text: letter, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: letter == 'N' ? AppColors.roseLight : AppColors.textMuted)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_CompassPainter old) =>
      old.compassHeading != compassHeading || old.isAligned != isAligned;
}
