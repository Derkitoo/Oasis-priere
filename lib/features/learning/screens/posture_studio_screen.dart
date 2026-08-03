import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/postures_data.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../shared/painters/posture_silhouette_painter.dart';
import '../../../shared/widgets/arabic_text_widget.dart';
import '../../../shared/widgets/golden_button.dart';

class PostureStudioScreen extends StatefulWidget {
  const PostureStudioScreen({super.key});

  @override
  State<PostureStudioScreen> createState() => _PostureStudioScreenState();
}

class _PostureStudioScreenState extends State<PostureStudioScreen> with TickerProviderStateMixin {
  int _postureIndex = 0;
  bool _showDetails = false;
  bool _quizActive = false;
  int? _quizAnswer;
  bool _quizCorrect = false;
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  PostureData get _current => PosturesData.all[_postureIndex];

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_postureIndex < PosturesData.all.length - 1) {
      _slideCtrl.reverse().then((_) {
        setState(() {
          _postureIndex++;
          _showDetails = false;
          _quizActive = false;
          _quizAnswer = null;
        });
        _slideCtrl.forward();
      });
    } else {
      _completeMastery();
    }
  }

  Future<void> _completeMastery() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;
    await context.read<ProgressProvider>().masterPosture(user.id, _current.id);
    if (mounted) Navigator.pop(context);
  }

  void _startQuiz() => setState(() { _quizActive = true; _quizAnswer = null; _quizCorrect = false; });

  void _answerQuiz(int index) {
    setState(() {
      _quizAnswer = index;
      _quizCorrect = index == _postureIndex % 4;
    });
    if (_quizCorrect) Future.delayed(const Duration(milliseconds: 800), _next);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: Text('Studio des Postures (${_postureIndex + 1}/${PosturesData.all.length})', style: const TextStyle(fontSize: 15)),
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 18), onPressed: () => Navigator.pop(context)),
        ),
        body: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Progression
                LinearProgressIndicator(
                  value: (_postureIndex + 1) / PosturesData.all.length,
                  backgroundColor: AppColors.bgCard3,
                  valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 24),

                if (!_quizActive) ...[
                  // Illustration posture
                  _PostureIllustration(posture: _current),
                  const SizedBox(height: 24),

                  // Nom en arabe + français
                  Text(_current.nameAr, style: const TextStyle(fontSize: 28, fontFamily: 'Amiri', color: AppColors.goldLight, height: 1.5)),
                  const SizedBox(height: 4),
                  Text(_current.nameFr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(_current.namePhonetic, style: const TextStyle(fontSize: 12, color: AppColors.tealLight, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 20),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12)),
                    child: Text(_current.bodyInstruction, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.6)),
                  ),

                  // Toggle détails
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => setState(() => _showDetails = !_showDetails),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_showDetails ? 'Masquer le sens ↑' : '🌙 Sens spirituel ↓', style: const TextStyle(fontSize: 12, color: AppColors.gold)),
                      ],
                    ),
                  ),

                  if (_showDetails) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.purple.withOpacity(0.2)),
                      ),
                      child: Text(
                        '"${_current.spiritualMeaning}"',
                        style: const TextStyle(fontSize: 13, color: AppColors.purpleLight, fontStyle: FontStyle.italic, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  // Formule associée
                  if (PosturesData.getFormula(_current.id) case final formula when formula != null) ...[
                    const SizedBox(height: 16),
                    ArabicTextWidget(
                      arabic: formula.arabic,
                      phonetic: formula.phonetic,
                      french: formula.french,
                    ),
                  ],

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GoldenButton(
                          label: 'Quiz !',
                          outline: true,
                          onTap: _startQuiz,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GoldenButton(
                          label: _postureIndex == PosturesData.all.length - 1 ? '✓ Terminé !' : 'Suivant →',
                          onTap: _next,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Quiz — quelle posture correspond à cette description ?
                  const SizedBox(height: 16),
                  const Text('QUIZ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: AppColors.gold)),
                  const SizedBox(height: 12),
                  Text(
                    '"${_current.bodyInstruction}"',
                    style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text('Quelle posture correspond ?', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 16),
                  // 4 options (bonne réponse + 3 distracteurs)
                  ...List.generate(4, (i) {
                    final optionIndex = ((_postureIndex + i * 2) % PosturesData.all.length);
                    final posture = PosturesData.all[optionIndex];
                    final isCorrect = optionIndex == _postureIndex;
                    final selected = _quizAnswer == i;
                    Color? bg;
                    if (_quizAnswer != null) {
                      if (selected && isCorrect) bg = AppColors.faithGreen.withOpacity(0.15);
                      else if (selected && !isCorrect) bg = AppColors.rose.withOpacity(0.15);
                      else if (!selected && isCorrect) bg = AppColors.faithGreen.withOpacity(0.08);
                    }
                    return GestureDetector(
                      onTap: _quizAnswer == null ? () => _answerQuiz(i) : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bg ?? AppColors.bgCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selected ? (isCorrect ? AppColors.faithGreen : AppColors.roseLight) : AppColors.textMuted.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Text(posture.nameAr, style: const TextStyle(fontSize: 18, fontFamily: 'Amiri', color: AppColors.goldLight)),
                            const SizedBox(width: 10),
                            Text(posture.nameFr, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                            const Spacer(),
                            if (_quizAnswer != null && isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.faithGreen, size: 18),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      );
}

class _PostureIllustration extends StatelessWidget {
  final PostureData posture;
  const _PostureIllustration({required this.posture});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.teal.withOpacity(0.08),
        border: Border.all(color: AppColors.teal.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomPaint(
          painter: PostureSilhouettePainter(posture.id, color: AppColors.tealLight),
          size: const Size(128, 128),
        ),
      ),
    );
  }
}
