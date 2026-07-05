import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/features/auth/domain/entities/signup_form_data.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/repositories/signup_repository.dart';
import 'package:hakeem/features/auth/domain/usecases/verify_signup_otp_usecase.dart';

class _FakeSignupRepository implements SignupRepository {
  _FakeSignupRepository(this.verifyResult);
  final Either<Failure, UserEntity> verifyResult;
  String? lastOtp;

  @override
  Future<Either<Failure, void>> sendOtp(SignupFormData data) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required SignupFormData data,
    required String otp,
  }) async {
    lastOtp = otp;
    return verifyResult;
  }
}

void main() {
  test('passes the otp through and returns the repository result', () async {
    const user = UserEntity(id: '1', name: 'أحمد', phone: '+962777000000', token: 't');
    final repo = _FakeSignupRepository(const Right(user));
    final useCase = VerifySignupOtpUseCase(repo);

    final result = await useCase(
      data: const SignupFormData(phone: '+962777000000'),
      otp: '123456',
    );

    expect(repo.lastOtp, '123456');
    expect(result.getRight().toNullable(), same(user));
  });

  test('propagates a Left(Failure) from the repository unchanged', () async {
    final failure = const AuthFailure(AuthFailureCode.otpInvalid, 'bad otp');
    final repo = _FakeSignupRepository(Left(failure));
    final useCase = VerifySignupOtpUseCase(repo);

    final result = await useCase(
      data: const SignupFormData(phone: '+962777000000'),
      otp: '000000',
    );

    expect(result.getLeft().toNullable(), same(failure));
  });
}
