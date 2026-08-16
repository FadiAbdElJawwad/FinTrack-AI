// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'FinTrack AI';

  @override
  String get splashBody => 'تتبع مالي ذكي';

  @override
  String get onboardingTitle1 => 'تتبع مالي ذكي';

  @override
  String get onboardingBody1 =>
      'قم بتوصيل حساباتك ودع AI الخاص بنا يصنف كل معاملة تلقائيًا.';

  @override
  String get onboardingTitle2 => 'رؤى مدعومة بالذكاء الاصطناعي';

  @override
  String get onboardingBody2 =>
      'امسح الفواتير واحصل على نصائح شخصية لتحسين عاداتك الإنفاقية.';

  @override
  String get onboardingTitle3 => 'قم بتنمية ثروتك';

  @override
  String get onboardingBody3 =>
      'اضبط ميزانيات ذكية وشاهد توفيرك ينمو بفضل التخطيط المالي التنبؤي.';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get email => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get signupTitle => 'إنشاء حساب';

  @override
  String get loginBody => 'سجل الدخول لإدارة محفظتك';

  @override
  String get fingerPrintLogin => 'تسجيل الدخول باستخدام بصمة الاصبع / الوجه';

  @override
  String get signupBody => 'أدخل بياناتك للبدء.';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordBody =>
      'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور';

  @override
  String get sendResetLink => 'إرسال رابط الإعادة';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get resetPasswordSuccess =>
      'إذا كان هذا البريد مسجلاً، فقد تم إرسال رابط إعادة التعيين.';

  @override
  String get fieldCannotBeEmpty => 'لا يمكن أن يكون هذا الحقل فارغًا';

  @override
  String get emptyName => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get emptyEmail => 'لا يمكن أن يكون البريد الإلكتروني فارغًا';

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get emptyPassword => 'لا يمكن أن تكون كلمة المرور فارغة';

  @override
  String get invalidPassword => 'يجب أن تكون كلمة المرور على الأقل 6 أحرف';

  @override
  String get passwordSameAsCurrent =>
      'لا يمكن أن تكون كلمة المرور الجديدة نفسها كلمة المرور الحالية';

  @override
  String get emptyConfirmPassword => 'لا يمكن أن يكون تأكيد كلمة المرور فارغًا';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور لا تتطابق';

  @override
  String get userNotFound => 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني.';

  @override
  String get wrongPassword => 'كلمة المرور غير صحيحة.';

  @override
  String get invalidCredential => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get emailAlreadyInUse => 'البريد الإلكتروني مسجل بالفعل.';

  @override
  String get invalidEmailAuth => 'عنوان البريد الإلكتروني غير صالح.';

  @override
  String get weakPasswordAuth => 'كلمة المرور ضعيفة جدًا.';

  @override
  String get userDisabled => 'تم تعطيل حساب المستخدم هذا.';

  @override
  String get tooManyRequests => 'محاولات كثيرة جدًا. يرجى المحاولة لاحقًا.';

  @override
  String get networkRequestFailed => 'خطأ في الشبكة. يرجى التحقق من اتصالك.';

  @override
  String get databaseError => 'حدث خطأ في قاعدة البيانات.';

  @override
  String get unknownError => 'حدث خطأ غير متوقع.';

  @override
  String get biometricDenied => 'تم رفض المصادقة الحيوية أو تم إلغاؤها.';

  @override
  String get noSavedCredentials =>
      'لم يتم العثور على بيانات اعتماد محفوظة. يرجى تسجيل الدخول باستخدام بريدك الإلكتروني أولاً.';

  @override
  String get enableBiometricLogin => 'تمكين تسجيل الدخول عبر البيانات الحيوية';

  @override
  String get or => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام جوجل';

  @override
  String get signInWithAnotherAccount => 'تسجيل الدخول باستخدام حساب آخر';

  @override
  String get unlock => 'إلغاء القفل';

  @override
  String get googleSignInCanceled => 'تم إلغاء تسجيل الدخول باستخدام جوجل.';
}
