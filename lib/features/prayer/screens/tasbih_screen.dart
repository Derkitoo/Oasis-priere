import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/audio_service.dart';
import 'celebration_screen.dart';

class TasbihScreen extends StatefulWidget {
  final String prayerName;
  final String mode;
  final int rakatCount;
  final int durationSeconds;
  final bool qiblaAligned;

  const TasbihScreen({
    super.key,
    required this.prayerName,
    required this.mode,
    required this.rakatCount,
    required this.durationSeconds,
    this.qiblaAligned = false,
  });

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with TickerProviderStateMixin {
  int _count = 0;
  int _groupIndex = 0; // 0=SubhanAllah, 1=Alhamdulillah, 2=AllahuAkbar
  late AnimationController _beadCtrl;
  late AnimationController _ringCtrl;
  late Animation<double> _beadScale;
  final AudioService _audio = AudioService();

  static const List<_DhikrGroup> _groups = [
    _DhikrGroup(arabic: 'سُبْحَانَ اللَّهِ', phonetic: 'Subḥāna llāh', french: 'Gloire à Allah', color: AppColors.teal, count: 33),
    _DhikrGroup(arabic: 'الْحَمْدُ لِلَّهِ', phonetic: 'Al-ḥamdu lillāh', french: 'Louange à Allah', color: AppColors.gold, count: 33),
    _DhikrGroup(arabic: 'اللَّهُ أَكْبَرُ', phonetic: 'Allāhu Akbar', french: 'Allah est le Plus Grand', color: AppColors.purpleLight, count: 34),
  ];

  _DhikrGroup get _current => _groups[_groupIndex];
  bool get _allDone => _groupIndex >= _groups.length;
  int get _groupCount => _count;

  @override
  void initState() {
    super.initState();
    _beadCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _ringCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _beadScale = Tween(begin: 1.0, end: 1.18).animate(CurvedAnimation(parent: _beadCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _beadCtrl.dispose();
    _ringCtrl.dispose();
    super.dispose();
  }

  void _tap() {
    if (_allDone) return;
    _audio.playTasbihBead();
    _beadCtrl.forward(from: 0);
    vibrate(duration: 30, amplitude: 50 + _groupIndex * 20);

    setState(() {
      _count++;
      if (_count >= _current.count) {
        _count = 0;
        _groupIndex++;
        if (_groupIndex < _groups.length) {
          _audio.playSuccess();
          vibrate(duration: 150, amplitude: 128, pattern: [0, 150, 80, 150]);
        }
      }
    });

    if (_allDone) _onComplete();
  }

  void _onComplete() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CelebrationScreen(
              prayerName: widget.prayerName,
              mode: widget.mode,
              rakatCount: widget.rakatCount,
              durationSeconds: widget.durationSeconds,
              qiblaAligned: widget.qiblaAligned,
              tasbihDone: true,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const Text('📿', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    const Text('Dhikr post-prière', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CelebrationScreen(
                            prayerName: widget.prayerName,
                            mode: widget.mode,
                            rakatCount: widget.rakatCount,
                            durationSeconds: widget.durationSeconds,
                            qiblaAligned: widget.qiblaAligned,
                            tasbihDone: false,
                          ),
                        ),
                      ),
                      child: const Text('Passer', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ),
                  ],
                ),
              ),

              // Groupes indicateurs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: List.generate(_groups.length, (i) {
                    final done = i < _groupIndex;
                    final active = i == _groupIndex;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: done ? _groups[i].color : active ? _groups[i].color.withOpacity(0.5) : AppColors.bgCard3,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const Spacer(),

              // Texte du dhikr actuel
              if (!_allDone) ...[
                Text(
                  _current.arabic,
                  style: const TextStyle(fontSize: 32, fontFamily: 'Amiri', color: AppColors.goldLight, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(_current.phonetic, style: const TextStyle(fontSize: 15, color: AppColors.tealLight, fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text(_current.french, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ] else
                const Column(
                  children: [
                    Text('✨', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 12),
                    Text('Dhikr terminé !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.gold)),
                  ],
                ),

              const Spacer(),

              // Grand bouton Tasbih (perle)
              GestureDetector(
                onTap: _allDone ? null : _tap,
                child: AnimatedBuilder(
                  animation: _beadScale,
                  builder: (_, __) => Transform.scale(
                    scale: _beadScale.value,
                    child: _TasbihBead(
                      count: _groupCount,
                      max: _allDone ? 33 : _current.count,
                      color: _allDone ? AppColors.faithGreen : _current.color,
                      ringAnim: _ringCtrl.value,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Compteur
              if (!_allDone)
                Text(
                  '${_groupCount} / ${_current.count}',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _current.color),
                ),

              const Spacer(),

              // Bouton skip
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  _allDone ? '' : 'Tape la perle pour compter',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      );
}

class _TasbihBead extends StatelessWidget {
  final int count;
  final int max;
  final Color color;
  final double ringAnim;

  const _TasbihBead({required this.count, required this.max, required this.color, required this.ringAnim});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 180, height: 180,
        child: CustomPaint(painter: _BeadPainter(progress: count / max, color: color, ringT: ringAnim)),
      );
}

class _BeadPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double ringT;

  const _BeadPainter({required this.progress, required this.color, required this.ringT});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.width / 2 - 10;

    // Anneau de progression
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = AppColors.bgCard3..style = PaintingStyle.stroke..strokeWidth = 8);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round,
    );

    // Anneau animé (halo pulsant)
    if (progress > 0) {
      canvas.drawCircle(
        Offset(cx, cy), r + 4,
        Paint()..color = color.withOpacity(0.15 + ringT * 0.1)..style = PaintingStyle.stroke..strokeWidth = 12,
      );
    }

    // Perle centrale
    final gradient = RadialGradient(colors: [color.withOpacity(0.9), color.withOpacity(0.4)]);
    canvas.drawCircle(Offset(cx, cy), r * 0.52, Paint()..shader = gradient.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.52)));

    // Brillance
    canvas.drawCircle(Offset(cx - r * 0.15, cy - r * 0.15), r * 0.12, Paint()..color = Colors.white.withOpacity(0.35));

    // Petites perles autour
    final beadCount = (progress * 12).floor().clamp(0, 12);
    for (int i = 0; i < beadCount; i++) {
      final angle = i * (2 * math.pi / 12) - math.pi / 2;
      canvas.drawCircle(
        Offset(cx + (r + 14) * math.cos(angle), cy + (r + 14) * math.sin(angle)),
        4,
        Paint()..color = color.withOpacity(0.6),
      );
    }
  }

  @override
  bool shouldRepaint(_BeadPainter old) => old.progress != progress || old.ringT != ringT;
}

class _DhikrGroup {
  final String arabic;
  final String phonetic;
  final String french;
  final Color color;
  final int count;

  const _DhikrGroup({required this.arabic, required this.phonetic, required this.french, required this.color, required this.count});
}
