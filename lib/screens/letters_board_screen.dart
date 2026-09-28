import 'package:flutter/material.dart';

import '../data/asset_checker.dart';
import '../data/letter.dart';
import '../data/letters_repository.dart';
import '../data/progress_store.dart';
import '../widgets/letter_tile.dart';
import 'letter_screen.dart';

/// لوحة الحروف الـ٢٨ (المهمة ١٠).
class LettersBoardScreen extends StatefulWidget {
  const LettersBoardScreen({
    super.key,
    required this.repository,
    required this.progress,
    required this.assets,
  });

  final LettersRepository repository;
  final ProgressStore progress;
  final AssetChecker assets;

  @override
  State<LettersBoardScreen> createState() => _LettersBoardScreenState();
}

class _LettersBoardScreenState extends State<LettersBoardScreen> {
  List<Letter>? _letters;
  Set<String> _completed = {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final letters = await widget.repository.load();
      final completed = await widget.progress.loadCompleted();
      if (!mounted) return;
      setState(() {
        _letters = letters;
        _completed = completed;
      });
    } catch (e) {
      debugPrint('[لِسان] تعذّر تحميل ${LettersRepository.csvPath}: $e');
      if (!mounted) return;
      setState(() => _error = 'تعذّر تحميل ملف الحروف');
    }
  }

  Future<void> _open(Letter letter) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LetterScreen(
          letter: letter,
          progress: widget.progress,
          assets: widget.assets,
        ),
      ),
    );
    final completed = await widget.progress.loadCompleted();
    if (mounted) setState(() => _completed = completed);
  }

  @override
  Widget build(BuildContext context) {
    final letters = _letters;
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الحروف')),
      body: _error != null
          ? Center(child: Text(_error!))
          : letters == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              key: const Key('letters_grid'),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: letters.length,
              itemBuilder: (_, i) => LetterTile(
                letter: letters[i],
                completed: _completed.contains(letters[i].nameEn),
                onTap: () => _open(letters[i]),
              ),
            ),
    );
  }
}
