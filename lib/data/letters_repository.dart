import 'package:flutter/services.dart';

import 'letter.dart';

/// يقرأ الحروف من ملف CSV داخل الحزمة (بلا إنترنت).
class LettersRepository {
  LettersRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String csvPath = 'assets/data/letters.csv';
  final AssetBundle _bundle;

  Future<List<Letter>> load() async {
    final raw = await _bundle.loadString(csvPath);
    return parse(raw);
  }

  /// الأعمدة: letter, name_en, word, meaning_en — الأسطر التي تبدأ بـ`#` تعليقات.
  static List<Letter> parse(String raw) {
    final rows = raw
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && !l.startsWith('#'))
        .map((l) => l.split(',').map((c) => c.trim()).toList())
        .toList();
    if (rows.isEmpty) return const [];
    final header = rows.first;
    final iLetter = header.indexOf('letter');
    final iName = header.indexOf('name_en');
    final iWord = header.indexOf('word');
    final iMeaning = header.indexOf('meaning_en');
    String at(List<String> cells, int i) =>
        (i >= 0 && i < cells.length) ? cells[i] : '';
    return [
      for (final cells in rows.skip(1))
        if (at(cells, iLetter).isNotEmpty)
          Letter(
            letter: at(cells, iLetter),
            nameEn: at(cells, iName),
            word: at(cells, iWord),
            meaningEn: at(cells, iMeaning),
          ),
    ];
  }
}
