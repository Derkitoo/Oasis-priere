import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/avatar_builder_widget.dart';
import '../../../shared/widgets/golden_button.dart';
import 'level_assessment_screen.dart';

class AvatarCreationScreen extends StatefulWidget {
  const AvatarCreationScreen({super.key});

  @override
  State<AvatarCreationScreen> createState() => _AvatarCreationScreenState();
}

class _AvatarCreationScreenState extends State<AvatarCreationScreen> {
  int _selectedSkin = 1;
  int _selectedHeadwear = 0; // 0=chéchia blanche, 1=chéchia dorée, 2=hijab vert, 3=hijab corail
  int _selectedOutfit = 0;
  final TextEditingController _nicknameCtrl = TextEditingController();
  int _step = 0; // 0=skin, 1=headwear, 2=tenue, 3=pseudo

  static const List<Color> skinTones = [
    Color(0xFFF5D5B8), Color(0xFFE8B88A), Color(0xFFD4956A),
    Color(0xFFBF7A50), Color(0xFF9A5B3A), Color(0xFF6E3920),
  ];

  static const List<String> headwearIds = ['chechia_white', 'chechia_gold', 'hijab_emerald', 'hijab_pink'];
  static const List<String> headwearLabels = ['Chéchia Blanche', 'Chéchia Dorée', 'Voile Émeraude', 'Voile Corail'];

  static const List<String> outfitNames = ['Qamis Blanc', 'Qamis Vert Émeraude', 'Abaya Bleu Marine'];
  static const List<Color> outfitColors = [Color(0xFFF5F5F5), Color(0xFF2A9D8F), Color(0xFF264E70)];

  static const List<String> nicknameSuggestions = [
    'Farouk', 'Khadija', 'Youssef', 'Mariam', 'Omar', 'Fatima',
    'Ibrahim', 'Aisha', 'Suleyman', 'Zainab', 'Bilal', 'Hafsa',
  ];

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      if (_nicknameCtrl.text.trim().isEmpty) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LevelAssessmentScreen(
            nickname: _nicknameCtrl.text.trim(),
            baseSkin: _selectedSkin + 1,
            outfitId: 'outfit_${_selectedOutfit == 0 ? 'default' : outfitNames[_selectedOutfit].toLowerCase().replaceAll(' ', '_')}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Column(
            children: [
              _OnboardingProgressBar(step: _step + 1, total: 6),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Aperçu Avatar Modulaire 2D
                      AvatarBuilderWidget(
                        skinColor: skinTones[_selectedSkin],
                        outfitColor: outfitColors[_selectedOutfit],
                        headwearId: headwearIds[_selectedHeadwear],
                        expression: 'happy',
                        size: 150,
                      ),
                      const SizedBox(height: 28),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: KeyedSubtree(
                          key: ValueKey(_step),
                          child: switch (_step) {
                            0 => _SkinStep(
                                skinTones: skinTones,
                                selected: _selectedSkin,
                                onSelect: (i) => setState(() => _selectedSkin = i),
                              ),
                            1 => _HeadwearStep(
                                labels: headwearLabels,
                                selected: _selectedHeadwear,
                                onSelect: (i) => setState(() => _selectedHeadwear = i),
                              ),
                            2 => _OutfitStep(
                                outfitNames: outfitNames,
                                outfitColors: outfitColors,
                                selected: _selectedOutfit,
                                onSelect: (i) => setState(() => _selectedOutfit = i),
                              ),
                            _ => _NicknameStep(
                                controller: _nicknameCtrl,
                                suggestions: nicknameSuggestions,
                                onSuggestion: (s) => setState(() => _nicknameCtrl.text = s),
                              ),
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: GoldenButton(
                  label: _step < 3 ? 'Suivant →' : 'Mon aventure commence !',
                  width: double.infinity,
                  onTap: _nextStep,
                ),
              ),
            ],
          ),
        ),
      );
}

class _SkinStep extends StatelessWidget {
  final List<Color> skinTones;
  final int selected;
  final void Function(int) onSelect;

  const _SkinStep({required this.skinTones, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Ton teint de peau', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Choisis la couleur qui te ressemble', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 14, runSpacing: 14,
            alignment: WrapAlignment.center,
            children: List.generate(skinTones.length, (i) => GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: skinTones[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected == i ? AppColors.gold : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: selected == i ? [BoxShadow(color: AppColors.gold.withValues(alpha: 0.4), blurRadius: 10)] : null,
                ),
                child: selected == i ? const Icon(Icons.check_rounded, color: Colors.white, size: 22) : null,
              ),
            )),
          ),
        ],
      );
}

class _HeadwearStep extends StatelessWidget {
  final List<String> labels;
  final int selected;
  final void Function(int) onSelect;

  const _HeadwearStep({required this.labels, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Ton couvre-chef de départ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Personnalise ton apparence selon tes envies', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10, runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(labels.length, (i) => GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected == i ? AppColors.gold.withValues(alpha: 0.2) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected == i ? AppColors.gold : AppColors.textMuted.withValues(alpha: 0.2), width: selected == i ? 2 : 1),
                ),
                child: Text(labels[i], style: TextStyle(fontSize: 12, color: selected == i ? AppColors.gold : AppColors.textPrimary, fontWeight: selected == i ? FontWeight.w700 : FontWeight.w500)),
              ),
            )),
          ),
        ],
      );
}

class _OutfitStep extends StatelessWidget {
  final List<String> outfitNames;
  final List<Color> outfitColors;
  final int selected;
  final void Function(int) onSelect;

  const _OutfitStep({required this.outfitNames, required this.outfitColors, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Ta tenue de départ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Tu en débloqueras d\'autres en accomplissant tes prières !', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(outfitNames.length, (i) => GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selected == i ? outfitColors[i].withValues(alpha: 0.15) : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected == i ? outfitColors[i] : AppColors.textMuted.withValues(alpha: 0.2), width: selected == i ? 2 : 1),
                ),
                child: Column(
                  children: [
                    Container(width: 34, height: 34, decoration: BoxDecoration(color: outfitColors[i], borderRadius: BorderRadius.circular(8))),
                    const SizedBox(height: 6),
                    Text(outfitNames[i], style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ),
            )),
          ),
        ],
      );
}

class _NicknameStep extends StatelessWidget {
  final TextEditingController controller;
  final List<String> suggestions;
  final void Function(String) onSuggestion;

  const _NicknameStep({required this.controller, required this.suggestions, required this.onSuggestion});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Comment tu t\'appelles ?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Ton prénom ou un surnom (max 20 caractères)', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            maxLength: 20,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Ton pseudo...',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.bgCard,
              counterStyle: const TextStyle(color: AppColors.textMuted),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.gold)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.2))),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Suggestions', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            alignment: WrapAlignment.center,
            children: suggestions.take(8).map((s) => GestureDetector(
              onTap: () => onSuggestion(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(color: AppColors.bgCard3, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.gold.withValues(alpha: 0.2))),
                child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
              ),
            )).toList(),
          ),
        ],
      );
}

class _OnboardingProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _OnboardingProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Étape $step sur $total', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text('${(step / total * 100).round()}%', style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: step / total,
                backgroundColor: AppColors.bgCard3,
                valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                minHeight: 4,
              ),
            ),
          ],
        ),
      );
}
