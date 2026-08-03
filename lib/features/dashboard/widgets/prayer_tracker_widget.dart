import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class PrayerTrackerWidget extends StatelessWidget {
  final Set<String> doneToday;
  final Map<String, String> prayerTimes;
  final String? currentPrayer;
  final void Function(String) onPrayerTap;

  const PrayerTrackerWidget({
    super.key,
    required this.doneToday,
    required this.prayerTimes,
    this.currentPrayer,
    required this.onPrayerTap,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: AppConstants.prayerNames.map((name) {
          final done = doneToday.contains(name);
          final isCurrent = name == currentPrayer;
          return _PrayerDot(
            name: name,
            nameAr: AppConstants.prayerNamesAr[AppConstants.prayerNames.indexOf(name)],
            time: prayerTimes[name] ?? '--:--',
            done: done,
            isCurrent: isCurrent,
            onTap: () => onPrayerTap(name),
          );
        }).toList(),
      );
}

class _PrayerDot extends StatelessWidget {
  final String name;
  final String nameAr;
  final String time;
  final bool done;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PrayerDot({
    required this.name,
    required this.nameAr,
    required this.time,
    required this.done,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.gold
                    : isCurrent
                        ? AppColors.bgCard3
                        : AppColors.bgCard,
                border: Border.all(
                  color: done
                      ? AppColors.gold
                      : isCurrent
                          ? AppColors.gold.withOpacity(0.7)
                          : AppColors.textMuted.withOpacity(0.2),
                  width: isCurrent ? 2 : 1,
                ),
                boxShadow: isCurrent || done
                    ? [BoxShadow(color: AppColors.gold.withOpacity(0.3), blurRadius: 12)]
                    : null,
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded, color: AppColors.bgPrimary, size: 20)
                    : isCurrent
                        ? _buildPulse()
                        : Text(nameAr, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ),
            ),
            const SizedBox(height: 6),
            Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
            Text(time, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      );

  Widget _buildPulse() => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.7, end: 1.0),
        duration: const Duration(milliseconds: 900),
        builder: (_, v, __) => Transform.scale(
          scale: v,
          child: Container(
            width: 10, height: 10,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold),
          ),
        ),
      );
}
