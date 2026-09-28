import 'package:shared_preferences/shared_preferences.dart';

/// يحفظ الحروف المكتملة على الجهاز فقط (FR-1: بلا حساب ولا خادم).
class ProgressStore {
  static const String _key = 'completed_letters';

  Future<Set<String>> loadCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  Future<void> setCompleted(String nameEn, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final set = (prefs.getStringList(_key) ?? const <String>[]).toSet();
    if (completed) {
      set.add(nameEn);
    } else {
      set.remove(nameEn);
    }
    await prefs.setStringList(_key, set.toList()..sort());
  }
}
