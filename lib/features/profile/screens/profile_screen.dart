import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../shared/widgets/grade_badge_widget.dart';
import '../../../shared/widgets/xp_bar_widget.dart';
import '../../../shared/widgets/avatar_builder_widget.dart';
import '../../dashboard/widgets/faith_tree_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<Color> skinTones = [
    Color(0xFFF5D5B8), Color(0xFFE8B88A), Color(0xFFD4956A),
    Color(0xFFBF7A50), Color(0xFF9A5B3A), Color(0xFF6E3920),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final avatar = context.watch<UserProvider>().avatar;
    final progress = context.watch<ProgressProvider>().progress;

    if (user == null || progress == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    }

    final skinIndex = ((avatar?.baseSkin ?? 1) - 1).clamp(0, skinTones.length - 1);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    // Avatar Modulaire + Arbre côte à côte
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Avatar Modulaire 2D
                        Column(
                          children: [
                            AvatarBuilderWidget(
                              skinColor: skinTones[skinIndex],
                              outfitColor: const Color(0xFF2A9D8F),
                              headwearId: avatar?.headwearId ?? 'chechia_white',
                              expression: avatar?.expression ?? 'happy',
                              accessoryId: avatar?.accessoryId ?? 'none',
                              size: 80,
                            ),
                            const SizedBox(height: 8),
                            Text(user.nickname, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            Text(user.prayerCity, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                        // Arbre de la Foi
                        Column(
                          children: [
                            FaithTreeWidget(stage: avatar?.treeStage ?? 0, leavesCount: avatar?.treeLeavesCount ?? 0),
                            const SizedBox(height: 4),
                            Text('${avatar?.treeLeavesCount ?? 0} feuilles', style: const TextStyle(fontSize: 10, color: AppColors.faithGreen)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Grade + XP
                    GradeBadgeWidget(grade: progress.currentGrade, large: true),
                    const SizedBox(height: 16),
                    XpBarWidget(
                      currentXp: progress.gradeXpProgress,
                      maxXp: progress.gradeXpRequired,
                      grade: progress.currentGrade,
                    ),
                    const SizedBox(height: 4),
                    Text('${progress.totalXp} XP total', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),

            // Statistiques
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Statistiques'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _StatCard(icon: '🔥', value: '${progress.currentStreak}', label: 'Série actuelle')),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(icon: '🏆', value: '${progress.longestStreak}', label: 'Record série')),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(icon: '📿', value: '${progress.surasMemorized.length}', label: 'Sourates')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _StatCard(icon: '🛡️', value: '${progress.posturesMastered.length}/8', label: 'Postures')),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(icon: '⭐', value: '${progress.modulesCompleted.length}', label: 'Modules')),
                        const SizedBox(width: 10),
                        Expanded(child: _StatCard(icon: '⚡', value: '${progress.totalXp}', label: 'XP total')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Succès / Badges
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Succès'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: _buildAchievements(progress.achievements.map((a) => a.id).toSet()),
                    ),
                  ],
                ),
              ),
            ),

            // Paramètres rapides
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Paramètres'),
                    const SizedBox(height: 12),
                    _SettingRow(icon: Icons.location_city_rounded, label: 'Ville : ${user.prayerCity}', onTap: () {}),
                    _SettingRow(icon: Icons.calculate_rounded, label: 'Méthode : ${user.calculationMethod}', onTap: () {}),
                    _SettingRow(icon: Icons.lock_rounded, label: 'Code parental', onTap: () {}),
                    _SettingRow(icon: Icons.info_outline_rounded, label: 'À propos', onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAchievements(Set<String> earned) {
    const all = [
      _Achievement(id: 'first_prayer', icon: '🌙', label: 'Première prière'),
      _Achievement(id: 'streak_3', icon: '🔥', label: '3 jours de suite'),
      _Achievement(id: 'streak_7', icon: '⭐', label: '7 jours de suite'),
      _Achievement(id: 'streak_30', icon: '👑', label: '30 jours de suite'),
      _Achievement(id: 'fatiha', icon: '📖', label: 'Al-Fatiha mémorisée'),
      _Achievement(id: 'sujud', icon: '🙇', label: 'Sujud maîtrisé'),
      _Achievement(id: 'first_100xp', icon: '⚡', label: '100 XP'),
      _Achievement(id: 'xp_1000', icon: '💎', label: '1000 XP'),
    ];
    return all.map((a) => _AchievementChip(achievement: a, earned: earned.contains(a.id))).toList();
  }
}

class _Achievement {
  final String id, icon, label;
  const _Achievement({required this.id, required this.icon, required this.label});
}

class _AchievementChip extends StatelessWidget {
  final _Achievement achievement;
  final bool earned;

  const _AchievementChip({required this.achievement, required this.earned});

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: earned ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: earned ? AppColors.gold.withValues(alpha: 0.1) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: earned ? AppColors.gold.withValues(alpha: 0.3) : AppColors.textMuted.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(achievement.icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(achievement.label, style: TextStyle(fontSize: 11, color: earned ? AppColors.gold : AppColors.textMuted, fontWeight: earned ? FontWeight.w600 : FontWeight.normal)),
            ],
          ),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.8));
}

class _StatCard extends StatelessWidget {
  final String icon, value, label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.1))),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
              const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
            ],
          ),
        ),
      );
}
