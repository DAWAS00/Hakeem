import 'failure.dart';

/// Single place that turns a [Failure] into the Arabic message shown to users.
///
/// Replaces the per-notifier `_mapDioError`-style switch statements —
/// every feature localizes failures through this class instead of
/// duplicating its own message table.
class FailureLocalizer {
  const FailureLocalizer();

  String localize(Failure failure) {
    return switch (failure) {
      AuthFailure(:final code) => switch (code) {
          AuthFailureCode.invalidCredentials => 'بيانات الدخول غير صحيحة',
          AuthFailureCode.notConfirmed => 'الحساب غير مفعّل، يرجى تأكيد بريدك الإلكتروني',
          AuthFailureCode.rateLimited => 'محاولات كثيرة، يرجى المحاولة لاحقاً',
          AuthFailureCode.identifierNotFound => 'بيانات الدخول غير صحيحة',
          AuthFailureCode.sessionExpired => 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً',
          AuthFailureCode.otpInvalid => 'رمز التحقق غير صحيح أو منتهي الصلاحية',
          AuthFailureCode.unknown => 'فشل تسجيل الدخول',
        },
      NetworkFailure() => 'تعذر الاتصال بالخادم',
      ServerFailure(:final statusCode) =>
        statusCode == 403 ? 'الحساب موقوف، تواصل مع الدعم' : 'خطأ في الخادم${statusCode != null ? ' ($statusCode)' : ''}',
      UnexpectedFailure() => 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
    };
  }
}
