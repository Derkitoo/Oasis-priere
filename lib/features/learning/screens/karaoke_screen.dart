import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/data/suras_data.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/progress_provider.dart';
import '../../../core/services/audio_service.dart';
import '../../../shared/widgets/golden_button.dart';

class KaraokeScreen extends StatefulWidget {
  const KaraokeScreen({super.key});

  @override
  State<KaraokeScreen> createState() => _KaraokeScreenState();
}

class _KaraokeScreenState extends State<KaraokeScreen> {
  int _suraIndex = 0;
  int _step = 0; // 0=écoute, 1=puzzle, 2=défi micro
  int _highlightedVerse = 0;
  bool _isPlaying = false;
  final AudioService _audio = AudioService();
  List<int> _puzzleOrder = [];
  List<int> _userOrder = [];
  bool _puzzleSolved = false;

  SuraData get _currentSura => SurasData.all[_suraIndex];

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    _puzzleOrder = List.generate(_currentSura.verses.length, (i) => i)..shuffle();
    _userOrder = [];
    _puzzleSolved = false;
  }

  @override
  void dispose() {
    _audio.stop();
    super.dispose();
  }

  Future<void> _playSura() async {
    setState(() => _isPlaying = true);
    await _audio.playSura(_currentSura.id);
    // Simuler défilement des versets
    for (int i = 0; i < _currentSura.verses.length; i++) {
      if (!mounted) break;
      setState(() => _highlightedVerse = i);
      await Future.delayed(Duration(milliseconds: 1500 + _currentSura.verses[i].arabic.length * 30));
    }
    if (mounted) setState(() => _isPlaying = false);
  }

  void _addPuzzlePiece(int verseIndex) {
    if (_userOrder.contains(verseIndex)) return;
    setState(() {
      _userOrder.add(verseIndex);
      if (_userOrder.length == _currentSura.verses.length) {
        _puzzleSolved = _userOrder.asMap().entries.every((e) => e.value == e.key);
      }
    });
  }

  Future<void> _completeSura() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;
    await context.read<ProgressProvider>().memorizeSura(user.id, _currentSura.id);
    if (_suraIndex < SurasData.all.length - 1) {
      setState(() {
        _suraIndex++;
        _step = 0;
        _highlightedVerse = 0;
        _initPuzzle();
      });
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: AppBar(
          title: Text(_currentSura.nameFr, style: const TextStyle(fontSize: 15)),
          backgroundColor: AppColors.bgCard,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, size: 18), onPressed: () => Navigator.pop(context)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('${_suraIndex + 1}/${SurasData.all.length}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
          ],
        ),
        body: Column(
          children: [
            // Sélecteur de sourate
            _SuraSelector(suras: SurasData.all, selectedIndex: _suraIndex, onSelect: (i) => setState(() { _suraIndex = i; _step = 0; _initPuzzle(); })),

            // Onglets étapes
            _StepTabs(currentStep: _step, onTap: (i) => setState(() => _step = i)),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey('${_suraIndex}_$_step'),
                  child: switch (_step) {
                    0 => _ListenStep(sura: _currentSura, highlighted: _highlightedVerse, isPlaying: _isPlaying, onPlay: _playSura),
                    1 => _PuzzleStep(sura: _currentSura, puzzleOrder: _puzzleOrder, userOrder: _userOrder, solved: _puzzleSolved, onAddPiece: _addPuzzlePiece, onReset: _initPuzzle),
                    _ => _MicStep(sura: _currentSura, onComplete: _completeSura),
                  },
                ),
              ),
            ),

            // CTA selon étape
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: _step < 2
                  ? GoldenButton(
                      label: 'Étape suivante →',
                      width: double.infinity,
                      onTap: () => setState(() => _step++),
                    )
                  : GoldenButton(
                      label: _suraIndex < SurasData.all.length - 1 ? 'Sourate suivante →' : '✓ Maître de la récitation !',
                      width: double.infinity,
                      onTap: _completeSura,
                    ),
            ),
          ],
        ),
      );
}

class _SuraSelector extends StatelessWidget {
  final List<SuraData> suras;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _SuraSelector({required this.suras, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: suras.asMap().entries.map((e) => GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: selectedIndex == e.key ? AppColors.gold.withOpacity(0.12) : AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: selectedIndex == e.key ? AppColors.gold : AppColors.textMuted.withOpacity(0.2)),
              ),
              child: Text(e.value.nameFr, style: TextStyle(fontSize: 12, color: selectedIndex == e.key ? AppColors.gold : AppColors.textMuted, fontWeight: selectedIndex == e.key ? FontWeight.w700 : FontWeight.normal)),
            ),
          )).toList(),
        ),
      );
}

class _StepTabs extends StatelessWidget {
  final int currentStep;
  final void Function(int) onTap;

  const _StepTabs({required this.currentStep, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.bgCard,
        child: Row(
          children: [
            _Tab(label: '🎵 Écoute', active: currentStep == 0, done: currentStep > 0, onTap: () => onTap(0)),
            _Tab(label: '🧩 Puzzle', active: currentStep == 1, done: currentStep > 1, onTap: currentStep >= 1 ? () => onTap(1) : null),
            _Tab(label: '🎤 Défi', active: currentStep == 2, done: false, onTap: currentStep >= 2 ? () => onTap(2) : null),
          ],
        ),
      );
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final bool done;
  final VoidCallback? onTap;

  const _Tab({required this.label, required this.active, required this.done, this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: active ? AppColors.gold : Colors.transparent, width: 2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? AppColors.gold : done ? AppColors.faithGreen : AppColors.textMuted)),
                if (done) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.check_rounded, size: 12, color: AppColors.faithGreen)),
              ],
            ),
          ),
        ),
      );
}

class _ListenStep extends StatelessWidget {
  final SuraData sura;
  final int highlighted;
  final bool isPlaying;
  final VoidCallback onPlay;

  const _ListenStep({required this.sura, required this.highlighted, required this.isPlaying, required this.onPlay});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Bouton play
          GestureDetector(
            onTap: isPlaying ? null : onPlay,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded, color: AppColors.gold, size: 40),
                  const SizedBox(width: 12),
                  Text(isPlaying ? 'Écoute attentivement...' : 'Écouter la sourate', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
          // Versets triple ligne
          ...sura.verses.asMap().entries.map((e) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: e.key == highlighted && isPlaying ? AppColors.gold.withOpacity(0.08) : AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: e.key == highlighted && isPlaying ? AppColors.gold.withOpacity(0.3) : Colors.transparent),
            ),
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(e.value.arabic, style: TextStyle(fontSize: 20, fontFamily: 'Amiri', color: e.key == highlighted && isPlaying ? AppColors.goldLight : AppColors.textPrimary, height: 1.8), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 6),
                Text(e.value.phonetic, style: const TextStyle(fontSize: 12, color: AppColors.tealLight, fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text(e.value.french, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4), textAlign: TextAlign.center),
              ],
            ),
          )),
        ],
      );
}

class _PuzzleStep extends StatelessWidget {
  final SuraData sura;
  final List<int> puzzleOrder;
  final List<int> userOrder;
  final bool solved;
  final void Function(int) onAddPiece;
  final VoidCallback onReset;

  const _PuzzleStep({required this.sura, required this.puzzleOrder, required this.userOrder, required this.solved, required this.onAddPiece, required this.onReset});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Remets les versets dans le bon ordre', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Tape les cartes dans l\'ordre de la sourate', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 16),

          if (solved)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.faithGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('✅', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('Bravo ! Ordre correct !', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.faithGreen)),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10, runSpacing: 10,
              children: puzzleOrder.map((verseIndex) {
                final selected = userOrder.contains(verseIndex);
                final posInUser = selected ? userOrder.indexOf(verseIndex) : -1;
                final isCorrect = posInUser >= 0 && posInUser == verseIndex;
                return GestureDetector(
                  onTap: selected ? null : () => onAddPiece(verseIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? (isCorrect ? AppColors.faithGreen.withOpacity(0.1) : AppColors.bgCard2) : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? (isCorrect ? AppColors.faithGreen : AppColors.gold.withOpacity(0.3)) : AppColors.textMuted.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        if (selected) Text('#${posInUser + 1}', style: TextStyle(fontSize: 9, color: isCorrect ? AppColors.faithGreen : AppColors.gold)),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(sura.verses[verseIndex].arabic.split(' ').take(3).join(' ') + '...', style: const TextStyle(fontSize: 13, fontFamily: 'Amiri', color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 12),
          if (!solved && userOrder.isNotEmpty)
            TextButton(onPressed: onReset, child: const Text('Recommencer', style: TextStyle(fontSize: 12, color: AppColors.textMuted))),
        ],
      );
}

class _MicStep extends StatefulWidget {
  final SuraData sura;
  final VoidCallback onComplete;

  const _MicStep({required this.sura, required this.onComplete});

  @override
  State<_MicStep> createState() => _MicStepState();
}

class _MicStepState extends State<_MicStep> {
  bool _recording = false;
  bool _done = false;
  double _score = 0;

  Future<void> _startRecording() async {
    setState(() => _recording = true);
    // Simulation (sans vrai ASR en mode demo)
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _recording = false;
        _done = true;
        _score = 0.75 + (DateTime.now().millisecondsSinceEpoch % 25) / 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Défi Récitation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          const Text('Récite la sourate à voix haute. Sois à l\'aise, prends ton temps.', style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5)),
          const SizedBox(height: 24),

          // Versets de référence
          ...widget.sura.verses.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(v.arabic, style: const TextStyle(fontSize: 20, fontFamily: 'Amiri', color: AppColors.goldLight, height: 1.8), textAlign: TextAlign.center),
            ),
          )),

          const SizedBox(height: 24),

          if (!_done) ...[
            GestureDetector(
              onTap: _recording ? null : _startRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _recording ? AppColors.roseLight.withOpacity(0.1) : AppColors.bgCard,
                  shape: BoxShape.circle,
                  border: Border.all(color: _recording ? AppColors.roseLight : AppColors.gold, width: 2),
                  boxShadow: _recording ? [BoxShadow(color: AppColors.roseLight.withOpacity(0.3), blurRadius: 20)] : null,
                ),
                child: Icon(_recording ? Icons.mic_rounded : Icons.mic_none_rounded, color: _recording ? AppColors.roseLight : AppColors.gold, size: 48),
              ),
            ),
            const SizedBox(height: 12),
            Text(_recording ? 'Récite maintenant...' : 'Appuie pour commencer', style: TextStyle(fontSize: 12, color: _recording ? AppColors.roseLight : AppColors.textMuted), textAlign: TextAlign.center),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.faithGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.faithGreen.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('✅', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 8),
                  Text('Score : ${(_score * 100).round()}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.faithGreen)),
                  const SizedBox(height: 4),
                  const Text('Bien joué ! Ta récitation est validée. Continue comme ça !', style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5), textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ],
      );
}
