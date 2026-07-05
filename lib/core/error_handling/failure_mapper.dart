import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failure.dart';

/// Converts Supabase/platform exceptions into typed [Failure]s.
///
/// This is the single place that understands Supabase's exception shapes —
/// repositories should never inspect `AuthException`/`PostgrestException`
/// directly, they should call these mappers inside their catch blocks.
class FailureMapper {
  const FailureMapper();

  Failure mapAuthException(AuthException e) {
    final code = switch (e.code) {
      'invalid_credentials' => AuthFailureCode.invalidCredentials,
      'email_not_confirmed' => AuthFailureCode.notConfirmed,
      'over_request_rate_limit' ||
      'over_email_send_rate_limit' ||
      'over_sms_send_rate_limit' =>
        AuthFailureCode.rateLimited,
      'session_not_found' || 'refresh_token_not_found' =>
        AuthFailureCode.sessionExpired,
      'otp_expired' || 'otp_disabled' => AuthFailureCode.otpInvalid,
      _ => AuthFailureCode.unknown,
    };
    return AuthFailure(code, e.message, debugDetails: e);
  }

  Failure mapPostgrestException(PostgrestException e) {
    return ServerFailure(
      e.message,
      postgresCode: e.code,
      debugDetails: e,
    );
  }

  Failure mapEdgeFunctionException(FunctionException e) {
    if (e.status == 404) {
      return const AuthFailure(
        AuthFailureCode.identifierNotFound,
        'Login identifier not found',
      );
    }
    return ServerFailure(
      e.details?.toString() ?? 'Edge function error',
      statusCode: e.status,
      debugDetails: e,
    );
  }

  Failure mapUnknown(Object error, {StackTrace? stackTrace}) {
    if (error is SocketException) {
      return NetworkFailure(error.message, debugDetails: error);
    }
    return UnexpectedFailure(error.toString(), debugDetails: stackTrace);
  }
}
