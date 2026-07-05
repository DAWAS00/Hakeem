import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/core/error_handling/failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const mapper = FailureMapper();

  group('mapAuthException', () {
    test('invalid_credentials -> AuthFailureCode.invalidCredentials', () {
      final failure = mapper.mapAuthException(
        const AuthException('bad creds', code: 'invalid_credentials'),
      );
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).code, AuthFailureCode.invalidCredentials);
    });

    test('over_request_rate_limit -> AuthFailureCode.rateLimited', () {
      final failure = mapper.mapAuthException(
        const AuthException('slow down', code: 'over_request_rate_limit'),
      );
      expect((failure as AuthFailure).code, AuthFailureCode.rateLimited);
    });

    test('unknown code -> AuthFailureCode.unknown, never throws', () {
      final failure = mapper.mapAuthException(
        const AuthException('???', code: 'something_new'),
      );
      expect((failure as AuthFailure).code, AuthFailureCode.unknown);
    });
  });

  group('mapEdgeFunctionException', () {
    test('404 -> AuthFailure.identifierNotFound, no leaked details', () {
      final failure = mapper.mapEdgeFunctionException(
        const FunctionException(status: 404),
      );
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).code, AuthFailureCode.identifierNotFound);
    });

    test('500 -> ServerFailure with status code', () {
      final failure = mapper.mapEdgeFunctionException(
        const FunctionException(status: 500, details: 'boom'),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });
  });

  group('mapPostgrestException', () {
    test('preserves the raw SQLSTATE code, not parsed as an int', () {
      final failure = mapper.mapPostgrestException(
        const PostgrestException(message: 'duplicate key', code: '23505'),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).postgresCode, '23505');
      expect(failure.statusCode, isNull);
    });
  });

  group('mapUnknown', () {
    test('non-socket error -> UnexpectedFailure, never throws', () {
      final failure = mapper.mapUnknown(Exception('weird'));
      expect(failure, isA<UnexpectedFailure>());
    });
  });
}
