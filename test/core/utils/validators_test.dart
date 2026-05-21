import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/l10n/app_localizations_ar.dart';
import 'package:hakeem/core/utils/validators.dart';

void main() {
  final l10n = AppLocalizationsAr();

  group('Validators.phone', () {
    test('returns error for null', () {
      expect(Validators.phone(null, l10n), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.phone('', l10n), isNotNull);
    });

    test('returns error for short number', () {
      expect(Validators.phone('12345', l10n), isNotNull);
    });

    test('returns null for valid 9-digit number', () {
      expect(Validators.phone('777123456', l10n), isNull);
    });

    test('returns null for valid 10-digit number', () {
      expect(Validators.phone('0777123456', l10n), isNull);
    });
  });

  group('Validators.nationalId', () {
    test('returns error for null', () {
      expect(Validators.nationalId(null, l10n), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.nationalId('', l10n), isNotNull);
    });

    test('returns error for wrong length', () {
      expect(Validators.nationalId('123456789', l10n), isNotNull);
    });

    test('returns null for exactly 10 digits', () {
      expect(Validators.nationalId('9123456789', l10n), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error for null', () {
      expect(Validators.password(null, l10n), isNotNull);
    });

    test('returns error for empty string', () {
      expect(Validators.password('', l10n), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('abc', l10n), isNotNull);
    });

    test('returns null for 6+ character password', () {
      expect(Validators.password('abc123', l10n), isNull);
    });
  });
}
