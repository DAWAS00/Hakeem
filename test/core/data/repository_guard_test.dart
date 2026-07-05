import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/data/repository_guard.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/core/error_handling/failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  final guard = RepositoryGuard(const FailureMapper(), TalkerFlutter.init());

  test('returns Right when the action succeeds', () async {
    final result = await guard(() async => 42, context: 'test');
    expect(result.getRight().toNullable(), 42);
  });

  test('maps AuthException to Left(AuthFailure)', () async {
    final result = await guard(
      () async => throw const AuthException('bad', code: 'invalid_credentials'),
      context: 'test',
    );
    expect(result.getLeft().toNullable(), isA<AuthFailure>());
  });

  test('maps PostgrestException to Left(ServerFailure)', () async {
    final result = await guard(
      () async => throw const PostgrestException(message: 'db error', code: '23505'),
      context: 'test',
    );
    expect(result.getLeft().toNullable(), isA<ServerFailure>());
  });

  test('maps unknown errors to Left(UnexpectedFailure)', () async {
    final result = await guard(
      () async => throw Exception('weird'),
      context: 'test',
    );
    expect(result.getLeft().toNullable(), isA<UnexpectedFailure>());
  });
}
