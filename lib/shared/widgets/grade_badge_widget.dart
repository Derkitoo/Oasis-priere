import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class GradeBadgeWidget extends StatelessWidget {
  final int grade;
  final bool large;

  const GradeBadgeWidget({super.key, required this.grade, this.large = false});

  @override
  Widget build(BuildContext context) {
    final size = large ? 56.0 : 36.0;
    final fontSize = large ? 22.0 : 16.0;
    final textSize = large ? 12.0 : 9.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgCard3,
            border: Border.all(color: AppColors.gold, width: large ? 2 : 1.5),
            boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 12)],
          ),
          child: Center(
            child: Text(AppConstants.gradeIcons[grade] ?? '🛡️', style: TextStyle(fontSize: fontSize)),
          ),
        ),
        if (large) ...[
          const SizedBox(height: 6),
          Text(
            'Grade $grade',
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700, color: AppColors.gold),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 120,
            child: Text(
              AppConstants.gradeNames[grade] ?? '',
              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
