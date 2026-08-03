import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/providers/prayer_provider.dart';
import '../../../core/services/streak_service.dart';
import '../widgets/moon_widget.dart';
import '../widgets/faith_tree_widget.dart';
import '../widgets/prayer_tracker_widget.dart';
import '../../prayer/screens/preparation_screen.dart';
import '../../learning/screens/learning_hub_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../shared/widgets/xp_bar_widget.dart';
import '../../../shared/widgets/grade_badge_widget.dart';
import '../../../shared/widgets/avatar_builder_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  Future<void> _reload() async {
    final userProv = context.read<UserProvider>();
    if (userProv.user == null) return;
    await context.read<ProgressProvider>().loadProgress(userProv.user!.id);
    await context.read<PrayerProvider>().loadTimes(userProv.user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: IndexedStack(
        index: _bottomIndex,
        children: const [
          _HomeTab(),
          LearningHubScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _bottomIndex,
        onTap: (i) => setState(() => _bottomIndex = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static const List<Color> skinTones = [
    Color(0xFFF5D5B8), Color(0xFFE8B88A), Color(0xFFD4956A),
    Color(0xFFBF7A50), Color(0xFF9A5B3A), Color(0xFF6E3920),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final avatar = context.watch<UserProvider>().avatar;
    final progress = context.watch<ProgressProvider>().progress;
    final prayerProv = context.watch<PrayerProvider>();
    final progressProv = context.watch<ProgressProvider>();

    if (user == null || progress == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.gold));
    }

    final streakSvc = StreakService();
    final intensity = streakSvc.campfireIntensity(progress.currentStreak);
    final isGolden = progress.currentStreak >= 30;

    final skinIndex = ((avatar?.baseSkin ?? 1) - 1).clamp(0, skinTones.length - 1);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header avec Avatar Modulaire 2D
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  AvatarBuilderWidget(
                    skinColor: skinTones[skinIndex],
                    outfitColor: const Color(0xFF2A9D8F),
                    headwearId: avatar?.headwearId ?? 'chechia_white',
                    expression: avatar?.expression ?? 'happy',
                    accessoryId: avatar?.accessoryId ?? 'none',
                    size: 52,
                  ),
                  const SizedBox(width: 12),
                  GradeBadgeWidget(grade: progress.currentGrade),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salam, ${user.nickname} !',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        XpBarWidget(
                          currentXp: progress.gradeXpProgress,
                          maxXp: progress.gradeXpRequired,
                          grade: progress.currentGrade,
                        ),
                      ],
                    ),
                  ),
                  // Streak badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard3,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: progress.currentStreak > 0 ? AppColors.gold.withValues(alpha: 0.5) : AppColors.textMuted.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(isGolden ? '🔥' : '🕯️', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text(
                          '${progress.currentStreak}j',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: progress.currentStreak > 0 ? AppColors.gold : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Croissant de lune + arbre de foi
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Arbre de la Foi
                      Column(
                        children: [
                          FaithTreeWidget(
                            stage: avatar?.treeStage ?? 0,
                            leavesCount: avatar?.treeLeavesCount ?? 0,
                          ),
                          const SizedBox(height: 4),
                          const Text('Arbre de la Foi', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                          Text('${avatar?.treeLeavesCount ?? 0} feuilles', style: const TextStyle(fontSize: 9, color: AppColors.faithGreen)),
                        ],
                      ),
                      // Croissant de lune
                      Column(
                        children: [
                          MoonWidget(intensity: intensity, isGolden: isGolden),
                          const SizedBox(height: 4),
                          const Text('Ta lumière', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                          Text(
                            progress.currentStreak == 0 ? 'Commence !' : '${progress.currentStreak} jours consécutifs',
                            style: TextStyle(fontSize: 9, color: progress.currentStreak > 0 ? AppColors.gold : AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tracker des 5 prières
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Prières du jour', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.8)),
                  const SizedBox(height: 12),
                  PrayerTrackerWidget(
                    doneToday: progressProv.todayPrayersDone,
                    prayerTimes: prayerProv.formattedTimes,
                    currentPrayer: prayerProv.currentPrayerName,
                    onPrayerTap: (name) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PreparationScreen(prayerName: name)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CTA principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _NextPrayerCard(prayerProv: prayerProv),
                ],
              ),
            ),
          ),

          // Quête du jour
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: _DailyQuestCard(grade: progress.currentGrade),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextPrayerCard extends StatelessWidget {
  final PrayerProvider prayerProv;
  const _NextPrayerCard({required this.prayerProv});

  @override
  Widget build(BuildContext context) {
    final name = prayerProv.currentPrayerName;
    final time = name != null ? prayerProv.formattedTimes[name] : null;

    return GestureDetector(
      onTap: name == null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PreparationScreen(prayerName: name)),
              ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gold.withValues(alpha: 0.15), AppColors.teal.withValues(alpha: 0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Text('🕌', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name != null ? 'Prochaine : $name' : 'Toutes les prières faites ! 🌟',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  if (time != null)
                    Text('à $time', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ),
            if (name != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(10)),
                child: const Text('Prier', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.bgPrimary)),
              ),
          ],
        ),
      ),
    );
  }
}

class _DailyQuestCard extends StatelessWidget {
  final int grade;
  const _DailyQuestCard({required this.grade});

  @override
  Widget build(BuildContext context) {
    final quest = _getQuest(grade);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningHubScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Text(quest['icon']!, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUÊTE DU JOUR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.purpleLight)),
                  const SizedBox(height: 3),
                  Text(quest['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(quest['xp']!, style: const TextStyle(fontSize: 11, color: AppColors.gold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getQuest(int grade) => switch (grade) {
        1 => {'icon': '🛡️', 'title': 'Maîtrise le Sujud parfait', 'xp': '+30 XP'},
        2 => {'icon': '📖', 'title': 'Récite Al-Ikhlas 3 fois', 'xp': '+40 XP'},
        3 => {'icon': '⭐', 'title': "Accomplis une prière de 4 Raka'at", 'xp': '+80 XP'},
        4 => {'icon': '🌌', 'title': 'Médite le sens du Sujud', 'xp': '+50 XP'},
        _ => {'icon': '🛡️', 'title': 'Commence ton apprentissage', 'xp': '+30 XP'},
      };
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border(top: BorderSide(color: AppColors.gold.withValues(alpha: 0.15))),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textMuted,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Oasis'),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Apprendre'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Moi'),
          ],
        ),
      );
}
