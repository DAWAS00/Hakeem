import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/data/repository_guard.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/core/error_handling/failure_mapper.dart';
import 'package:hakeem/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:hakeem/features/auth/data/models/user_model.dart';
import 'package:hakeem/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _FakeDatasource implements AuthRemoteDatasource {
  _FakeDatasource({this.phoneResult, this.nationalIdResult, this.throwsError});

  final UserModel? phoneResult;
  final UserModel? nationalIdResult;
  final Object? throwsError;

  @override
  Future<UserModel> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    if (throwsError != null) throw throwsError!;
    return phoneResult!;
  }

  @override
  Future<UserModel> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    if (throwsError != null) throw throwsError!;
    return nationalIdResult!;
  }
}

void main() {
  final guard = RepositoryGuard(const FailureMapper(), TalkerFlutter.init());

  test('loginWithPhone success returns Right(UserEntity)', () async {
    final user = const UserModel(id: '1', name: 'أحمد', phone: '777', token: 't');
    final repo = AuthRepositoryImpl(
      _FakeDatasource(phoneResult: user),
      guard: guard,
    );

    final result = await repo.loginWithPhone(phone: '777', password: 'x');
    expect(result.getRight().toNullable(), same(user));
  });

  test('loginWithPhone maps AuthException to Left(AuthFailure)', () async {
    final repo = AuthRepositoryImpl(
      _FakeDatasource(
        throwsError: const AuthException('bad creds', code: 'invalid_credentials'),
      ),
      guard: guard,
    );

    final result = await repo.loginWithPhone(phone: '777', password: 'x');
    final failure = result.getLeft().toNullable();
    expect(failure, isA<AuthFailure>());
    expect((failure as AuthFailure).code, AuthFailureCode.invalidCredentials);
  });

  test('loginWithNationalId success returns Right(UserEntity)', () async {
    final user = const UserModel(
      id: '2',
      name: 'محمد',
      phone: '777',
      nationalId: '999',
      token: 't2',
    );
    final repo = AuthRepositoryImpl(
      _FakeDatasource(nationalIdResult: user),
      guard: guard,
    );

    final result = await repo.loginWithNationalId(nationalId: '999', password: 'x');
    expect(result.getRight().toNullable(), same(user));
  });

  test('loginWithNationalId maps unknown exception to Left(UnexpectedFailure)', () async {
    final repo = AuthRepositoryImpl(
      _FakeDatasource(throwsError: Exception('weird')),
      guard: guard,
    );

    final result = await repo.loginWithNationalId(nationalId: '999', password: 'x');
    expect(result.getLeft().toNullable(), isA<UnexpectedFailure>());
  });
}
