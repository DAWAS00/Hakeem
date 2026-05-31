import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'حكيم'**
  String get appTitle;

  /// No description provided for @appSlogan.
  ///
  /// In ar, this message translates to:
  /// **'طبيبك الرقمي الذكي'**
  String get appSlogan;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مجدداً'**
  String get welcomeBack;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @nationalId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الوطني'**
  String get nationalId;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور؟'**
  String get forgotPassword;

  /// No description provided for @loginWithSanad.
  ///
  /// In ar, this message translates to:
  /// **'الدخول بواسطة سند'**
  String get loginWithSanad;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get dontHaveAccount;

  /// No description provided for @registerNow.
  ///
  /// In ar, this message translates to:
  /// **'سجل الآن'**
  String get registerNow;

  /// No description provided for @invalidPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صحيح'**
  String get invalidPhone;

  /// No description provided for @invalidNationalId.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الوطني غير صحيح'**
  String get invalidNationalId;

  /// No description provided for @passwordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور قصيرة جداً'**
  String get passwordTooShort;

  /// No description provided for @requiredField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get requiredField;

  /// No description provided for @signup.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get signup;

  /// No description provided for @identity.
  ///
  /// In ar, this message translates to:
  /// **'هويتك'**
  String get identity;

  /// No description provided for @contact.
  ///
  /// In ar, this message translates to:
  /// **'التواصل'**
  String get contact;

  /// No description provided for @health.
  ///
  /// In ar, this message translates to:
  /// **'الصحة'**
  String get health;

  /// No description provided for @consent.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة'**
  String get consent;

  /// No description provided for @personalInfo.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInfo;

  /// No description provided for @personalInfoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال بياناتك كما هي في وثيقة إثبات الشخصية'**
  String get personalInfoSubtitle;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'أحمد محمد الخصاونة'**
  String get fullNameHint;

  /// No description provided for @dob.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get dob;

  /// No description provided for @dobHint.
  ///
  /// In ar, this message translates to:
  /// **'اليوم / الشهر / السنة'**
  String get dobHint;

  /// No description provided for @gender.
  ///
  /// In ar, this message translates to:
  /// **'الجنس'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In ar, this message translates to:
  /// **'ذكر'**
  String get male;

  /// No description provided for @female.
  ///
  /// In ar, this message translates to:
  /// **'أنثى'**
  String get female;

  /// No description provided for @contactAndLocation.
  ///
  /// In ar, this message translates to:
  /// **'التواصل والموقع'**
  String get contactAndLocation;

  /// No description provided for @contactInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التواصل والموقع'**
  String get contactInfo;

  /// No description provided for @contactSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تحديد عنوان السكن الحالي'**
  String get contactSubtitle;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @governorate.
  ///
  /// In ar, this message translates to:
  /// **'المحافظة'**
  String get governorate;

  /// No description provided for @governorateHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر المحافظة'**
  String get governorateHint;

  /// No description provided for @city.
  ///
  /// In ar, this message translates to:
  /// **'المدينة / المنطقة'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر المدينة أو المنطقة'**
  String get cityHint;

  /// No description provided for @healthProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الصحي'**
  String get healthProfile;

  /// No description provided for @healthSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تقديم معلوماتك الصحية لتقديم رعاية أفضل'**
  String get healthSubtitle;

  /// No description provided for @bloodType.
  ///
  /// In ar, this message translates to:
  /// **'فصيلة الدم'**
  String get bloodType;

  /// No description provided for @bloodTypeHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر فصيلة الدم'**
  String get bloodTypeHint;

  /// No description provided for @chronicDiseases.
  ///
  /// In ar, this message translates to:
  /// **'الأمراض المزمنة'**
  String get chronicDiseases;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @allergies.
  ///
  /// In ar, this message translates to:
  /// **'الحساسية'**
  String get allergies;

  /// No description provided for @allergiesHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: بنسيلين، حساسية طعام، أو اكتب \"لا يوجد\"'**
  String get allergiesHint;

  /// No description provided for @heightAndWeight.
  ///
  /// In ar, this message translates to:
  /// **'الطول والوزن'**
  String get heightAndWeight;

  /// No description provided for @height.
  ///
  /// In ar, this message translates to:
  /// **'الطول (سم)'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In ar, this message translates to:
  /// **'الوزن (كجم)'**
  String get weight;

  /// No description provided for @currentMedications.
  ///
  /// In ar, this message translates to:
  /// **'الأدوية الحالية'**
  String get currentMedications;

  /// No description provided for @medicationsHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم الدواء إن وجد'**
  String get medicationsHint;

  /// No description provided for @consentAndTerms.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة والشروط'**
  String get consentAndTerms;

  /// No description provided for @consentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يرجى مراجعة البنود النهائية لإتمام عملية التسجيل الطبي'**
  String get consentSubtitle;

  /// No description provided for @acceptTerms.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على شروط الاستخدام وسياسة الخصوصية'**
  String get acceptTerms;

  /// No description provided for @acceptTermsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يتضمن ذلك معالجة بياناتك الصحية وفقاً للمعايير الطبية المعتمدة'**
  String get acceptTermsSubtitle;

  /// No description provided for @enableNotifications.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل التنبيهات والرسائل النصية'**
  String get enableNotifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استلام مواعيد الطبية والنتائج والتحديثات عبر SMS'**
  String get notificationsSubtitle;

  /// No description provided for @confirmAccuracy.
  ///
  /// In ar, this message translates to:
  /// **'أقر بصحة جميع البيانات المدخلة'**
  String get confirmAccuracy;

  /// No description provided for @accuracySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحمّل المسؤولية القانونية عن دقة المعلومات الصحية المقدمة في ملفك الطبي'**
  String get accuracySubtitle;

  /// No description provided for @finalStepInfo.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إنشاء ملفك الطبي فور الضغط على \"إتمام التسجيل\". يمكنك تعديل بياناتك لاحقاً من الإعدادات.'**
  String get finalStepInfo;

  /// No description provided for @finishRegistration.
  ///
  /// In ar, this message translates to:
  /// **'إتمام التسجيل'**
  String get finishRegistration;

  /// No description provided for @finishRegistrationError.
  ///
  /// In ar, this message translates to:
  /// **'يرجى الموافقة على الشروط وتأكيد صحة البيانات أولاً'**
  String get finishRegistrationError;

  /// No description provided for @contactUs.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بنا'**
  String get contactUs;

  /// No description provided for @rightsReserved.
  ///
  /// In ar, this message translates to:
  /// **'جميع الحقوق محفوظة لحكيم © 2024'**
  String get rightsReserved;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get previous;

  /// No description provided for @useSanad.
  ///
  /// In ar, this message translates to:
  /// **'استخدام سند'**
  String get useSanad;

  /// No description provided for @registerWithSanad.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل عبر سند'**
  String get registerWithSanad;

  /// No description provided for @sanadFillHint.
  ///
  /// In ar, this message translates to:
  /// **'يملأ بياناتك تلقائياً'**
  String get sanadFillHint;

  /// No description provided for @byContinuing.
  ///
  /// In ar, this message translates to:
  /// **'بالمتابعة، أنت توافق على '**
  String get byContinuing;

  /// No description provided for @termsOfUse.
  ///
  /// In ar, this message translates to:
  /// **'شروط الاستخدام'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicy;

  /// No description provided for @and.
  ///
  /// In ar, this message translates to:
  /// **' و '**
  String get and;

  /// No description provided for @step.
  ///
  /// In ar, this message translates to:
  /// **'خطوة'**
  String get step;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير،'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير،'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء النور،'**
  String get goodEvening;

  /// No description provided for @healthSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص صحتك اليوم'**
  String get healthSummary;

  /// No description provided for @bookAppointment.
  ///
  /// In ar, this message translates to:
  /// **'حجز موعد'**
  String get bookAppointment;

  /// No description provided for @labResults.
  ///
  /// In ar, this message translates to:
  /// **'نتائج مخبرية'**
  String get labResults;

  /// No description provided for @myMedications.
  ///
  /// In ar, this message translates to:
  /// **'أدويتي'**
  String get myMedications;

  /// No description provided for @medicalRecord.
  ///
  /// In ar, this message translates to:
  /// **'سجلي الطبي'**
  String get medicalRecord;

  /// No description provided for @medicalAssistant.
  ///
  /// In ar, this message translates to:
  /// **'المساعد الطبي'**
  String get medicalAssistant;

  /// No description provided for @nearestHospital.
  ///
  /// In ar, this message translates to:
  /// **'أقرب مستشفى'**
  String get nearestHospital;

  /// No description provided for @emergency.
  ///
  /// In ar, this message translates to:
  /// **'إسعاف فوري'**
  String get emergency;

  /// No description provided for @billing.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get billing;

  /// No description provided for @upcomingAppointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد القادمة'**
  String get upcomingAppointments;

  /// No description provided for @viewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAll;

  /// No description provided for @services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get services;

  /// No description provided for @medicationSchedule.
  ///
  /// In ar, this message translates to:
  /// **'جدول الأدوية'**
  String get medicationSchedule;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @appointments.
  ///
  /// In ar, this message translates to:
  /// **'المواعيد'**
  String get appointments;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @errorLoadingData.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل البيانات'**
  String get errorLoadingData;

  /// No description provided for @switchProfile.
  ///
  /// In ar, this message translates to:
  /// **'تبديل الملف الشخصي'**
  String get switchProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
