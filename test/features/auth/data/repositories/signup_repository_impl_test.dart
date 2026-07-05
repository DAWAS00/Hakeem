import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/data/repository_guard.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/core/error_handling/failure_mapper.dart';
import 'package:hakeem/features/auth/data/datasources/signup_remote_datasource.dart';
import 'package:hakeem/features/auth/data/models/user_model.dart';
import 'package:hakeem/features/auth/data/repositories/signup_repository_impl.dart';
import 'package:hakeem/features/auth/domain/entities/signup_form_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class _FakeDatasource implements SignupRemoteDatasource {
  _FakeDatasource({this.verifyResult, this.throwsError});

  final UserModel? verifyResult;
  final Object? throwsError;
  bool sendOtpCalled = false;
  String? lastPhone;

  @override
  Future<void> sendOtp(String phone) async {
    sendOtpCalled = true;
    lastPhone = phone;
    if (throwsError != null) throw throwsError!;
  }

  @override
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
    required SignupFormData data,
  }) async {
    if (throwsError != null) throw throwsError!;
    return verifyResult!;
  }
}

void main() {
  final guard = RepositoryGuard(const FailureMapper(), TalkerFlutter.init());

  test('sendOtp success returns Right(null)', () async {
    final datasource = _FakeDatasource();
    final repo = SignupRepositoryImpl(datasource, guard: guard);

    final result = await repo.sendOtp(const SignupFormData(phone: '+962777000000'));

    expect(result.isRight(), isTrue);
    expect(datasource.sendOtpCalled, isTrue);
    expect(datasource.lastPhone, '+962777000000');
  });

  test('sendOtp maps AuthException to Left(AuthFailure)', () async {
    final repo = SignupRepositoryImpl(
      _FakeDatasource(
        throwsError: const AuthException('too many', code: 'over_sms_send_rate_limit'),
      ),
      guard: guard,
    );

    final result = await repo.sendOtp(const SignupFormData(phone: '+962777000000'));
    final failure = result.getLeft().toNullable();
    expect(failure, isA<AuthFailure>());
    expect((failure as AuthFailure).code, AuthFailureCode.rateLimited);
  });

  test('verifyOtp success returns Right(UserEntity)', () async {
    final user = const UserModel(id: '1', name: 'أحمد', phone: '+962777000000', token: 't');
    final repo = SignupRepositoryImpl(
      _FakeDatasource(verifyResult: user),
      guard: guard,
    );

    final result = await repo.verifyOtp(
      data: const SignupFormData(phone: '+962777000000'),
      otp: '123456',
    );

    expect(result.getRight().toNullable(), same(user));
  });

  test('verifyOtp maps unknown exception to Left(UnexpectedFailure)', () async {
    final repo = SignupRepositoryImpl(
      _FakeDatasource(throwsError: Exception('weird')),
      guard: guard,
    );

    final result = await repo.verifyOtp(
      data: const SignupFormData(phone: '+962777000000'),
      otp: '123456',
    );

    expect(result.getLeft().toNullable(), isA<UnexpectedFailure>());
  });
}
