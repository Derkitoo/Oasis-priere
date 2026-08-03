import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../shared/widgets/golden_button.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> with SingleTickerProviderStateMixin {
  int _page = 0;
  late AnimationController _celebCtrl;

  static const List<_TutorialPage> _pages = [
    _TutorialPage(
      emoji: '🔥',
      title: 'Ton feu de camp',
      body: 'Chaque prière alimentes ton feu. Plus tu pries régulièrement, plus il brûle fort. À 30 jours consécutifs, il devient magique et doré !',
      action: 'Je veux voir !',
    ),
    _TutorialPage(
      emoji: '🛡️',
      title: 'Ta première posture',
      body: 'Essaie : glisse le personnage en position de Sujud. C\'est plus facile qu\'il n\'y paraît !',
      action: 'C\'est bon !',
      isInteractive: true,
    ),
    _TutorialPage(
      emoji: '📿',
      title: 'Le Tasbih',
      body: 'Après chaque prière, tu tournes les perles. 33 taps pour chaque formule. Tap 3 fois maintenant pour essayer !',
      action: 'Trop bien !',
      isInteractive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _celebCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _celebCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final userProv = context.read<UserProvider>();
    if (userProv.user != null) {
      await context.read<ProgressProvider>().loadProgress(userProv.user!.id);
    }
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: LinearProgressIndicator(value: (_page + 1) / _pages.length, backgroundColor: AppColors.bgCard3, valueColor: const AlwaysStoppedAnimation(AppColors.gold), minHeight: 4, borderRadius: BorderRadius.circular(4)),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: KeyedSubtree(
                    key: ValueKey(_page),
                    child: _buildPage(_pages[_page]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    GoldenButton(
                      label: _page < _pages.length - 1 ? _pages[_page].action : 'Démarrer l\'aventure ! ✨',
                      width: double.infinity,
                      onTap: () {
                        if (_page < _pages.length - 1) {
                          setState(() => _page++);
                        } else {
                          _finish();
                        }
                      },
                    ),
                    if (_page == 0) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _finish,
                        child: const Text('Passer le tutoriel', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPage(_TutorialPage page) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(page.emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 24),
            Text(page.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 14),
            Text(page.body, style: const TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.7), textAlign: TextAlign.center),
            if (page.isInteractive) ...[
              const SizedBox(height: 32),
              _buildInteractive(page),
            ],
          ],
        ),
      );

  Widget _buildInteractive(_TutorialPage page) {
    if (_page == 1) return _PostureDemo();
    if (_page == 2) return _TasbihDemo();
    return const SizedBox();
  }
}

class _PostureDemo extends StatefulWidget {
  @override
  State<_PostureDemo> createState() => _PostureDemoState();
}

class _PostureDemoState extends State<_PostureDemo> {
  bool _done = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => setState(() => _done = true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 100, height: 100,
          decoration: BoxDecoration(
            color: _done ? AppColors.gold.withOpacity(0.15) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _done ? AppColors.gold : AppColors.textMuted.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(_done ? '✅' : '🙇', style: const TextStyle(fontSize: 48)),
          ),
        ),
      );
}

class _TasbihDemo extends StatefulWidget {
  @override
  State<_TasbihDemo> createState() => _TasbihDemoState();
}

class _TasbihDemoState extends State<_TasbihDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _count = (_count + 1).clamp(0, 3)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.gold.withOpacity(0.5 + _count * 0.15), width: 2),
                boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.1 * _count), blurRadius: 20)],
              ),
              child: Center(child: Text('📿', style: TextStyle(fontSize: 32 + _count * 4.0))),
            ),
          ),
          const SizedBox(height: 12),
          Text('$_count / 3', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gold)),
        ],
      );
}

class _TutorialPage {
  final String emoji;
  final String title;
  final String body;
  final String action;
  final bool isInteractive;

  const _TutorialPage({
    required this.emoji,
    required this.title,
    required this.body,
    required this.action,
    this.isInteractive = false,
  });
}
