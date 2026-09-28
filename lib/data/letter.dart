/// حرف واحد كما يُقرأ من `assets/data/letters.csv`.
class Letter {
  const Letter({
    required this.letter,
    required this.nameEn,
    this.word = '',
    this.meaningEn = '',
  });

  final String letter;
  final String nameEn;
  final String word;
  final String meaningEn;

  /// مسارات الأصول مشتقة من `name_en` حرفيًّا (حالة الأحرف مهمّة داخل APK).
  String get audioDir => 'assets/audio/letters/$nameEn/';
  String get imageDir => 'assets/images/letters/$nameEn/';
  String get soundPath => '${audioDir}sound.mp3';
  String formPath(LetterForm form) => '${imageDir}forms/${form.fileName}.png';
}

/// الأشكال الأربعة للحرف.
enum LetterForm {
  initial('initial', 'أول'),
  medial('medial', 'وسط'),
  finalForm('final', 'آخر'),
  isolated('isolated', 'منفصل');

  const LetterForm(this.fileName, this.labelAr);
  final String fileName;
  final String labelAr;
}
