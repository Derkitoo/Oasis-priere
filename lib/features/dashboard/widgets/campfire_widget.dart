import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CampfireWidget extends StatefulWidget {
  final double intensity; // 0.0 – 1.0
  final bool isGolden; // Streak >= 30

  const CampfireWidget({super.key, required this.intensity, this.isGolden = false});

  @override
  State<CampfireWidget> createState() => _CampfireWidgetState();
}

class _CampfireWidgetState extends State<CampfireWidget> with TickerProviderStateMixin {
  late AnimationController _flameCtrl;
  late AnimationController _glowCtrl;
  late Animation<double> _flameAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _flameCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _flameAnim = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _flameCtrl, curve: Curves.easeInOut));
    _glowAnim = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _flameCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([_flameAnim, _glowAnim]),
        builder: (_, __) => CustomPaint(
          size: const Size(160, 160),
          painter: _CampfirePainter(
            flameT: _flameAnim.value,
            glowT: _glowAnim.value,
            intensity: widget.intensity,
            isGolden: widget.isGolden,
          ),
        ),
      );
}

class _CampfirePainter extends CustomPainter {
  final double flameT;
  final double glowT;
  final double intensity;
  final bool isGolden;

  _CampfirePainter({required this.flameT, required this.glowT, required this.intensity, required this.isGolden});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;

    // Halo de lumière au sol
    if (intensity > 0.1) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            (isGolden ? AppColors.goldLight : AppColors.gold).withOpacity(0.18 * intensity * glowT),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 70));
      canvas.drawCircle(Offset(cx, cy), 70, glowPaint);
    }

    // Braises / buche
    final logPaint = Paint()..color = const Color(0xFF4A3728);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 10), width: 60, height: 10), const Radius.circular(5)),
      logPaint,
    );
    final log2Paint = Paint()..color = const Color(0xFF3D2D1F);
    canvas.save();
    canvas.translate(cx, cy + 8);
    canvas.rotate(0.4);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-28, -5, 56, 10), const Radius.circular(5)), log2Paint);
    canvas.restore();

    if (intensity <= 0.05) return;

    final flameCount = (2 + (intensity * 3).round()).clamp(2, 5);
    for (int i = 0; i < flameCount; i++) {
      _drawFlame(canvas, cx, cy, i, flameCount);
    }
  }

  void _drawFlame(Canvas canvas, double cx, double cy, int index, int total) {
    final r = math.Random(index * 7 + 3);
    final spread = 20.0 * (total / 5.0);
    final offsetX = (index - total / 2.0) * (spread / total) + r.nextDouble() * 4 - 2;
    final baseH = 40.0 + intensity * 40.0;
    final flickerH = baseH + (flameT * 14 - 7) * (r.nextDouble() + 0.5);
    final flickerW = 14.0 + intensity * 8 + (flameT * 4 - 2);

    final Color inner = isGolden
        ? AppColors.goldLight
        : Color.lerp(const Color(0xFFFFFFAA), const Color(0xFFFF9900), 0.3 + 0.5 * r.nextDouble())!;
    final Color outer = isGolden
        ? AppColors.gold
        : Color.lerp(const Color(0xFFFF6600), const Color(0xFFCC2200), r.nextDouble())!;

    final path = Path();
    final x = cx + offsetX;
    final base = cy + 2;
    path.moveTo(x - flickerW / 2, base);
    path.quadraticBezierTo(
      x - flickerW * 0.3 + flameT * 3,
      base - flickerH * 0.5,
      x + (flameT - 0.5) * 6,
      base - flickerH,
    );
    path.quadraticBezierTo(
      x + flickerW * 0.3 - flameT * 3,
      base - flickerH * 0.5,
      x + flickerW / 2,
      base,
    );
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [outer.withOpacity(0.9 * intensity), inner.withOpacity(0.7 * intensity)],
      ).createShader(Rect.fromLTWH(x - flickerW, base - flickerH, flickerW * 2, flickerH));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CampfirePainter old) =>
      old.flameT != flameT || old.glowT != glowT || old.intensity != intensity;
}
