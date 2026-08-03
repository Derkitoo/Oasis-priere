import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/golden_button.dart';
import 'avatar_creation_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _starsCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _starsCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    Future.delayed(const Duration(milliseconds: 400), () => _fadeCtrl.forward());
  }

  @override
  void dispose() {
    _starsCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Stack(
          children: [
            // Fond étoilé animé
            AnimatedBuilder(
              animation: _starsCtrl,
              builder: (_, __) => CustomPaint(
                painter: _StarsPainter(_starsCtrl.value),
                size: MediaQuery.of(context).size,
              ),
            ),

            // Croissant de lune + oasis
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: 0, right: 0,
              child: AnimatedBuilder(
                animation: _fadeAnim,
                builder: (_, child) => Opacity(opacity: _fadeAnim.value, child: child),
                child: const _OasisIllustration(),
              ),
            ),

            // Contenu principal
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 56),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.bgPrimary.withOpacity(0),
                        AppColors.bgPrimary.withOpacity(0.95),
                        AppColors.bgPrimary,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Titre arabe
                      const Text(
                        'واحة الصلاة',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'Amiri',
                          color: AppColors.goldLight,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "L'Oasis de la Prière",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Commence ton voyage vers la prière.\nChaque jour, ton feu intérieur grandit.',
                        style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 36),
                      GoldenButton(
                        label: 'Commencer mon voyage',
                        width: double.infinity,
                        icon: Icons.auto_awesome_rounded,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, a, __) => const AvatarCreationScreen(),
                            transitionsBuilder: (_, anim, __, child) =>
                                FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(milliseconds: 500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {}, // Restore backup
                        child: const Text(
                          "J'ai déjà un compte",
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _OasisIllustration extends StatelessWidget {
  const _OasisIllustration();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.52,
        child: CustomPaint(painter: _OasisPainter()),
      );
}

class _OasisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;

    // Lune
    final moonPaint = Paint()..color = AppColors.goldLight.withOpacity(0.9);
    canvas.drawCircle(Offset(cx, size.height * 0.22), 42, moonPaint);
    // Morsure de la lune
    canvas.drawCircle(Offset(cx + 28, size.height * 0.18), 36,
        Paint()..color = AppColors.bgPrimary..blendMode = BlendMode.srcOver);

    // Reflet de la lune dans l'eau
    final reflectPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.gold.withOpacity(0.4), Colors.transparent],
      ).createShader(Rect.fromLTWH(cx - 4, size.height * 0.7, 8, 60));
    canvas.drawRect(Rect.fromLTWH(cx - 4, size.height * 0.68, 8, 60), reflectPaint);

    // Horizon eau
    final waterPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.teal.withOpacity(0.3), AppColors.bgPrimary.withOpacity(0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38));
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38), waterPaint);

    // Silhouette mosquée
    _drawMosque(canvas, size, cx);

    // Palmiers
    _drawPalm(canvas, cx - 80, size.height * 0.63, 0.8);
    _drawPalm(canvas, cx + 90, size.height * 0.60, 1.0);
  }

  void _drawMosque(Canvas canvas, Size size, double cx) {
    final p = Paint()..color = const Color(0xFF1A2340);
    // Corps
    canvas.drawRect(Rect.fromLTWH(cx - 40, size.height * 0.52, 80, size.height * 0.12), p);
    // Dôme
    final domePath = Path()
      ..addArc(Rect.fromCenter(center: Offset(cx, size.height * 0.52), width: 60, height: 50), 3.14, 3.14);
    canvas.drawPath(domePath, p);
    // Minaret
    canvas.drawRect(Rect.fromLTWH(cx + 38, size.height * 0.44, 10, size.height * 0.20), p);
    // Croissant sur minaret
    final moonPaint = Paint()..color = AppColors.gold.withOpacity(0.8);
    canvas.drawCircle(Offset(cx + 43, size.height * 0.43), 5, moonPaint);
    canvas.drawCircle(Offset(cx + 46, size.height * 0.41), 4,
        Paint()..color = const Color(0xFF1A2340));
  }

  void _drawPalm(Canvas canvas, double x, double y, double scale) {
    final trunkPaint = Paint()..color = const Color(0xFF5C3D1E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y + 15 * scale), width: 6 * scale, height: 40 * scale), const Radius.circular(3)),
      trunkPaint,
    );
    final leafPaint = Paint()..color = AppColors.faithGreen.withOpacity(0.7);
    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 3.14 * 2 - 1.2;
      canvas.drawLine(
        Offset(x, y - 10 * scale),
        Offset(x + import_cos(angle) * 22 * scale, y - 10 * scale + import_sin(angle) * 12 * scale),
        leafPaint..strokeWidth = 3 * scale,
      );
    }
  }

  double import_cos(double a) {
    return _cos(a);
  }
  double import_sin(double a) {
    return _sin(a);
  }
  double _cos(double a) => a < 0 ? -_cos(-a) : (a > 3.14159 ? -_cos(a - 3.14159) : 1 - a * a / 2 + a * a * a * a / 24);
  double _sin(double a) => _cos(a - 1.5708);

  @override
  bool shouldRepaint(_) => false;
}

class _StarsPainter extends CustomPainter {
  final double t;
  _StarsPainter(this.t);

  static final List<_Star> _stars = List.generate(60, (i) {
    final r = (i * 7919 % 100) / 100.0;
    final r2 = (i * 6271 % 100) / 100.0;
    final r3 = (i * 3571 % 100) / 100.0;
    return _Star(r, r2, r3 * 0.6 + 0.1, (i * 2017 % 4) / 4.0);
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in _stars) {
      final alpha = (0.3 + 0.7 * _pulse(t + s.phase)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height * 0.65),
        s.size,
        Paint()..color = AppColors.goldLight.withOpacity(alpha * 0.8),
      );
    }
  }

  double _pulse(double t) => (t % 1.0) < 0.5 ? (t % 1.0) * 2 : 2 - (t % 1.0) * 2;

  @override
  bool shouldRepaint(_StarsPainter old) => old.t != t;
}

class _Star {
  final double x, y, size, phase;
  const _Star(this.x, this.y, this.size, this.phase);
}
