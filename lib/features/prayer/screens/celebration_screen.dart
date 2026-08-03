import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/golden_button.dart';

class CelebrationScreen extends StatefulWidget {
  final String prayerName;
  final String mode;
  final int rakatCount;
  final int durationSeconds;
  final bool qiblaAligned;
  final bool tasbihDone;

  const CelebrationScreen({
    super.key,
    required this.prayerName,
    required this.mode,
    required this.rakatCount,
    required this.durationSeconds,
    this.qiblaAligned = false,
    this.tasbihDone = false,
  });

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> with TickerProviderStateMixin {
  late AnimationController _particlesCtrl;
  late AnimationController _contentCtrl;
  late Animation<double> _contentAnim;
  PrayerCompletionResult? _result;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _particlesCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _contentAnim = CurvedAnimation(parent: _contentCtrl, curve: Curves.elasticOut);
    _completePrayer();
  }

  @override
  void dispose() {
    _particlesCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _completePrayer() async {
    final userProv = context.read<UserProvider>();
    if (userProv.user == null) return;

    final result = await context.read<ProgressProvider>().completePrayer(
      userId: userProv.user!.id,
      prayerName: widget.prayerName,
      mode: widget.mode,
      rakatCount: widget.rakatCount,
      durationSeconds: widget.durationSeconds,
      qiblaAligned: widget.qiblaAligned,
      tasbihDone: widget.tasbihDone,
    );

    // Ajouter une feuille à l'arbre
    final avatar = userProv.avatar;
    if (avatar != null) {
      await userProv.updateAvatar(avatar.addLeaf());
    }

    if (mounted) {
      setState(() {
        _result = result;
        _loaded = true;
      });
      _contentCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Stack(
          children: [
            // Particules dorées
            AnimatedBuilder(
              animation: _particlesCtrl,
              builder: (_, __) => CustomPaint(
                painter: _ParticlesPainter(_particlesCtrl.value),
                size: MediaQuery.of(context).size,
              ),
            ),

            SafeArea(
              child: _loaded && _result != null
                  ? ScaleTransition(
                      scale: _contentAnim,
                      child: _buildContent(_result!),
                    )
                  : const Center(child: CircularProgressIndicator(color: AppColors.gold)),
            ),
          ],
        ),
      );

  Widget _buildContent(PrayerCompletionResult result) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // Icône principale
            const Text('🌟', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),

            // Message principal
            Text(
              _getMessage(widget.prayerName),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.prayerName + (widget.tasbihDone ? ' + Dhikr accomplis !' : ' accomplie !'),
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
            ),

            const SizedBox(height: 32),

            // XP Card
            _XpCard(result: result),

            const SizedBox(height: 20),

            // Streak
            if (result.newStreak > 0)
              _StreakCard(streak: result.newStreak, isRecord: result.newRecord, milestone: result.streakMilestone),

            // Level up
            if (result.leveledUp) ...[
              const SizedBox(height: 16),
              _LevelUpCard(newGrade: result.newGrade),
            ],

            const Spacer(),

            // Bouton retour
            GoldenButton(
              label: 'Retour à l\'Oasis',
              width: double.infinity,
              icon: Icons.home_rounded,
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
            ),
            const SizedBox(height: 12),
          ],
        ),
      );

  String _getMessage(String prayer) => switch (prayer) {
        'Fajr' => 'Belle journée en perspective !',
        'Dhuhr' => 'Une pause bénie au milieu du jour !',
        'Asr' => 'L\'après-midi s\'illumine !',
        'Maghreb' => 'Coucher de soleil spirituel ! ✨',
        'Isha' => 'Bonne nuit dans la paix d\'Allah !',
        _ => 'Prière accomplie ! 🌟',
      };
}

class _XpCard extends StatefulWidget {
  final PrayerCompletionResult result;
  const _XpCard({required this.result});

  @override
  State<_XpCard> createState() => _XpCardState();
}

class _XpCardState extends State<_XpCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<int> _xpAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _xpAnim = IntTween(begin: 0, end: widget.result.xpGained).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _xpAnim,
        builder: (_, __) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(icon: '⚡', value: '+${_xpAnim.value}', label: 'XP gagnés'),
              Container(width: 1, height: 40, color: AppColors.textMuted.withValues(alpha: 0.2)),
              _StatItem(icon: '🔥', value: '${widget.result.newStreak}j', label: 'Série actuelle'),
              Container(width: 1, height: 40, color: AppColors.textMuted.withValues(alpha: 0.2)),
              _StatItem(
                icon: AppConstants.gradeIcons[widget.result.newGrade] ?? '🛡️',
                value: 'Grade ${widget.result.newGrade}',
                label: 'Ton niveau',
              ),
            ],
          ),
        ),
      );
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.gold)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      );
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final bool isRecord;
  final int? milestone;

  const _StreakCard({required this.streak, required this.isRecord, this.milestone});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isRecord ? AppColors.gold.withValues(alpha: 0.4) : AppColors.textMuted.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Text(milestone != null ? '🎊' : '🔥', style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone != null ? 'Série de $milestone jours ! Incroyable !' : '$streak jours consécutifs !',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isRecord ? AppColors.gold : AppColors.textPrimary),
                  ),
                  if (isRecord) const Text('Nouveau record personnel 🏆', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _LevelUpCard extends StatelessWidget {
  final int newGrade;
  const _LevelUpCard({required this.newGrade});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gold.withValues(alpha: 0.12), AppColors.purple.withValues(alpha: 0.08)]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Text(AppConstants.gradeIcons[newGrade] ?? '⭐', style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NIVEAU SUPÉRIEUR !', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1, color: AppColors.gold)),
                  const SizedBox(height: 3),
                  Text('Grade $newGrade : ${AppConstants.gradeNames[newGrade]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ParticlesPainter extends CustomPainter {
  final double t;
  _ParticlesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.Random(42);
    for (int i = 0; i < 30; i++) {
      final startX = r.nextDouble() * size.width;
      final speed = 0.3 + r.nextDouble() * 0.7;
      final progress = ((t * speed + r.nextDouble()) % 1.0);
      if (progress > t) continue;
      final x = startX + (r.nextDouble() - 0.5) * 60 * progress;
      final y = size.height - progress * size.height * 1.2;
      final alpha = (1.0 - progress) * 0.8;
      canvas.drawCircle(
        Offset(x, y),
        2 + r.nextDouble() * 4,
        Paint()..color = (i % 3 == 0 ? AppColors.goldLight : i % 3 == 1 ? AppColors.tealLight : AppColors.purpleLight).withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => old.t != t;
}
