import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FaithTreeWidget extends StatefulWidget {
  final int stage; // 0–10
  final int leavesCount;
  final bool animate;

  const FaithTreeWidget({super.key, required this.stage, required this.leavesCount, this.animate = false});

  @override
  State<FaithTreeWidget> createState() => _FaithTreeWidgetState();
}

class _FaithTreeWidgetState extends State<FaithTreeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _leafAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _leafAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    if (widget.animate) _ctrl.forward();
  }

  @override
  void didUpdateWidget(FaithTreeWidget old) {
    super.didUpdateWidget(old);
    if (widget.animate && widget.leavesCount != old.leavesCount) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _leafAnim,
        builder: (_, __) => CustomPaint(
          size: const Size(120, 160),
          painter: _TreePainter(stage: widget.stage, leavesCount: widget.leavesCount, leafAnim: _leafAnim.value),
        ),
      );
}

class _TreePainter extends CustomPainter {
  final int stage;
  final int leavesCount;
  final double leafAnim;

  _TreePainter({required this.stage, required this.leavesCount, required this.leafAnim});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final baseY = size.height - 10;

    // Tronc
    final trunkH = 30.0 + stage * 8.0;
    final trunkW = 8.0 + stage * 1.5;
    final trunkPaint = Paint()..color = const Color(0xFF6B4226);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, baseY - trunkH / 2), width: trunkW, height: trunkH),
        const Radius.circular(4),
      ),
      trunkPaint,
    );

    if (stage == 0) return;

    // Branches et feuilles
    final leafCount = leavesCount.clamp(0, 50);
    final r = math.Random(42);
    final topY = baseY - trunkH;

    for (int i = 0; i < leafCount; i++) {
      final angle = r.nextDouble() * math.pi * 2;
      final dist = r.nextDouble() * (15.0 + stage * 5);
      final lx = cx + math.cos(angle) * dist;
      final ly = topY - r.nextDouble() * (20.0 + stage * 8) + 10;
      final leafSize = (6.0 + r.nextDouble() * 6) * (i == leafCount - 1 ? leafAnim : 1.0);
      final alpha = (0.6 + r.nextDouble() * 0.4);
      final leafColor = Color.lerp(AppColors.faithGreen, AppColors.faithGreenLight, r.nextDouble())!
          .withOpacity(alpha);
      canvas.drawCircle(Offset(lx, ly), leafSize, Paint()..color = leafColor);
    }

    // Petites étincelles dorées si stage élevé
    if (stage >= 7) {
      for (int i = 0; i < 5; i++) {
        final angle = r.nextDouble() * math.pi * 2;
        final dist = r.nextDouble() * (stage * 7.0);
        canvas.drawCircle(
          Offset(cx + math.cos(angle) * dist, topY - r.nextDouble() * 60),
          1.5,
          Paint()..color = AppColors.goldLight.withOpacity(0.7),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TreePainter old) =>
      old.stage != stage || old.leavesCount != leavesCount || old.leafAnim != leafAnim;
}
