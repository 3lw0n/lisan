# لِسان (Lisan)

**تطبيق أندرويد يعلّم قراءة العربية من الحرف، ويعمل بلا إنترنت وبلا حساب.**
An offline-first Flutter app that teaches Arabic letter reading from the letter up, with no account and no server.

## المزايا الحالية

- **لوحة الحروف الـ٢٨**: شبكة بأربعة أعمدة تُبنى من `assets/data/letters.csv`.
- **شاشة الحرف**: الحرف كبيرًا، وأشكاله التعليمية (منفصل · أول · وسط · آخر)، وكلمة المثال ومعناها، وزر الصوت.
- **١٣٢ صورة شكل** مولَّدة آليًّا من خط `Noto Naskh Arabic` المرخَّص (OFL 1.1) بمقياس موحّد وبلا قصّ: أربعة أشكال لـ٢٢ حرفًا، وشكلان لستة حروف (ا · د · ذ · ر · ز · و).
- **خط عربي مضمَّن** داخل التطبيق، فلا يتغيّر شكله بتغيّر خط الجهاز.
- **كلمة مثال ومعناها** لكل حرف (٢٨ صفًّا في `assets/data/letters.csv`).
- **تقدّم محفوظ على الجهاز وحده**: زر «أتممتُ هذا الحرف»، والحرف المكتمل يتلوّن في اللوحة. لا حساب ولا خادم ولا اتصال.
- **تحمّل غياب أي أصل**: الأصل المفقود يُعرض داخل إطار بديل واضح بدل أن ينهار التطبيق.
- **فحص واختبار**: `flutter test` (٨ اختبارات) و`flutter analyze` بلا ملاحظات.

> **ما ليس موجودًا بعد**: ملفات صوت الحروف (زر الصوت جاهز ويقرأ `assets/audio/letters/<الحرف>/sound.mp3` عند إضافتها)، وشاشة الكتابة، وتمارين الاستماع. لا شيء منها مذكور هنا كمنجَز.

## البنية

```
lib/
  main.dart                      نقطة الدخول
  app.dart                       التطبيق والتنقّل
  data/
    letter.dart                  نموذج الحرف وأشكاله
    letters_repository.dart      قراءة letters.csv وبناء قائمة الحروف
    progress_store.dart          حفظ التقدّم على الجهاز
    asset_checker.dart           فحص وجود الأصل قبل عرضه
  screens/
    letters_board_screen.dart    لوحة الحروف الـ٢٨
    letter_screen.dart           شاشة الحرف الواحد
  theme/app_theme.dart           الهوية البصرية (مخطوطة: ورق · ذهبي · أخضر)
  widgets/                       بطاقة الحرف وإطار الأصل المفقود
assets/
  data/letters.csv               ٢٨ حرفًا + كلمة مثال + معناها
  data/alif_family.csv           عائلة الألف (أشكال الهمزة)
  fonts/NotoNaskhArabic-Regular.ttf  الخط العربي المضمَّن + OFL.txt
  images/letters/<الحرف>/        132 صورة: letter.png + أشكال + همزات
test/widget_test.dart            ٨ اختبارات
```

## التقنية

| | |
|---|---|
| الإطار | Flutter 3.47.5 · Dart 3.13.4 |
| المنصّات | Android (minSdk 26 · SDK 36) · الويب لمعاينة التطوير |
| الاعتماديات | لا حزم خارجية وقت التشغيل، والتطبيق بلا شبكة |
| حالة الشيفرة | `flutter analyze` بلا ملاحظات · `flutter test` ٨/٨ |

## التشغيل

```bash
flutter pub get
flutter run                          # جهاز أو محاكي
flutter test && flutter analyze      # الفحص والاختبارات
flutter build apk --split-per-abi    # نسخة الإصدار لكل معمارية
flutter build web                    # معاينة على المتصفح
```

## التراخيص

- **الكود:** MIT كما في ملف `LICENSE`.
- **الخط:** Noto Naskh Arabic بترخيص SIL Open Font License 1.1 (نصّه في `assets/fonts/OFL.txt`)، وصور الحروف الـ١٣٢ مشتقة منه.
- **الشعار والأيقونات:** مولَّدة بأداة توليد الصور في ChatGPT (OpenAI)، وشروط OpenAI تنقل ملكية المخرجات إلى المستخدم.
- **البيانات:** من إعداد المؤلف، وبمساعدة لغوية بأداة ذكاء اصطناعي في كلمات المثال ومعانيها.
- لا يُضاف إلى المشروع أصل أو حزمة بلا مصدر وترخيص معروف.

## المؤلف

**Faisal Muwaffaq Alwan** · [@3lw0n](https://github.com/3lw0n)

## الرخصة

MIT، كما في ملف `LICENSE`.
