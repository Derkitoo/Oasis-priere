import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/golden_button.dart';
import 'parent_setup_screen.dart';

class LevelAssessmentScreen extends StatefulWidget {
  final String nickname;
  final int baseSkin;
  final String outfitId;

  const LevelAssessmentScreen({
    super.key,
    required this.nickname,
    required this.baseSkin,
    required this.outfitId,
  });

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  int _questionIndex = 0;
  final List<int?> _answers = [null, null, null];

  // Q1: Postures reconnues (0–3 = 0, 4–5 = 1, 6–8 = 2)
  // Q2: Fatiha (0=non, 1=un peu, 2=oui)
  // Q3: Prière complète (0=jamais, 1=parfois, 2=souvent)
  int get _computedGrade {
    final a0 = _answers[0] ?? 0;
    final a1 = _answers[1] ?? 0;
    final a2 = _answers[2] ?? 0;
    final total = a0 + a1 + a2;
    if (total >= 5) return 3;
    if (total >= 2) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _OnboardingHeader(step: 3),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position: Tween(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(_questionIndex),
                    child: _questionIndex < 3 ? _buildQuestion(_questionIndex) : _buildResult(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildQuestion(int index) {
    final question = _questions[index]['question'] as String;
    return Column(
      children: [
        Text(
          'Question ${index + 1} / 3',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.gold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withOpacity(0.25)),
          ),
          child: Text(
            question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        ..._questions[index]['options'].asMap().entries.map((entry) => _OptionCard(
              label: entry.value['label'] as String,
              emoji: entry.value['emoji'] as String,
              selected: _answers[index] == entry.key,
              onTap: () {
                setState(() {
                  _answers[index] = entry.key;
                });
                Future.delayed(const Duration(milliseconds: 350), () {
                  if (mounted) setState(() => _questionIndex++);
                });
              },
            )),
      ],
    );
  }

  Widget _buildResult() {
    final grade = _computedGrade;
    final msgs = {
      1: ('🛡️', 'Tu es un Gardien des Postures !', 'Parfait pour commencer — on va apprendre ensemble chaque mouvement.'),
      2: ('📖', 'Tu es déjà un Récitateur !', 'Tu connais quelques bases. On va les consolider et aller plus loin.'),
      3: ('⭐', 'Impressionnant ! Tu es un Guide.', 'Tu maîtrises bien la prière. Prêt à l\'approfondir spirituellement ?'),
    };
    final (icon, title, sub) = msgs[grade]!;

    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(sub, style: const TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.6), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withOpacity(0.3)),
          ),
          child: Text('Grade $grade débloqué', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold)),
        ),
        const SizedBox(height: 40),
        GoldenButton(
          label: 'Continuer →',
          width: double.infinity,
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ParentSetupScreen(
                nickname: widget.nickname,
                baseSkin: widget.baseSkin,
                outfitId: widget.outfitId,
                initialGrade: grade,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Est-ce que tu connais les positions de la prière ?',
      'options': [
        {'emoji': '🤷', 'label': 'Pas encore, je débute'},
        {'emoji': '🙏', 'label': 'Je connais 1 ou 2 positions'},
        {'emoji': '✅', 'label': 'Je connais la plupart des positions'},
      ],
    },
    {
      'question': 'Est-ce que tu sais réciter Al-Fatiha ?',
      'options': [
        {'emoji': '❌', 'label': 'Non, pas encore'},
        {'emoji': '🔄', 'label': 'Un peu, pas tout par cœur'},
        {'emoji': '⭐', 'label': 'Oui, je la connais bien'},
      ],
    },
    {
      'question': 'Est-ce que tu as déjà fait une prière complète ?',
      'options': [
        {'emoji': '🌱', 'label': 'Non, jamais encore'},
        {'emoji': '📿', 'label': 'Quelques fois avec quelqu\'un'},
        {'emoji': '🕌', 'label': 'Oui, je prie régulièrement'},
      ],
    },
  ];
}

class _OptionCard extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({required this.label, required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.gold.withOpacity(0.12) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AppColors.gold : AppColors.textMuted.withOpacity(0.2), width: selected ? 2 : 1),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textPrimary))),
              if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.gold),
            ],
          ),
        ),
      );
}

class _OnboardingHeader extends StatelessWidget {
  final int step;
  const _OnboardingHeader({required this.step});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: step / 6,
            backgroundColor: AppColors.bgCard3,
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            minHeight: 4,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Text('Étape $step sur 6', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      );
}
