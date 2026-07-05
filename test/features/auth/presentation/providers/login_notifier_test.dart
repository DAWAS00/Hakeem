import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/features/auth/data/providers/auth_providers.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/repositories/auth_repository.dart';
import 'package:hakeem/features/auth/presentation/providers/login_notifier.dart';
import 'package:hakeem/features/auth/presentation/providers/login_state.dart';

class _StubAuthRepository implements AuthRepository {
  _StubAuthRepository(this.result);
  final Either<Failure, UserEntity> result;

  @override
  Future<Either<Failure, UserEntity>> loginWithPhone({
    required String phone,
    required String password,
  }) async =>
      result;

  @override
  Future<Either<Failure, UserEntity>> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async =>
      result;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // connectivity_plus has no test-mode stub; fake the platform channel so
    // LoginNotifier.login's connectivity pre-check sees "online".
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/connectivity'),
      (call) async => call.method == 'check' ? ['wifi'] : null,
    );
  });

  test('login success updates state to LoginStatus.success', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _StubAuthRepository(
            Right(const UserEntity(id: '1', name: 'أحمد', phone: '777', token: 't')),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(loginProvider.notifier).login(
          identifier: '777',
          password: 'x',
        );

    final state = container.read(loginProvider);
    expect(state.status, LoginStatus.success);
  });

  test('login failure localizes the Failure into an Arabic message', () async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _StubAuthRepository(
            const Left(AuthFailure(AuthFailureCode.invalidCredentials, 'bad creds')),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(loginProvider.notifier).login(
          identifier: '777',
          password: 'wrong',
        );

    final state = container.read(loginProvider);
    expect(state.status, LoginStatus.failure);
    expect(state.errorMessage, 'بيانات الدخول غير صحيحة');
  });
}
