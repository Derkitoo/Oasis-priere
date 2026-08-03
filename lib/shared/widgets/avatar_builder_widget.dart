import 'dart:math' as math;
import 'package:flutter/material.dart';

class AvatarBuilderWidget extends StatelessWidget {
  final Color skinColor;
  final Color outfitColor;
  final String headwearId; // 'none', 'chechia_white', 'chechia_gold', 'hijab_pink', 'hijab_emerald', 'turban'
  final String expression; // 'happy', 'focused', 'peaceful'
  final String accessoryId; // 'none', 'tasbih_wood', 'tasbih_gold', 'lantern', 'aura'
  final double size;

  const AvatarBuilderWidget({
    super.key,
    required this.skinColor,
    required this.outfitColor,
    this.headwearId = 'chechia_white',
    this.expression = 'happy',
    this.accessoryId = 'none',
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF162536),
        boxShadow: [
          BoxShadow(
            color: accessoryId == 'aura'
                ? const Color(0xFFE5C158).withValues(alpha: 0.4)
                : const Color(0xFFE5C158).withValues(alpha: 0.15),
            blurRadius: accessoryId == 'aura' ? 28 : 16,
            spreadRadius: accessoryId == 'aura' ? 4 : 0,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE5C158).withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size * 1.3),
          painter: _AvatarPainter(
            skinColor: skinColor,
            outfitColor: outfitColor,
            headwearId: headwearId,
            expression: expression,
            accessoryId: accessoryId,
          ),
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final Color skinColor;
  final Color outfitColor;
  final String headwearId;
  final String expression;
  final String accessoryId;

  _AvatarPainter({
    required this.skinColor,
    required this.outfitColor,
    required this.headwearId,
    required this.expression,
    required this.accessoryId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // 1. Layer Aura lumineuse (si équipée)
    if (accessoryId == 'aura') {
      final auraPaint = Paint()
        ..color = const Color(0xFFE5C158).withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(cx, cy * 0.8), size.width * 0.38, auraPaint);
    }

    // 2. Layer Tapis / Fond de profil
    final rugPaint = Paint()..color = const Color(0xFF1E384D);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, size.height * 0.95), width: size.width * 0.9, height: size.height * 0.3),
      0,
      math.pi,
      false,
      rugPaint,
    );

    // 3. Layer Cou (Neck)
    final neckPaint = Paint()..color = skinColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, size.height * 0.58), width: size.width * 0.16, height: size.height * 0.14),
        const Radius.circular(6),
      ),
      neckPaint,
    );

    // 4. Layer Corps (Buste & Tenue Qamis/Abaya)
    final bodyPaint = Paint()..color = outfitColor;
    final bodyPath = Path()
      ..moveTo(cx - size.width * 0.32, size.height * 0.95)
      ..lineTo(cx - size.width * 0.22, size.height * 0.60)
      ..quadraticBezierTo(cx, size.height * 0.58, cx + size.width * 0.22, size.height * 0.60)
      ..lineTo(cx + size.width * 0.32, size.height * 0.95)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Col / Broderie dorée sur le col
    final collarPaint = Paint()
      ..color = const Color(0xFFE5C158)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, size.height * 0.61), width: size.width * 0.22, height: size.height * 0.12),
      0.1,
      math.pi - 0.2,
      false,
      collarPaint,
    );

    // 5. Layer Tête (Head)
    final headPaint = Paint()..color = skinColor;
    final headCenter = Offset(cx, size.height * 0.40);
    final headRadius = size.width * 0.24;
    canvas.drawCircle(headCenter, headRadius, headPaint);

    // 6. Layer Ombre sous le visage
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.08);
    canvas.drawArc(
      Rect.fromCircle(center: headCenter, radius: headRadius),
      0.2,
      math.pi - 0.4,
      false,
      shadowPaint,
    );

    // 7. Layer Yeux & Expressions
    final eyePaint = Paint()..color = const Color(0xFF1E140E);
    if (expression == 'focused') {
      // Yeux sereins / concentrés (arcs fermés doux)
      final eyeStroke = Paint()
        ..color = const Color(0xFF1E140E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCenter(center: Offset(cx - 9, headCenter.dy - 2), width: 10, height: 6), math.pi, math.pi, false, eyeStroke);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + 9, headCenter.dy - 2), width: 10, height: 6), math.pi, math.pi, false, eyeStroke);
    } else {
      // Yeux ouverts expressifs avec reflet brillant
      canvas.drawCircle(Offset(cx - 9, headCenter.dy - 3), 3.5, eyePaint);
      canvas.drawCircle(Offset(cx + 9, headCenter.dy - 3), 3.5, eyePaint);
      // Reflets
      final pupilGlint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cx - 10, headCenter.dy - 4.5), 1.2, pupilGlint);
      canvas.drawCircle(Offset(cx + 8, headCenter.dy - 4.5), 1.2, pupilGlint);
    }

    // Sourcils
    final browPaint = Paint()
      ..color = const Color(0xFF2E1C14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - 9, headCenter.dy - 10), width: 10, height: 4), math.pi + 0.3, math.pi - 0.6, false, browPaint);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + 9, headCenter.dy - 10), width: 10, height: 4), math.pi + 0.3, math.pi - 0.6, false, browPaint);

    // Sourire / Bouche
    final mouthPaint = Paint()
      ..color = const Color(0xFF7A3525)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, headCenter.dy + 7), width: 14, height: 8),
      0.1,
      math.pi - 0.2,
      false,
      mouthPaint,
    );

    // Pommettes roses (Cheeks)
    final blushPaint = Paint()..color = const Color(0xFFE57373).withValues(alpha: 0.25);
    canvas.drawCircle(Offset(cx - 15, headCenter.dy + 4), 4, blushPaint);
    canvas.drawCircle(Offset(cx + 15, headCenter.dy + 4), 4, blushPaint);

    // 8. Layer Couvre-chef / Hijab / Chéchia
    if (headwearId.startsWith('chechia')) {
      final isGold = headwearId.contains('gold');
      final capPaint = Paint()..color = isGold ? const Color(0xFFE5C158) : const Color(0xFFF5F5F5);
      final capPath = Path()
        ..moveTo(cx - headRadius * 0.95, headCenter.dy - headRadius * 0.3)
        ..quadraticBezierTo(cx, headCenter.dy - headRadius * 1.35, cx + headRadius * 0.95, headCenter.dy - headRadius * 0.3)
        ..close();
      canvas.drawPath(capPath, capPaint);

      // Motif de broderie sur le bord de la chéchia
      final trimPaint = Paint()
        ..color = isGold ? const Color(0xFF8C6D1F) : const Color(0xFFE5C158)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(cx - headRadius * 0.9, headCenter.dy - headRadius * 0.3),
        Offset(cx + headRadius * 0.9, headCenter.dy - headRadius * 0.3),
        trimPaint,
      );
    } else if (headwearId.startsWith('hijab')) {
      final isEmerald = headwearId.contains('emerald');
      final hijabColor = isEmerald ? const Color(0xFF2A9D8F) : const Color(0xFFE76F51);
      final hijabPaint = Paint()..color = hijabColor;

      // Voile couvrant le haut et les côtés
      final hijabPath = Path()
        ..moveTo(cx - headRadius * 1.1, headCenter.dy + headRadius * 0.6)
        ..quadraticBezierTo(cx - headRadius * 1.2, headCenter.dy - headRadius * 1.2, cx, headCenter.dy - headRadius * 1.25)
        ..quadraticBezierTo(cx + headRadius * 1.2, headCenter.dy - headRadius * 1.2, cx + headRadius * 1.1, headCenter.dy + headRadius * 0.6)
        ..quadraticBezierTo(cx, headCenter.dy + headRadius * 0.9, cx - headRadius * 1.1, headCenter.dy + headRadius * 0.6)
        ..close();
      canvas.drawPath(hijabPath, hijabPaint);
    }

    // 9. Layer Accessoire portable (Tasbih / Lanterne)
    if (accessoryId == 'tasbih_wood' || accessoryId == 'tasbih_gold') {
      final isGold = accessoryId.contains('gold');
      final beadPaint = Paint()..color = isGold ? const Color(0xFFE5C158) : const Color(0xFF8D6E63);
      for (int i = 0; i < 7; i++) {
        final angle = 0.3 + (i * 0.2);
        final bx = cx + size.width * 0.26 + math.cos(angle) * 12;
        final by = size.height * 0.72 + math.sin(angle) * 16;
        canvas.drawCircle(Offset(bx, by), 3, beadPaint);
      }
    } else if (accessoryId == 'lantern') {
      final lanternPaint = Paint()..color = const Color(0xFFE5C158);
      final lx = cx - size.width * 0.28;
      final ly = size.height * 0.74;
      canvas.drawRect(Rect.fromCenter(center: Offset(lx, ly), width: 10, height: 14), lanternPaint);
      final glow = Paint()
        ..color = const Color(0xFFFFF176).withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(lx, ly), 8, glow);
    }
  }

  @override
  bool shouldRepaint(_AvatarPainter old) =>
      old.skinColor != skinColor ||
      old.outfitColor != outfitColor ||
      old.headwearId != headwearId ||
      old.expression != expression ||
      old.accessoryId != accessoryId;
}
