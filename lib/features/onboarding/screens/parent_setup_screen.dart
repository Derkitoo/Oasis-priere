import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/models/user_model.dart';
import '../../../shared/widgets/golden_button.dart';
import 'tutorial_screen.dart';

class ParentSetupScreen extends StatefulWidget {
  final String nickname;
  final int baseSkin;
  final String outfitId;
  final int initialGrade;

  const ParentSetupScreen({
    super.key,
    required this.nickname,
    required this.baseSkin,
    required this.outfitId,
    required this.initialGrade,
  });

  @override
  State<ParentSetupScreen> createState() => _ParentSetupScreenState();
}

class _ParentSetupScreenState extends State<ParentSetupScreen> {
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _pin1Ctrl = TextEditingController();
  final TextEditingController _pin2Ctrl = TextEditingController();
  String _selectedMethod = 'UOIF';
  Map<String, bool> _reminders = UserModel.defaultReminders();
  Map<String, int> _delays = UserModel.defaultDelays();
  bool _isLoading = false;
  double? _lat, _lng;
  bool _pinMismatch = false;
  int _step = 0; // 0=parent_intro, 1=city, 2=reminders, 3=pin

  @override
  void dispose() {
    _cityCtrl.dispose();
    _pin1Ctrl.dispose();
    _pin2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (_) {}
  }

  Future<void> _finish() async {
    if (_pin1Ctrl.text != _pin2Ctrl.text) {
      setState(() => _pinMismatch = true);
      return;
    }
    if (_pin1Ctrl.text.length != 4) return;

    setState(() => _isLoading = true);
    try {
      await context.read<UserProvider>().createUser(
            nickname: widget.nickname,
            ageBracket: '7-13',
            parentPin: _pin1Ctrl.text,
            prayerCity: _cityCtrl.text.trim(),
            latitude: _lat,
            longitude: _lng,
            calculationMethod: _selectedMethod,
            prayerReminders: _reminders,
            reminderDelays: _delays,
            baseSkin: widget.baseSkin,
            outfitId: widget.outfitId,
            initialGrade: widget.initialGrade,
          );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TutorialScreen()));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: LinearProgressIndicator(value: (4 + _step) / 6, backgroundColor: AppColors.bgCard3, valueColor: const AlwaysStoppedAnimation(AppColors.gold), minHeight: 4, borderRadius: BorderRadius.circular(4)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: switch (_step) {
                        0 => _buildParentIntro(),
                        1 => _buildCityStep(),
                        2 => _buildRemindersStep(),
                        _ => _buildPinStep(),
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: GoldenButton(
                  label: _step < 3 ? 'Suivant →' : 'Créer l\'Oasis',
                  width: double.infinity,
                  isLoading: _isLoading,
                  onTap: () {
                    if (_step < 3) setState(() => _step++);
                    else _finish();
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildParentIntro() => Column(
        children: [
          const SizedBox(height: 16),
          const Text('👨‍👧', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 20),
          const Text('Appelle un adulte de ta famille !', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          const Text('Cette étape se fait ensemble avec tes parents.\nElles permettent de configurer les rappels de prière et de protéger l\'application.', style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.6), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.teal.withOpacity(0.3))),
            child: const Row(
              children: [
                Text('🔒', style: TextStyle(fontSize: 24)),
                SizedBox(width: 12),
                Expanded(child: Text('Aucun email n\'est requis. Tout reste privé sur ton téléphone.', style: TextStyle(fontSize: 12, color: AppColors.tealLight, height: 1.5))),
              ],
            ),
          ),
        ],
      );

  Widget _buildCityStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Votre ville', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Pour calculer les horaires de prière avec précision', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 20),
          TextField(
            controller: _cityCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: _inputDeco('Ex : Paris, Lyon, Marseille...'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _detectLocation,
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, color: AppColors.teal, size: 16),
                const SizedBox(width: 6),
                const Text('Détecter automatiquement', style: TextStyle(fontSize: 12, color: AppColors.teal)),
                if (_lat != null) const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check_circle_rounded, color: AppColors.faithGreen, size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Méthode de calcul', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...AppConstants.calculationMethods.entries.map((e) => GestureDetector(
            onTap: () => setState(() => _selectedMethod = e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedMethod == e.key ? AppColors.gold.withOpacity(0.1) : AppColors.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _selectedMethod == e.key ? AppColors.gold : AppColors.textMuted.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(e.value, style: TextStyle(fontSize: 13, color: _selectedMethod == e.key ? AppColors.gold : AppColors.textPrimary))),
                  if (_selectedMethod == e.key) const Icon(Icons.check_rounded, color: AppColors.gold, size: 18),
                ],
              ),
            ),
          )),
        ],
      );

  Widget _buildRemindersStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rappels de prière', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Activez les rappels que vous souhaitez recevoir', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 20),
          ...AppConstants.prayerNames.map((name) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.textMuted.withOpacity(0.15))),
            child: Row(
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const Spacer(),
                // Délai
                DropdownButton<int>(
                  value: _delays[name] ?? 0,
                  dropdownColor: AppColors.bgCard2,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('À l\'heure')),
                    DropdownMenuItem(value: 5, child: Text('+5 min')),
                    DropdownMenuItem(value: 10, child: Text('+10 min')),
                    DropdownMenuItem(value: 15, child: Text('+15 min')),
                  ],
                  onChanged: (v) => setState(() => _delays[name] = v ?? 0),
                ),
                const SizedBox(width: 8),
                Switch.adaptive(
                  value: _reminders[name] ?? true,
                  activeColor: AppColors.gold,
                  onChanged: (v) => setState(() => _reminders[name] = v),
                ),
              ],
            ),
          )),
        ],
      );

  Widget _buildPinStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Code parental secret', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('4 chiffres. Les parents peuvent modifier les paramètres avec ce code.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 24),
          TextField(
            controller: _pin1Ctrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, letterSpacing: 8),
            decoration: _inputDeco('• • • •'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _pin2Ctrl,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, letterSpacing: 8),
            decoration: _inputDeco('Confirmer le code'),
            onChanged: (_) => setState(() => _pinMismatch = false),
          ),
          if (_pinMismatch)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Les codes ne correspondent pas', style: TextStyle(color: AppColors.roseLight, fontSize: 12)),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.2))),
            child: const Text('⚠️ Retenez ce code. Si vous l\'oubliez, l\'application devra être réinstallée.', style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.5)),
          ),
        ],
      );

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.bgCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.gold)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.textMuted.withOpacity(0.2))),
        counterStyle: const TextStyle(color: AppColors.textMuted),
      );
}
