import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/postures_data.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../shared/widgets/golden_button.dart';

class FusionModeScreen extends StatefulWidget {
  const FusionModeScreen({super.key});

  @override
  State<FusionModeScreen> createState() => _FusionModeScreenState();
}

class _FusionModeScreenState extends State<FusionModeScreen> with SingleTickerProviderStateMixin {
  int _level = 0; // 0=2r, 1=3r, 2=4r
  int _questionIndex = 0;
  int _score = 0;
  bool _levelComplete = false;
  late AnimationController _feedbackCtrl;
  bool? _lastCorrect;

  static const List<int> _rakatCounts = [2, 3, 4];
  static const List<String> _levelIds = ['fusion_2r', 'fusion_3r', 'fusion_4r'];

  List<_FusionQuestion> get _questions => _buildQuestions(_rakatCounts[_level]);

  @override
  void initState() {
    super.initState();
    _feedbackCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  List<_FusionQuestion> _buildQuestions(int rakat) {
    final steps = [
      PosturesData.all.firstWhere((p) => p.id == 'takbir'),
      PosturesData.all.firstWhere((p) => p.id == 'qiyam'),
      PosturesData.all.firstWhere((p) => p.id == 'ruku'),
      PosturesData.all.firstWhere((p) => p.id == 'sujud'),
    ];
    return steps.map((posture) {
      final formula = PosturesData.getFormula(posture.id);
      if (formula == null) return null;
      final distractors = PosturesData.formulas.where((f) => f.postureId != posture.id).take(2).toList();
      final options = [formula, ...distractors]..shuffle();
      return _FusionQuestion(posture: posture, correctFormula: formula, options: options);
    }).whereType<_FusionQuestion>().toList();
  }

  void _answer(PrayerFormula formula) {
    final correct = formula.postureId == _questions[_questionIndex].posture.id;
    _lastCorrect = correct;
    if (correct) _score++;
    _feedbackCtrl.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_questionIndex < _questions.length - 1) {
        setState(() => _questionIndex++);
      } else {
        setState(() => _levelComplete = true);
        _completeLevel();
      }
    });
  }

  Future<void> _completeLevel() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;
    await context.read<ProgressProvider>().completeModule(user.id, _levelIds[_level]);
  }

  void _nextLevel() {
    if (_level < 2) {
      setState(() {
        _level++;
        _questionIndex = 0;
        _score = 0;
        _levelComplete = false;
        _lastCorrect = null;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: Text('Mode Fusion — ${_rakatCounts[_level]} Raka\'at', style: const TextStyle(fontSize: 15)),
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 18), onPressed: () => Navigator.pop(context)),
        ),
        body: _levelComplete ? _buildLevelComplete() : _buildQuestion(),
      );

  Widget _buildQuestion() {
    if (_questionIndex >= _questions.length) return const SizedBox();
    final q = _questions[_questionIndex];

    return AnimatedBuilder(
      animation: _feedbackCtrl,
      builder: (_, child) => child!,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            LinearProgressIndicator(
              value: (_questionIndex + 1) / _questions.length,
              backgroundColor: AppColors.bgCard3,
              valueColor: const AlwaysStoppedAnimation(AppColors.purple),
              minHeight: 4,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text('${_questionIndex + 1} / ${_questions.length}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 24),

            // Avatar dans la posture
            _PostureAvatar(posture: q.posture),
            const SizedBox(height: 16),

            const Text('Quelle formule correspond à cette posture ?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(q.posture.nameFr, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 24),

            // Options
            ...q.options.map((formula) => GestureDetector(
              onTap: _lastCorrect == null ? () => _answer(formula) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _lastCorrect != null
                      ? (formula.postureId == q.posture.id ? AppColors.faithGreen.withOpacity(0.1) : AppColors.bgCard)
                      : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _lastCorrect != null && formula.postureId == q.posture.id ? AppColors.faithGreen : AppColors.textMuted.withOpacity(0.2),
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formula.arabic, style: const TextStyle(fontSize: 16, fontFamily: 'Amiri', color: AppColors.goldLight, height: 1.6)),
                      Text(formula.phonetic, style: const TextStyle(fontSize: 11, color: AppColors.tealLight, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelComplete() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_score >= _questions.length * 0.7 ? '🌟' : '👏', style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 20),
              Text(
                'Niveau ${_rakatCounts[_level]} Raka\'at terminé !',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text('$_score / ${_questions.length} bonnes réponses', style: const TextStyle(fontSize: 16, color: AppColors.gold)),
              const SizedBox(height: 40),
              GoldenButton(
                label: _level < 2 ? 'Niveau suivant →' : '✓ Mode Fusion maîtrisé !',
                width: double.infinity,
                onTap: _nextLevel,
              ),
            ],
          ),
        ),
      );
}

class _PostureAvatar extends StatelessWidget {
  final PostureData posture;
  const _PostureAvatar({required this.posture});

  @override
  Widget build(BuildContext context) {
    final emoji = switch (posture.id) {
      'takbir' => '🙌',
      'qiyam' => '🧍',
      'ruku' => '🙇',
      'sujud' => '🤲',
      _ => '🧎',
    };
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.purple.withOpacity(0.08),
        border: Border.all(color: AppColors.purple.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: AppColors.purple.withOpacity(0.15), blurRadius: 24)],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 56))),
    );
  }
}

class _FusionQuestion {
  final PostureData posture;
  final PrayerFormula correctFormula;
  final List<PrayerFormula> options;

  const _FusionQuestion({required this.posture, required this.correctFormula, required this.options});
}
