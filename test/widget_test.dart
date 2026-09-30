import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lisan_app/app.dart';
import 'package:lisan_app/data/asset_checker.dart';
import 'package:lisan_app/data/letter.dart';
import 'package:lisan_app/data/letters_repository.dart';
import 'package:lisan_app/data/progress_store.dart';
import 'package:lisan_app/screens/letter_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// فاحص يعتبر كل الأصول غائبة (الحالة الفعلية الآن: لا صوت ولا صورة).
class _NoAssetsChecker extends AssetChecker {
  @override
  Future<bool> exists(String path) async => false;
}

/// يشغّل التطبيق ويترك قراءة `letters.csv` الحقيقية تكتمل حتى تظهر الشبكة.
Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(LisanApp(assets: _NoAssetsChecker()));
  for (var i = 0; i < 20; i++) {
    if (find.byKey(const Key('letters_grid')).evaluate().isNotEmpty) break;
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// فاحص يعتبر موجودًا ما نمرّره له فقط (نمذجة حرف له أربعة أشكال وحرف له شكلان).
class _FormsChecker extends AssetChecker {
  _FormsChecker(this.present);
  final Set<String> present;
  @override
  Future<bool> exists(String path) async => present.contains(path);
}

/// يفتح شاشة حرف مباشرة بفاحص محدَّد.
Future<void> _pumpLetter(
  WidgetTester tester,
  Letter letter,
  AssetChecker checker,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LetterScreen(
        letter: letter,
        progress: ProgressStore(),
        assets: checker,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('ملف الحروف الفعلي: ٢٨ حرفًا بكلمات مثال ومعانٍ', (
    tester,
  ) async {
    final raw = (await tester.runAsync(
      () => rootBundle.loadString(LettersRepository.csvPath),
    ))!;
    final letters = LettersRepository.parse(raw);
    expect(letters.length, 28);
    expect(letters.first.nameEn, 'alif');
    expect(letters.last.nameEn, 'ya');
    expect(
      letters.every((l) => l.word.isNotEmpty && l.meaningEn.isNotEmpty),
      isTrue,
    );
  });

  testWidgets('حرف له أربعة أشكال: العنوان «الأشكال الأربعة»', (tester) async {
    const l = Letter(letter: 'ب', nameEn: 'ba', word: 'باب', meaningEn: 'door');
    final paths = <String>{
      l.letterPath,
      for (final f in LetterForm.values) l.formPath(f),
    };
    await _pumpLetter(tester, l, _FormsChecker(paths));
    expect(find.text('الأشكال الأربعة'), findsOneWidget);
    expect(find.text('منفصل'), findsOneWidget);
    expect(find.text('وسط'), findsOneWidget);
  });

  testWidgets('حرف لا يتصل بما بعده (ر): شكلان وعنوان صريح لا «أربعة»', (
    tester,
  ) async {
    const r = Letter(
      letter: 'ر',
      nameEn: 'ra',
      word: 'رمان',
      meaningEn: 'pomegranate',
    );
    final paths = <String>{
      r.letterPath,
      r.formPath(LetterForm.isolated),
      r.formPath(LetterForm.finalForm),
    };
    await _pumpLetter(tester, r, _FormsChecker(paths));
    expect(find.text('شكلان (لا يتصل بما بعده)'), findsOneWidget);
    expect(find.text('منفصل'), findsOneWidget);
    expect(find.text('آخر'), findsOneWidget);
    // لا نُظهر شكلين غير موجودين للحرف
    expect(find.text('أول'), findsNothing);
    expect(find.text('وسط'), findsNothing);
    expect(find.text('الأشكال الأربعة'), findsNothing);
  });

  testWidgets('الشبكة تعرض ٢٨ حرفًا في ٤ أعمدة', (tester) async {
    await _pumpApp(tester);
    final grid = tester.widget<GridView>(find.byKey(const Key('letters_grid')));
    final delegate = grid.childrenDelegate as SliverChildBuilderDelegate;
    expect(delegate.childCount, 28);
    final layout =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(layout.crossAxisCount, 4);
    expect(find.text('ا'), findsOneWidget);
  });

  testWidgets('اللمس على حرف يفتح شاشة الحرف والأصول الغائبة لا تُسقطها', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey('tile_ba')));
    await tester.pumpAndSettle();

    expect(find.byType(LetterScreen), findsOneWidget);
    expect(find.byKey(const Key('big_letter')), findsOneWidget);
    expect(find.byKey(const Key('sound_missing')), findsOneWidget);
    expect(find.text(kSoundNotAddedYet), findsOneWidget);
    expect(find.text(kNotAddedYet), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('فاحص الأصول الحقيقي: الصوت الغائب يظهر بديلًا بلا انهيار', (
    tester,
  ) async {
    const letter = Letter(letter: 'ب', nameEn: 'ba');
    await tester.pumpWidget(
      MaterialApp(
        home: LetterScreen(
          letter: letter,
          progress: ProgressStore(),
          assets: AssetChecker(),
        ),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    expect(find.text(kSoundNotAddedYet), findsOneWidget);
    expect(find.byKey(const Key('play_sound')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('التقدّم يُحفظ ويُقرأ', () async {
    final store = ProgressStore();
    expect(await store.loadCompleted(), isEmpty);
    await store.setCompleted('alif', true);
    await store.setCompleted('ba', true);
    await store.setCompleted('ba', false);
    expect(await ProgressStore().loadCompleted(), {'alif'});
  });

  testWidgets('إتمام حرف يبقى معلَّمًا بعد الرجوع إلى اللوحة', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey('tile_alif')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('toggle_completed')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.ensureVisible(find.byKey(const Key('toggle_completed')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('toggle_completed')));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    expect(await ProgressStore().loadCompleted(), contains('alif'));
    final tile = tester.widget<Material>(
      find.byKey(const ValueKey('tile_alif')),
    );
    expect(tile.color, isNot(Colors.white));
  });
}
