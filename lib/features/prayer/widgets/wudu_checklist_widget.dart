import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptic_utils.dart';

class WuduChecklistWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const WuduChecklistWidget({super.key, required this.onComplete});

  @override
  State<WuduChecklistWidget> createState() => _WuduChecklistWidgetState();
}

class _WuduChecklistWidgetState extends State<WuduChecklistWidget> {
  int _currentStep = 0;

  static const List<_WuduStep> _steps = [
    _WuduStep(emoji: '🤲', titleAr: 'النية', title: 'L\'intention (Niyyah)', desc: 'Dans ton cœur, fais l\'intention de faire les ablutions pour la prière.'),
    _WuduStep(emoji: '🙌', titleAr: 'غسل اليدين', title: 'Laver les mains', desc: 'Lave tes deux mains jusqu\'aux poignets 3 fois, en commençant par la droite.'),
    _WuduStep(emoji: '💧', titleAr: 'المضمضة', title: 'Rincer la bouche', desc: 'Rince ta bouche 3 fois avec de l\'eau.'),
    _WuduStep(emoji: '👃', titleAr: 'الاستنشاق', title: 'Rincer le nez', desc: 'Aspire de l\'eau dans le nez 3 fois et mouche-toi.'),
    _WuduStep(emoji: '😊', titleAr: 'غسل الوجه', title: 'Laver le visage', desc: 'Lave tout le visage 3 fois, du front jusqu\'au menton.'),
    _WuduStep(emoji: '💪', titleAr: 'غسل الذراعين', title: 'Laver les bras', desc: 'Lave les bras jusqu\'aux coudes 3 fois, en commençant par le droit.'),
    _WuduStep(emoji: '✋', titleAr: 'مسح الرأس', title: 'Essuyer la tête', desc: 'Passe les mains mouillées sur la tête, du front vers la nuque, une seule fois.'),
    _WuduStep(emoji: '👂', titleAr: 'مسح الأذنين', title: 'Essuyer les oreilles', desc: 'Essuie l\'intérieur et l\'extérieur de tes oreilles avec les index et pouces.'),
    _WuduStep(emoji: '🦶', titleAr: 'غسل القدمين', title: 'Laver les pieds', desc: 'Lave les pieds jusqu\'aux chevilles 3 fois, en commençant par le droit.'),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Barre de progression
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text('${_currentStep}/${_steps.length}', style: const TextStyle(fontSize: 12, color: AppColors.gold, fontWeight: FontWeight.w700)),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentStep / _steps.length,
                      backgroundColor: AppColors.bgCard3,
                      valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Étapes
          ...List.generate(_steps.length, (i) => _StepItem(
                step: _steps[i],
                state: i < _currentStep ? _StepState.done : i == _currentStep ? _StepState.current : _StepState.upcoming,
                onTap: i == _currentStep
                    ? () async {
                        vibrate(duration: 50, amplitude: 60);
                        setState(() => _currentStep++);
                        if (_currentStep >= _steps.length) widget.onComplete();
                      }
                    : null,
              )),
        ],
      );
}

enum _StepState { done, current, upcoming }

class _StepItem extends StatelessWidget {
  final _WuduStep step;
  final _StepState state;
  final VoidCallback? onTap;

  const _StepItem({required this.step, required this.state, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: state == _StepState.current ? AppColors.teal.withOpacity(0.1) : AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state == _StepState.done
                  ? AppColors.faithGreen.withOpacity(0.4)
                  : state == _StepState.current
                      ? AppColors.teal
                      : AppColors.textMuted.withOpacity(0.1),
              width: state == _StepState.current ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icône état
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state == _StepState.done
                      ? AppColors.faithGreen.withOpacity(0.15)
                      : state == _StepState.current
                          ? AppColors.teal.withOpacity(0.15)
                          : AppColors.bgCard3,
                ),
                child: Center(
                  child: state == _StepState.done
                      ? const Icon(Icons.check_rounded, color: AppColors.faithGreen, size: 20)
                      : Text(step.emoji, style: TextStyle(fontSize: state == _StepState.current ? 20 : 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: state == _StepState.upcoming ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                    ),
                    if (state == _StepState.current) ...[
                      const SizedBox(height: 4),
                      Text(step.desc, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4)),
                    ],
                  ],
                ),
              ),
              if (state == _StepState.current)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(8)),
                  child: const Text('✓ Fait', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
            ],
          ),
        ),
      );
}

class _WuduStep {
  final String emoji;
  final String titleAr;
  final String title;
  final String desc;

  const _WuduStep({required this.emoji, required this.titleAr, required this.title, required this.desc});
}
