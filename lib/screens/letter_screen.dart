import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../data/asset_checker.dart';
import '../data/letter.dart';
import '../data/progress_store.dart';
import '../widgets/missing_asset_box.dart';

const String kNotAddedYet = 'لم يُضف بعد';
const String kSoundNotAddedYet = 'الصوت لم يُضف بعد';

/// شاشة الحرف: الحرف · أشكاله الأربعة · صوته · كلمة المثال ومعناها (نصًّا بلا صورة).
/// كل أصل غائب يظهر مكانه إطار بديل ولا تنهار الشاشة.
class LetterScreen extends StatefulWidget {
  const LetterScreen({
    super.key,
    required this.letter,
    required this.progress,
    required this.assets,
  });

  final Letter letter;
  final ProgressStore progress;
  final AssetChecker assets;

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  bool? _hasSound;
  final Map<LetterForm, bool> _hasForm = {};
  bool _completed = false;
  AudioPlayer? _player;

  Letter get _l => widget.letter;

  @override
  void initState() {
    super.initState();
    _probe();
  }

  Future<void> _probe() async {
    final sound = await widget.assets.exists(_l.soundPath);
    final forms = <LetterForm, bool>{};
    for (final f in LetterForm.values) {
      forms[f] = await widget.assets.exists(_l.formPath(f));
    }
    final completed = (await widget.progress.loadCompleted()).contains(
      _l.nameEn,
    );
    if (!mounted) return;
    setState(() {
      _hasSound = sound;
      _hasForm.addAll(forms);
      _completed = completed;
    });
  }

  Future<void> _playSound() async {
    try {
      _player ??= AudioPlayer();
      // AssetSource يضيف البادئة `assets/` تلقائيًّا.
      await _player!.play(
        AssetSource(_l.soundPath.substring('assets/'.length)),
      );
    } catch (e) {
      debugPrint('[لِسان] تعذّر تشغيل ${_l.soundPath}: $e');
      if (mounted) setState(() => _hasSound = false);
    }
  }

  Future<void> _toggleCompleted() async {
    final next = !_completed;
    await widget.progress.setCompleted(_l.nameEn, next);
    if (mounted) setState(() => _completed = next);
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Widget _image(String path, bool? exists, {double height = 90}) {
    if (exists == null) return SizedBox(height: height);
    if (!exists) return MissingAssetBox(message: kNotAddedYet, height: height);
    return Image.asset(
      path,
      height: height,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          MissingAssetBox(message: kNotAddedYet, height: height),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('حرف ${_l.letter}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Image.asset(
              _l.letterPath,
              key: const Key('big_letter'),
              height: 170,
              fit: BoxFit.contain,
              // لو غابت الصورة نرسم الحرف بخط التطبيق بارتفاع سطر يمنع القطع
              errorBuilder: (_, _, _) => Text(
                _l.letter,
                style: const TextStyle(fontSize: 110, height: 1.7),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('الأشكال الأربعة', style: text.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final f in LetterForm.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        _image(_l.formPath(f), _hasForm[f], height: 64),
                        const SizedBox(height: 4),
                        Text(f.labelAr),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('صوت الحرف', style: text.titleMedium),
          const SizedBox(height: 8),
          if (_hasSound == true)
            FilledButton.icon(
              key: const Key('play_sound'),
              onPressed: _playSound,
              icon: const Icon(Icons.volume_up),
              label: const Text('استمع'),
            )
          else if (_hasSound == false)
            const MissingAssetBox(
              key: Key('sound_missing'),
              message: kSoundNotAddedYet,
            ),
          const SizedBox(height: 20),
          Text('كلمة المثال', style: text.titleMedium),
          const SizedBox(height: 8),
          Text(
            _l.word.isEmpty ? kNotAddedYet : _l.word,
            key: const Key('word'),
            style: text.headlineSmall,
          ),
          Text(
            _l.meaningEn.isEmpty ? kNotAddedYet : _l.meaningEn,
            key: const Key('meaning'),
            textDirection: _l.meaningEn.isEmpty
                ? TextDirection.rtl
                : TextDirection.ltr,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const Key('toggle_completed'),
            onPressed: _toggleCompleted,
            icon: Icon(
              _completed ? Icons.check_circle : Icons.radio_button_unchecked,
            ),
            label: Text(_completed ? 'مكتمل ✓' : 'أتممتُ هذا الحرف'),
          ),
        ],
      ),
    );
  }
}
