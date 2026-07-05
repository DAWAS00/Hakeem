import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/features/auth/data/providers/signup_providers.dart';
import 'package:hakeem/features/auth/domain/entities/signup_form_data.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/repositories/signup_repository.dart';
import 'package:hakeem/features/auth/presentation/providers/signup_notifier.dart';
import 'package:hakeem/features/auth/presentation/providers/signup_state.dart';

class _StubSignupRepository implements SignupRepository {
  _StubSignupRepository({this.sendOtpResult, this.verifyOtpResult});
  final Either<Failure, void>? sendOtpResult;
  final Either<Failure, UserEntity>? verifyOtpResult;

  @override
  Future<Either<Failure, void>> sendOtp(SignupFormData data) async =>
      sendOtpResult ?? const Right(null);

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required SignupFormData data,
    required String otp,
  }) async =>
      verifyOtpResult ??
      Right(const UserEntity(id: '1', name: 'أحمد', phone: '+962777000000', token: 't'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity'),
      (call) async => call.method == 'check' ? ['wifi'] : null,
    );
  });

  test('sendOtp success moves to SignupStep.otp', () async {
    final container = ProviderContainer(
      overrides: [
        signupRepositoryProvider.overrideWithValue(_StubSignupRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(signupProvider.notifier).sendOtp();

    final state = container.read(signupProvider);
    expect(state.currentStep, SignupStep.otp);
    expect(state.status, SignupStatus.idle);
  });

  test('sendOtp failure localizes the Failure into an Arabic message', () async {
    final container = ProviderContainer(
      overrides: [
        signupRepositoryProvider.overrideWithValue(
          _StubSignupRepository(
            sendOtpResult: const Left(
              AuthFailure(AuthFailureCode.rateLimited, 'slow down'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(signupProvider.notifier).sendOtp();

    final state = container.read(signupProvider);
    expect(state.status, SignupStatus.failure);
    expect(state.errorMessage, 'محاولات كثيرة، يرجى المحاولة لاحقاً');
  });

  test('verifyOtp success updates state to SignupStatus.success', () async {
    final container = ProviderContainer(
      overrides: [
        signupRepositoryProvider.overrideWithValue(_StubSignupRepository()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(signupProvider.notifier).verifyOtp('123456');

    final state = container.read(signupProvider);
    expect(state.status, SignupStatus.success);
  });

  test('verifyOtp failure localizes the Failure into an Arabic message', () async {
    final container = ProviderContainer(
      overrides: [
        signupRepositoryProvider.overrideWithValue(
          _StubSignupRepository(
            verifyOtpResult: const Left(
              AuthFailure(AuthFailureCode.otpInvalid, 'bad otp'),
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(signupProvider.notifier).verifyOtp('000000');

    final state = container.read(signupProvider);
    expect(state.status, SignupStatus.failure);
    expect(state.errorMessage, 'رمز التحقق غير صحيح أو منتهي الصلاحية');
  });
}
