import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/asset_checker.dart';
import 'data/letters_repository.dart';
import 'data/progress_store.dart';
import 'screens/letters_board_screen.dart';
import 'theme/app_theme.dart';

class LisanApp extends StatelessWidget {
  LisanApp({
    super.key,
    LettersRepository? repository,
    ProgressStore? progress,
    AssetChecker? assets,
  }) : repository = repository ?? LettersRepository(),
       progress = progress ?? ProgressStore(),
       assets = assets ?? AssetChecker();

  final LettersRepository repository;
  final ProgressStore progress;
  final AssetChecker assets;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لِسان',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: LettersBoardScreen(
        repository: repository,
        progress: progress,
        assets: assets,
      ),
    );
  }
}
