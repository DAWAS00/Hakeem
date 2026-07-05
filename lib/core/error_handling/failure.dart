/// Base type returned by repositories/use cases instead of throwing.
///
/// Every cross-layer error surface in the app returns `Either<Failure, T>`
/// (fpdart) so presentation code never needs to catch a raw exception.
sealed class Failure {
  const Failure(this.message, {this.debugDetails});

  /// Raw, non-localized message (English/technical) — for logging only.
  /// UI code must go through `FailureLocalizer`, never display this directly.
  final String message;

  /// Optional extra context for Talker logs (stack info, response bodies).
  final Object? debugDetails;
}

enum AuthFailureCode {
  invalidCredentials,
  notConfirmed,
  rateLimited,
  identifierNotFound,
  sessionExpired,
  otpInvalid,
  unknown,
}

class AuthFailure extends Failure {
  const AuthFailure(this.code, super.message, {super.debugDetails});

  final AuthFailureCode code;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.debugDetails});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, this.postgresCode, super.debugDetails});

  /// HTTP status code, when the error came from an Edge Function response.
  final int? statusCode;

  /// Raw Postgres SQLSTATE (e.g. `'23505'`), when the error came from a
  /// [PostgrestException] — these are not HTTP status codes and must not be
  /// parsed as `int`.
  final String? postgresCode;
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.debugDetails});
}
