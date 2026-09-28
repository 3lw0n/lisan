import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// يتحقّق من وجود أصل داخل الحزمة قبل استخدامه، حتى لا تنهار الشاشة
/// بخطأ `Unable to load asset` عندما لم تصل الأصول المخطَّطة بعد.
class AssetChecker {
  AssetChecker({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  Set<String>? _assets;

  Future<bool> exists(String path) async {
    if (_assets == null) {
      try {
        final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
        _assets = manifest.listAssets().toSet();
      } catch (_) {
        _assets = <String>{};
      }
    }
    final found = _assets!.contains(path);
    if (!found && kDebugMode) {
      debugPrint('[لِسان] أصل ناقص: $path');
    }
    return found;
  }
}
