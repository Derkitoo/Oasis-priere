import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/user_provider.dart';
import '../../../shared/widgets/golden_button.dart';
import '../widgets/wudu_checklist_widget.dart';
import '../widgets/qibla_compass_widget.dart';
import 'guided_prayer_screen.dart';

class PreparationScreen extends StatefulWidget {
  final String prayerName;

  const PreparationScreen({super.key, required this.prayerName});

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  int _tab = 0; // 0=wudu, 1=qibla
  bool _wuduDone = false;
  bool _qiblaAligned = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: Text('Préparer ${widget.prayerName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.bgCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Onglets Wudu / Qibla
          Container(
            color: AppColors.bgCard,
            child: Row(
              children: [
                _TabBtn(label: '💧 Wudu', active: _tab == 0, onTap: () => setState(() => _tab = 0), done: _wuduDone),
                _TabBtn(label: '🧭 Qibla', active: _tab == 1, onTap: () => setState(() => _tab = 1), done: _qiblaAligned),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _tab == 0
                    ? WuduChecklistWidget(
                        key: const ValueKey('wudu'),
                        onComplete: () => setState(() => _wuduDone = true),
                      )
                    : _QiblaTab(
                        key: const ValueKey('qibla'),
                        lat: user?.latitude ?? 48.8566,
                        lng: user?.longitude ?? 2.3522,
                        onAligned: (v) => setState(() => _qiblaAligned = v),
                      ),
              ),
            ),
          ),

          // CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Column(
              children: [
                // Indicateurs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatusChip(label: 'Wudu', done: _wuduDone),
                    const SizedBox(width: 12),
                    _StatusChip(label: 'Qibla', done: _qiblaAligned),
                  ],
                ),
                const SizedBox(height: 16),
                GoldenButton(
                  label: 'Commencer la prière →',
                  width: double.infinity,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GuidedPrayerScreen(prayerName: widget.prayerName, qiblaAligned: _qiblaAligned),
                    ),
                  ),
                ),
                if (!_wuduDone || !_qiblaAligned)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _wuduDone ? 'Astuce : oriente-toi vers la Qibla avant de commencer' : 'Fais le Wudu avant la prière',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QiblaTab extends StatelessWidget {
  final double lat;
  final double lng;
  final void Function(bool) onAligned;

  const _QiblaTab({super.key, required this.lat, required this.lng, required this.onAligned});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Oriente-toi vers La Mecque', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Pose le téléphone à plat ou tiens-le droit, face à toi.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          QiblaCompassWidget(latitude: lat, longitude: lng, onAlignmentChange: onAligned),
        ],
      );
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final bool done;
  final VoidCallback onTap;

  const _TabBtn({required this.label, required this.active, required this.done, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: active ? AppColors.gold : Colors.transparent, width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? AppColors.gold : AppColors.textMuted)),
                if (done) const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check_circle_rounded, color: AppColors.faithGreen, size: 14),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool done;

  const _StatusChip({required this.label, required this.done});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: done ? AppColors.faithGreen.withOpacity(0.1) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: done ? AppColors.faithGreen.withOpacity(0.4) : AppColors.textMuted.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 14, color: done ? AppColors.faithGreen : AppColors.textMuted),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 12, color: done ? AppColors.faithGreen : AppColors.textMuted, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
