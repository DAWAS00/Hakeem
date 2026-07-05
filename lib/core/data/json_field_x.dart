/// Typed accessors for `Map<String, dynamic>` JSON payloads that throw a
/// descriptive [FormatException] instead of a bare `TypeError`/`_CastError`
/// when a field is missing or the wrong shape.
///
/// A [FormatException] is caught by [RepositoryGuard]'s generic `catch`
/// clause and mapped to an [UnexpectedFailure] — so using these instead of
/// raw `as` casts in a model's `fromJson` turns a crash into a `Failure`
/// the UI can show an error for.
extension JsonFieldX on Map<String, dynamic> {
  String requireString(String key) {
    final value = this[key];
    if (value is String) return value;
    throw FormatException('Expected "$key" to be a String, got: $value');
  }

  String? optionalString(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is String) return value;
    throw FormatException('Expected "$key" to be a String or null, got: $value');
  }

  List<T> requireList<T>(String key) {
    final value = this[key];
    if (value is List) {
      try {
        return List<T>.from(value);
      } on TypeError {
        throw FormatException('Expected "$key" to be a List<$T>, got: $value');
      }
    }
    throw FormatException('Expected "$key" to be a List, got: $value');
  }
}
