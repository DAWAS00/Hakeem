import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/data/json_field_x.dart';

void main() {
  group('requireString', () {
    test('returns the value when present and a String', () {
      expect({'a': 'hello'}.requireString('a'), 'hello');
    });

    test('throws FormatException when missing', () {
      expect(() => <String, dynamic>{}.requireString('a'), throwsFormatException);
    });

    test('throws FormatException when wrong type', () {
      expect(() => {'a': 42}.requireString('a'), throwsFormatException);
    });
  });

  group('optionalString', () {
    test('returns null when missing', () {
      expect(<String, dynamic>{}.optionalString('a'), isNull);
    });

    test('throws FormatException when present but wrong type', () {
      expect(() => {'a': 42}.optionalString('a'), throwsFormatException);
    });
  });

  group('requireList', () {
    test('returns a typed list', () {
      expect({'a': ['x', 'y']}.requireList<String>('a'), ['x', 'y']);
    });

    test('throws FormatException when not a list', () {
      expect(() => {'a': 'not a list'}.requireList<String>('a'), throwsFormatException);
    });

    test('throws FormatException when elements are the wrong type', () {
      expect(() => {'a': [1, 2]}.requireList<String>('a'), throwsFormatException);
    });
  });
}
