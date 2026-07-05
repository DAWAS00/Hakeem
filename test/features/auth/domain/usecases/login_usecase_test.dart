import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/core/error_handling/failure.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/enums/login_method.dart';
import 'package:hakeem/features/auth/domain/repositories/auth_repository.dart';
import 'package:hakeem/features/auth/domain/usecases/login_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  String? lastPhone;
  String? lastNationalId;

  @override
  Future<Either<Failure, UserEntity>> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    lastPhone = phone;
    return Right(
      UserEntity(id: '1', name: 'أحمد', phone: phone, token: 'fake-token'),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    lastNationalId = nationalId;
    return Right(
      UserEntity(
        id: '2',
        name: 'محمد',
        phone: '777000000',
        nationalId: nationalId,
        token: 'fake-token-nid',
      ),
    );
  }
}

void main() {
  late _FakeAuthRepository repo;
  late LoginUseCase useCase;

  setUp(() {
    repo = _FakeAuthRepository();
    useCase = LoginUseCase(repo);
  });

  test('calls loginWithPhone when method is phone', () async {
    final result = await useCase(
      identifier: '777123456',
      password: 'pass123',
      method: LoginMethod.phone,
    );
    expect(repo.lastPhone, '777123456');
    final user = result.getRight().toNullable();
    expect(user, isNotNull);
    expect(user!.phone, '777123456');
    expect(user.token, 'fake-token');
  });

  test('calls loginWithNationalId when method is nationalId', () async {
    final result = await useCase(
      identifier: '9123456789',
      password: 'pass123',
      method: LoginMethod.nationalId,
    );
    expect(repo.lastNationalId, '9123456789');
    final user = result.getRight().toNullable();
    expect(user, isNotNull);
    expect(user!.nationalId, '9123456789');
    expect(user.token, 'fake-token-nid');
  });

  test('propagates Left(Failure) from the repository unchanged', () async {
    final failure = const UnexpectedFailure('boom');
    final failingRepo = _FailingAuthRepository(failure);
    final failingUseCase = LoginUseCase(failingRepo);

    final result = await failingUseCase(
      identifier: '777123456',
      password: 'pass123',
      method: LoginMethod.phone,
    );

    expect(result.getLeft().toNullable(), same(failure));
  });
}

class _FailingAuthRepository implements AuthRepository {
  _FailingAuthRepository(this.failure);
  final Failure failure;

  @override
  Future<Either<Failure, UserEntity>> loginWithPhone({
    required String phone,
    required String password,
  }) async =>
      Left(failure);

  @override
  Future<Either<Failure, UserEntity>> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async =>
      Left(failure);
}
