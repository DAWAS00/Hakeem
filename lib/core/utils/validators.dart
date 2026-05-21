import '../l10n/app_localizations.dart';

abstract final class Validators {
  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.requiredField;
    if (value.length < 9) return l10n.invalidPhone;
    return null;
  }

  static String? nationalId(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.requiredField;
    if (value.length != 10) return l10n.invalidNationalId;
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.requiredField;
    if (value.length < 6) return l10n.passwordTooShort;
    return null;
  }

  static String? requiredText(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.requiredField;
    return null;
  }

  // Validates email only when non-empty (optional field)
  static String? emailOptional(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'البريد الإلكتروني غير صحيح';
    return null;
  }
}
