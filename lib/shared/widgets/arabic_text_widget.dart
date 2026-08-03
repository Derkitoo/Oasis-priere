import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ArabicTextWidget extends StatelessWidget {
  final String arabic;
  final String? phonetic;
  final String? french;
  final double arabicSize;
  final bool highlight;

  const ArabicTextWidget({
    super.key,
    required this.arabic,
    this.phonetic,
    this.french,
    this.arabicSize = 24,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: highlight
            ? BoxDecoration(
                color: AppColors.gold.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              )
            : null,
        child: Column(
          children: [
            // Texte arabe (RTL)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                arabic,
                style: TextStyle(
                  fontSize: arabicSize,
                  fontFamily: 'Amiri',
                  color: AppColors.goldLight,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (phonetic != null) ...[
              const SizedBox(height: 8),
              Text(
                phonetic!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.tealLight,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (french != null) ...[
              const SizedBox(height: 6),
              Text(
                french!,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
}
