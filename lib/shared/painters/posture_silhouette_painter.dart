import 'package:flutter/material.dart';

class PostureSilhouettePainter extends CustomPainter {
  final String postureId;
  final Color color;

  const PostureSilhouettePainter(this.postureId, {this.color = const Color(0xFF4ECDC4)});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.height / 100; // 100 unités de référence
    final cx = size.width / 2;

    final stroke = Paint()
      ..color = color
      ..strokeWidth = 3.0 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final fillDim = Paint()..color = color.withOpacity(0.55)..style = PaintingStyle.fill;

    // Ligne de sol
    final ground = Paint()..color = color.withOpacity(0.18)..strokeWidth = 1.5 * s..style = PaintingStyle.stroke;

    switch (postureId) {
      case 'qiyam':
      case 'i_tidal':
        _standing(canvas, cx, s, stroke, fill, ground, armsUp: false);

      case 'takbir':
        _standing(canvas, cx, s, stroke, fill, ground, armsUp: true);

      case 'ruku':
        _ruku(canvas, cx, s, stroke, fill, ground);

      case 'sujud':
        _sujud(canvas, cx, s, stroke, fill, fillDim, ground);

      case 'joulous':
        _sitting(canvas, cx, s, stroke, fill, ground, indexUp: false);

      case 'tashahhud':
        _sitting(canvas, cx, s, stroke, fill, ground, indexUp: true);

      case 'salam':
        _salam(canvas, cx, s, stroke, fill, ground);
    }
  }

  // ──────────────────────────────────────────────
  // DEBOUT (Qiyam / I'tidal)
  // ──────────────────────────────────────────────
  void _standing(Canvas canvas, double cx, double s, Paint st, Paint fill, Paint ground, {required bool armsUp}) {
    canvas.drawCircle(Offset(cx, 14 * s), 7 * s, fill);           // tête
    canvas.drawLine(Offset(cx, 21 * s), Offset(cx, 58 * s), st);  // corps
    if (armsUp) {
      // Bras levés (Takbir d'ouverture)
      canvas.drawLine(Offset(cx, 32 * s), Offset(cx - 22 * s, 20 * s), st);
      canvas.drawLine(Offset(cx, 32 * s), Offset(cx + 22 * s, 20 * s), st);
    } else {
      // Bras croisés sur la poitrine (Qiyam)
      canvas.drawLine(Offset(cx - 16 * s, 36 * s), Offset(cx + 8 * s, 30 * s), st);
      canvas.drawLine(Offset(cx + 16 * s, 36 * s), Offset(cx - 8 * s, 30 * s), st);
    }
    canvas.drawLine(Offset(cx, 58 * s), Offset(cx - 10 * s, 88 * s), st); // jambe gauche
    canvas.drawLine(Offset(cx, 58 * s), Offset(cx + 10 * s, 88 * s), st); // jambe droite
    canvas.drawLine(Offset(cx - 20 * s, 88 * s), Offset(cx + 20 * s, 88 * s), ground);
  }

  // ──────────────────────────────────────────────
  // RUKU (courbé à 90°)
  // ──────────────────────────────────────────────
  void _ruku(Canvas canvas, double cx, double s, Paint st, Paint fill, Paint ground) {
    // Tête avancée
    canvas.drawCircle(Offset(cx - 26 * s, 42 * s), 7 * s, fill);
    // Corps horizontal
    canvas.drawLine(Offset(cx - 19 * s, 42 * s), Offset(cx + 14 * s, 42 * s), st);
    // Colonne verticale vers le bas
    canvas.drawLine(Offset(cx + 14 * s, 42 * s), Offset(cx + 14 * s, 72 * s), st);
    // Jambes
    canvas.drawLine(Offset(cx + 14 * s, 72 * s), Offset(cx + 4 * s, 88 * s), st);
    canvas.drawLine(Offset(cx + 14 * s, 72 * s), Offset(cx + 24 * s, 88 * s), st);
    // Bras vers les genoux
    canvas.drawLine(Offset(cx - 8 * s, 42 * s), Offset(cx + 4 * s, 60 * s), st);
    canvas.drawLine(Offset(cx + 2 * s, 42 * s), Offset(cx + 14 * s, 58 * s), st);
    canvas.drawLine(Offset(cx - 10 * s, 88 * s), Offset(cx + 34 * s, 88 * s), ground);
  }

  // ──────────────────────────────────────────────
  // SUJUD (prosterné)
  // ──────────────────────────────────────────────
  void _sujud(Canvas canvas, double cx, double s, Paint st, Paint fill, Paint fillDim, Paint ground) {
    // Tête au sol (cercle)
    canvas.drawCircle(Offset(cx - 26 * s, 74 * s), 6 * s, fill);
    // Mains de chaque côté de la tête
    canvas.drawCircle(Offset(cx - 36 * s, 78 * s), 3.5 * s, fillDim);
    canvas.drawCircle(Offset(cx - 16 * s, 78 * s), 3.5 * s, fillDim);
    // Corps en arc
    final body = Path();
    body.moveTo(cx - 20 * s, 74 * s);
    body.quadraticBezierTo(cx, 45 * s, cx + 18 * s, 60 * s);
    canvas.drawPath(body, st);
    // Genoux au sol
    canvas.drawLine(Offset(cx + 18 * s, 60 * s), Offset(cx + 8 * s, 82 * s), st);
    canvas.drawLine(Offset(cx + 18 * s, 60 * s), Offset(cx + 30 * s, 78 * s), st);
    // Pieds
    canvas.drawLine(Offset(cx + 8 * s, 82 * s), Offset(cx - 2 * s, 86 * s), st);
    canvas.drawLine(Offset(cx + 30 * s, 78 * s), Offset(cx + 40 * s, 83 * s), st);
    canvas.drawLine(Offset(cx - 40 * s, 88 * s), Offset(cx + 50 * s, 88 * s), ground);
  }

  // ──────────────────────────────────────────────
  // ASSIS (Joulous / Tashahhud)
  // ──────────────────────────────────────────────
  void _sitting(Canvas canvas, double cx, double s, Paint st, Paint fill, Paint ground, {required bool indexUp}) {
    canvas.drawCircle(Offset(cx, 18 * s), 7 * s, fill);           // tête
    canvas.drawLine(Offset(cx, 25 * s), Offset(cx, 55 * s), st);  // corps
    // Bras sur les genoux
    canvas.drawLine(Offset(cx, 40 * s), Offset(cx - 20 * s, 52 * s), st);
    canvas.drawLine(Offset(cx, 40 * s), Offset(cx + 20 * s, 52 * s), st);
    // Index levé (Tashahhud)
    if (indexUp) {
      canvas.drawLine(Offset(cx + 20 * s, 52 * s), Offset(cx + 25 * s, 36 * s), st);
    }
    // Jambes pliées
    canvas.drawLine(Offset(cx, 55 * s), Offset(cx - 18 * s, 67 * s), st);
    canvas.drawLine(Offset(cx - 18 * s, 67 * s), Offset(cx - 30 * s, 82 * s), st);
    canvas.drawLine(Offset(cx, 55 * s), Offset(cx + 18 * s, 67 * s), st);
    canvas.drawLine(Offset(cx + 18 * s, 67 * s), Offset(cx + 30 * s, 82 * s), st);
    canvas.drawLine(Offset(cx - 36 * s, 87 * s), Offset(cx + 36 * s, 87 * s), ground);
  }

  // ──────────────────────────────────────────────
  // SALAM (tête tournée)
  // ──────────────────────────────────────────────
  void _salam(Canvas canvas, double cx, double s, Paint st, Paint fill, Paint ground) {
    // Tête tournée à droite
    canvas.drawCircle(Offset(cx + 8 * s, 18 * s), 7 * s, fill);
    // Petit trait de direction
    canvas.drawLine(Offset(cx + 14 * s, 18 * s), Offset(cx + 22 * s, 18 * s), st);
    // Corps
    canvas.drawLine(Offset(cx, 25 * s), Offset(cx, 55 * s), st);
    // Bras croisés
    canvas.drawLine(Offset(cx - 16 * s, 36 * s), Offset(cx + 8 * s, 30 * s), st);
    canvas.drawLine(Offset(cx + 16 * s, 36 * s), Offset(cx - 8 * s, 30 * s), st);
    // Jambes
    canvas.drawLine(Offset(cx, 55 * s), Offset(cx - 10 * s, 88 * s), st);
    canvas.drawLine(Offset(cx, 55 * s), Offset(cx + 10 * s, 88 * s), st);
    canvas.drawLine(Offset(cx - 20 * s, 88 * s), Offset(cx + 20 * s, 88 * s), ground);
  }

  @override
  bool shouldRepaint(PostureSilhouettePainter old) => old.postureId != postureId || old.color != color;
}
