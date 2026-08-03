import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/haptic_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/data/postures_data.dart';
import '../../../core/services/audio_service.dart';
import '../../../shared/painters/posture_silhouette_painter.dart';
import '../data/prayer_steps_data.dart';
import 'tasbih_screen.dart';

class GuidedPrayerScreen extends StatefulWidget {
  final String prayerName;
  final bool qiblaAligned;

  const GuidedPrayerScreen({super.key, required this.prayerName, this.qiblaAligned = false});

  @override
  State<GuidedPrayerScreen> createState() => _GuidedPrayerScreenState();
}

class _GuidedPrayerScreenState extends State<GuidedPrayerScreen> with TickerProviderStateMixin {
  late List<PrayerStep> _steps;
  int _currentIndex = 0;
  late int _rakatCount;
  bool _prayerComplete = false;
  final DateTime _startTime = DateTime.now();
  final AudioService _audio = AudioService();
  late AnimationController _pulseCtrl;
  late AnimationController _transCtrl;
  Timer? _autoAdvance;

  @override
  void initState() {
    super.initState();
    _rakatCount = AppConstants.prayerRakatCount[widget.prayerName] ?? 2;
    _steps = PrayerStepsData.buildPrayer(_rakatCount);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _transCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _transCtrl.forward();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _playCurrentStep();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _transCtrl.dispose();
    _autoAdvance?.cancel();
    _audio.stop();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  PrayerStep get _currentStep => _steps[_currentIndex];
  PostureData? get _currentPosture => PosturesData.getById(_currentStep.postureId);
  PrayerFormula? get _currentFormula => _currentStep.formulaId.isNotEmpty
      ? PosturesData.getFormula(_currentStep.postureId)
      : null;

  int get _currentRakat => PrayerStepsData.rakatOf(_currentIndex, _steps);

  int get _stepInRakat {
    int lastStart = 0;
    for (int i = 0; i <= _currentIndex && i < _steps.length; i++) {
      if (_steps[i].isRakatStart) lastStart = i;
    }
    return _currentIndex - lastStart;
  }

  int get _stepsInCurrentRakat {
    int lastStart = 0;
    for (int i = 0; i <= _currentIndex && i < _steps.length; i++) {
      if (_steps[i].isRakatStart) lastStart = i;
    }
    for (int i = lastStart + 1; i < _steps.length; i++) {
      if (_steps[i].isRakatStart) return i - lastStart;
    }
    return _steps.length - lastStart;
  }

  // Volume vocal décroissant selon le raka'at (autonomie progressive)
  double get _voiceVolume => _audio.voiceVolumeForRakat(_currentRakat, _rakatCount);

  void _playCurrentStep() {
    _audio.setVoiceVolume(_voiceVolume);
    _audio.playChime();
    vibrate(duration: 60, amplitude: 40);
  }

  void _advance() {
    if (_currentIndex >= _steps.length - 1) {
      setState(() => _prayerComplete = true);
      return;
    }
    _transCtrl.reverse().then((_) {
      setState(() => _currentIndex++);
      _transCtrl.forward();
      _playCurrentStep();
    });
  }

  void _previous() {
    if (_currentIndex <= 0) return;
    _transCtrl.reverse().then((_) {
      setState(() => _currentIndex--);
      _transCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_prayerComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TasbihScreen(
              prayerName: widget.prayerName,
              mode: 'guided',
              rakatCount: _rakatCount,
              durationSeconds: DateTime.now().difference(_startTime).inSeconds,
              qiblaAligned: widget.qiblaAligned,
            ),
          ),
        );
      });
    }

    final posture = _currentPosture;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _advance,
        onHorizontalDragEnd: (d) {
          if (d.primaryVelocity != null && d.primaryVelocity! < -300) _advance();
          if (d.primaryVelocity != null && d.primaryVelocity! > 300) _previous();
        },
        child: Stack(
          children: [
            // Fond étoilé minimaliste
            CustomPaint(painter: _NightPainter(), size: MediaQuery.of(context).size),

            // Contenu principal
            SafeArea(
              child: FadeTransition(
                opacity: _transCtrl,
                child: Column(
                  children: [
                    // Header discret
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        children: [
                          // Rakat dots
                          Row(
                            children: List.generate(_rakatCount, (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 6),
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i <= _currentRakat ? AppColors.gold : AppColors.textMuted.withOpacity(0.3),
                              ),
                            )),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => _QuitDialog(onConfirm: () => Navigator.pop(context)),
                            ),
                            child: const Icon(Icons.close_rounded, color: Color(0x55FFFFFF), size: 20),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Silhouette posture (grande, centrée)
                    AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => Transform.scale(
                        scale: 1.0 + _pulseCtrl.value * 0.03,
                        child: _PostureSilhouette(postureId: _currentStep.postureId),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Instruction
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          if (posture != null)
                            Text(
                              posture.nameAr,
                              style: const TextStyle(fontSize: 22, fontFamily: 'Amiri', color: AppColors.goldLight, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            _currentStep.instruction,
                            style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          // Formule (si volume suffisant)
                          if (_currentFormula != null && _voiceVolume > 0.4) ...[
                            const SizedBox(height: 16),
                            Text(
                              _currentFormula!.arabic,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Amiri',
                                color: AppColors.gold.withOpacity(0.7 * _voiceVolume),
                                height: 1.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_voiceVolume > 0.7)
                              Text(
                                _currentFormula!.phonetic,
                                style: TextStyle(fontSize: 11, color: AppColors.tealLight.withOpacity(_voiceVolume - 0.3), fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Navigation hints + progress
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Column(
                        children: [
                          // Dots de progression dans le raka'at courant
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _stepsInCurrentRakat,
                              (i) {
                                final done = i < _stepInRakat;
                                final active = i == _stepInRakat;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: active ? 16 : 4, height: 4,
                                  decoration: BoxDecoration(
                                    color: done
                                        ? AppColors.gold.withOpacity(0.5)
                                        : active
                                            ? AppColors.gold
                                            : Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Tape pour continuer  •  Raka'at ${_currentRakat + 1}/$_rakatCount",
                            style: const TextStyle(fontSize: 11, color: Color(0x55FFFFFF)),
                          ),
                          // Indicateur autonomie
                          if (_voiceVolume < 0.5) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Mode autonomie — tu gères ! 🌟',
                              style: TextStyle(fontSize: 10, color: AppColors.gold.withOpacity(0.5)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostureSilhouette extends StatelessWidget {
  final String postureId;
  const _PostureSilhouette({required this.postureId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: AppColors.gold.withOpacity(0.2), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomPaint(
          painter: PostureSilhouettePainter(postureId, color: AppColors.tealLight),
          size: const Size(116, 116),
        ),
      ),
    );
  }
}

class _NightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [const Color(0xFF060C1A), const Color(0xFF0A0F1E)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    // Étoiles
    final r = (size.width * size.height * 0.00006).round().clamp(20, 50);
    for (int i = 0; i < r; i++) {
      final x = (i * 1301 % size.width.toInt()).toDouble();
      final y = (i * 997 % (size.height * 0.6).toInt()).toDouble();
      canvas.drawCircle(Offset(x, y), (i % 3 == 0 ? 1.5 : 0.8), Paint()..color = Colors.white.withOpacity(0.3 + (i % 4) * 0.15));
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _QuitDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const _QuitDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Quitter la prière ?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Ta progression ne sera pas sauvegardée.', style: TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Continuer', style: TextStyle(color: AppColors.gold))),
          TextButton(onPressed: () { Navigator.pop(context); onConfirm(); }, child: const Text('Quitter', style: TextStyle(color: AppColors.roseLight))),
        ],
      );
}
