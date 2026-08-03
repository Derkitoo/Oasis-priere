import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/constants/app_constants.dart';
import 'posture_studio_screen.dart';
import 'karaoke_screen.dart';
import 'fusion_mode_screen.dart';

class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>().progress;
    final grade = progress?.currentGrade ?? 1;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Apprendre', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('Grade $grade — ${AppConstants.gradeNames[grade]}', style: const TextStyle(fontSize: 12, color: AppColors.gold)),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Grade 1 — Postures
                  _ModuleCard(
                    icon: '🛡️',
                    grade: 1,
                    currentGrade: grade,
                    title: 'Studio des Postures',
                    subtitle: 'Apprends les 8 positions de la prière',
                    color: AppColors.teal,
                    modules: [
                      _SubModule(id: 'posture_takbir', label: 'Le Takbir', done: progress?.posturesMastered.contains('takbir') ?? false),
                      _SubModule(id: 'posture_qiyam', label: 'Le Qiyam', done: progress?.posturesMastered.contains('qiyam') ?? false),
                      _SubModule(id: 'posture_ruku', label: 'Le Ruku', done: progress?.posturesMastered.contains('ruku') ?? false),
                      _SubModule(id: 'posture_sujud', label: 'Le Sujud', done: progress?.posturesMastered.contains('sujud') ?? false),
                    ],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostureStudioScreen())),
                  ),
                  const SizedBox(height: 14),

                  // Grade 2 — Récitation
                  _ModuleCard(
                    icon: '📖',
                    grade: 2,
                    currentGrade: grade,
                    title: 'Karaoké Triple Ligne',
                    subtitle: 'Al-Fatiha, Al-Ikhlas, Al-Kawthar, An-Nas',
                    color: AppColors.gold,
                    modules: [
                      _SubModule(id: 'sura_fatiha', label: 'Al-Fatiha', done: progress?.surasMemorized.contains('fatiha') ?? false),
                      _SubModule(id: 'sura_ikhlas', label: 'Al-Ikhlas', done: progress?.surasMemorized.contains('ikhlas') ?? false),
                      _SubModule(id: 'sura_kawthar', label: 'Al-Kawthar', done: progress?.surasMemorized.contains('kawthar') ?? false),
                      _SubModule(id: 'sura_nas', label: 'An-Nas', done: progress?.surasMemorized.contains('nas') ?? false),
                    ],
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KaraokeScreen())),
                  ),
                  const SizedBox(height: 14),

                  // Grade 3 — Fusion
                  _ModuleCard(
                    icon: '⭐',
                    grade: 3,
                    currentGrade: grade,
                    title: 'Mode Fusion',
                    subtitle: 'Associe posture et formule au bon moment',
                    color: AppColors.purple,
                    modules: [
                      _SubModule(id: 'fusion_2r', label: 'Prière 2 Raka\'at', done: progress?.modulesCompleted.contains('fusion_2r') ?? false),
                      _SubModule(id: 'fusion_3r', label: 'Prière 3 Raka\'at', done: progress?.modulesCompleted.contains('fusion_3r') ?? false),
                      _SubModule(id: 'fusion_4r', label: 'Prière 4 Raka\'at', done: progress?.modulesCompleted.contains('fusion_4r') ?? false),
                    ],
                    onTap: grade >= 2
                        ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FusionModeScreen()))
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Grade 4 — Sens
                  _ModuleCard(
                    icon: '🌌',
                    grade: 4,
                    currentGrade: grade,
                    title: 'L\'Explorateur du Sens',
                    subtitle: 'Comprends la spiritualité de chaque étape',
                    color: AppColors.rose,
                    modules: [
                      _SubModule(id: 'meaning_sujud', label: 'Le sens du Sujud', done: false),
                      _SubModule(id: 'meaning_fatiha', label: 'La Fatiha en profondeur', done: false),
                    ],
                    onTap: grade >= 4 ? () {} : null,
                  ),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubModule {
  final String id;
  final String label;
  final bool done;
  const _SubModule({required this.id, required this.label, required this.done});
}

class _ModuleCard extends StatelessWidget {
  final String icon;
  final int grade;
  final int currentGrade;
  final String title;
  final String subtitle;
  final Color color;
  final List<_SubModule> modules;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.icon,
    required this.grade,
    required this.currentGrade,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.modules,
    this.onTap,
  });

  bool get _locked => currentGrade < grade;

  @override
  Widget build(BuildContext context) {
    final doneCount = modules.where((m) => m.done).length;

    return GestureDetector(
      onTap: _locked ? null : onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _locked ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _locked ? AppColors.textMuted.withOpacity(0.1) : color.withOpacity(0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.07),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              if (_locked) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.lock_rounded, size: 14, color: AppColors.textMuted),
                              ],
                            ],
                          ),
                          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    // Progress bubble
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Text('$doneCount/${modules.length}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                    ),
                  ],
                ),
              ),

              // Sous-modules
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 8, runSpacing: 8,
                  children: modules.map((m) => _SubModuleChip(sub: m, color: color)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubModuleChip extends StatelessWidget {
  final _SubModule sub;
  final Color color;

  const _SubModuleChip({required this.sub, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: sub.done ? color.withOpacity(0.1) : AppColors.bgCard3,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: sub.done ? color.withOpacity(0.3) : AppColors.textMuted.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sub.done) Icon(Icons.check_rounded, size: 12, color: color),
            if (sub.done) const SizedBox(width: 4),
            Text(sub.label, style: TextStyle(fontSize: 11, color: sub.done ? color : AppColors.textMuted, fontWeight: sub.done ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      );
}
