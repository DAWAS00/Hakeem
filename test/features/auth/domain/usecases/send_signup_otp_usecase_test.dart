import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/features/auth/domain/entities/signup_form_data.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/repositories/signup_repository.dart';
import 'package:hakeem/features/auth/domain/usecases/send_signup_otp_usecase.dart';

class _FakeSignupRepository implements SignupRepository {
  _FakeSignupRepository(this.sendOtpResult);
  final Either<Failure, void> sendOtpResult;
  SignupFormData? lastData;

  @override
  Future<Either<Failure, void>> sendOtp(SignupFormData data) async {
    lastData = data;
    return sendOtpResult;
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required SignupFormData data,
    required String otp,
  }) =>
      throw UnimplementedError();
}

void main() {
  test('passes form data through to the repository and returns the result', () async {
    final repo = _FakeSignupRepository(const Right(null));
    final useCase = SendSignupOtpUseCase(repo);

    const data = SignupFormData(phone: '+962777000000');
    final result = await useCase(data);

    expect(repo.lastData, same(data));
    expect(result.isRight(), isTrue);
  });

  test('propagates a Left(Failure) from the repository unchanged', () async {
    final failure = const UnexpectedFailure('boom');
    final repo = _FakeSignupRepository(Left(failure));
    final useCase = SendSignupOtpUseCase(repo);

    final result = await useCase(const SignupFormData(phone: '+962777000000'));

    expect(result.getLeft().toNullable(), same(failure));
  });
}
