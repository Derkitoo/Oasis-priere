import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class XpBarWidget extends StatelessWidget {
  final int currentXp;
  final int maxXp;
  final int grade;
  final bool showLabel;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.maxXp,
    required this.grade,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final progress = maxXp == 0 ? 1.0 : (currentXp / maxXp).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grade $grade', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gold)),
                Text('$currentXp / $maxXp XP', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(height: 8, color: AppColors.bgCard3),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.goldDim, AppColors.gold, AppColors.goldLight],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.5), blurRadius: 6)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
