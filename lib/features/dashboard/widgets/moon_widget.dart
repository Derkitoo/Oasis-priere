import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MoonWidget extends StatefulWidget {
  final double intensity; // 0.0 – 1.0 selon le streak
  final bool isGolden;   // streak >= 30

  const MoonWidget({super.key, required this.intensity, this.isGolden = false});

  @override
  State<MoonWidget> createState() => _MoonWidgetState();
}

class _MoonWidgetState extends State<MoonWidget> with TickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late AnimationController _twinkleCtrl;
  late Animation<double> _glowAnim;
  late Animation<double> _twinkleAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
    _twinkleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);
    _glowAnim = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _twinkleAnim = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _twinkleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _twinkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([_glowAnim, _twinkleAnim]),
        builder: (_, __) => CustomPaint(
          size: const Size(160, 160),
          painter: _MoonPainter(
            glowT: _glowAnim.value,
            twinkleT: _twinkleAnim.value,
            intensity: widget.intensity,
            isGolden: widget.isGolden,
          ),
        ),
      );
}

class _MoonPainter extends CustomPainter {
  final double glowT;
  final double twinkleT;
  final double intensity;
  final bool isGolden;

  _MoonPainter({required this.glowT, required this.twinkleT, required this.intensity, required this.isGolden});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final R = size.width * 0.32;

    final moonColor = isGolden ? AppColors.goldLight : AppColors.gold;
    final glowColor = isGolden ? AppColors.gold : const Color(0xFFD4A843);

    // Halo de lumière pulsant
    if (intensity > 0.05) {
      final glowRadius = R + 16 + 10 * glowT * intensity;
      final glowPaint = Paint()
        ..shader = RadialGradient(colors: [
          glowColor.withOpacity(0.22 * intensity * glowT),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: glowRadius));
      canvas.drawCircle(Offset(cx, cy), glowRadius, glowPaint);
    }

    // Croissant = grand cercle - petit cercle décalé
    final outer = Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: R));
    final inner = Path()..addOval(Rect.fromCircle(
      center: Offset(cx + R * 0.38, cy - R * 0.06),
      radius: R * 0.76,
    ));
    final crescent = Path.combine(PathOperation.difference, outer, inner);

    final moonPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          moonColor.withOpacity(0.5 + 0.5 * intensity),
          glowColor.withOpacity(0.7 + 0.3 * intensity),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: R));
    canvas.drawPath(crescent, moonPaint);

    // Étoiles — nombre croissant avec le streak
    final starCount = (intensity * 14).round().clamp(0, 14);
    final rnd = math.Random(17); // seed fixe = positions stables
    for (int i = 0; i < starCount; i++) {
      final angle = rnd.nextDouble() * 2 * math.pi;
      final dist = R * 1.2 + rnd.nextDouble() * (size.width / 2 - R * 1.2 - 4);
      final sx = cx + math.cos(angle) * dist;
      final sy = cy + math.sin(angle) * dist;

      // scintillement individuel basé sur l'index
      final phase = (i * 0.37 + twinkleT) % 1.0;
      final brightness = 0.35 + 0.65 * math.sin(phase * math.pi);
      final starSize = 0.8 + (i % 3) * 0.7;

      canvas.drawCircle(
        Offset(sx, sy),
        starSize,
        Paint()..color = moonColor.withOpacity(brightness * intensity),
      );
    }

    // Étoile principale (plus grande, toujours visible dès intensity > 0.1)
    if (intensity > 0.1) {
      _drawStar(canvas, cx - R * 0.15, cy - R * 1.0, 3.5 + glowT, moonColor.withOpacity(0.7 * intensity));
    }
  }

  void _drawStar(Canvas canvas, double x, double y, double r, Color color) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 4;
      final outerX = x + math.cos(angle) * r;
      final outerY = y + math.sin(angle) * r;
      final innerAngle = angle + math.pi / 4;
      final innerX = x + math.cos(innerAngle) * r * 0.4;
      final innerY = y + math.sin(innerAngle) * r * 0.4;
      if (i == 0) path.moveTo(outerX, outerY);
      else path.lineTo(outerX, outerY);
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      old.glowT != glowT || old.twinkleT != twinkleT || old.intensity != intensity;
}
