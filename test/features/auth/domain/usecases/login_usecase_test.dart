import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/features/auth/domain/entities/user_entity.dart';
import 'package:hakeem/features/auth/domain/enums/login_method.dart';
import 'package:hakeem/features/auth/domain/repositories/auth_repository.dart';
import 'package:hakeem/features/auth/domain/usecases/login_usecase.dart';

class _FakeAuthRepository implements AuthRepository {
  String? lastPhone;
  String? lastNationalId;

  @override
  Future<UserEntity> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    lastPhone = phone;
    return UserEntity(
      id: '1',
      name: 'أحمد',
      phone: phone,
      token: 'fake-token',
    );
  }

  @override
  Future<UserEntity> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    lastNationalId = nationalId;
    return UserEntity(
      id: '2',
      name: 'محمد',
      phone: '777000000',
      nationalId: nationalId,
      token: 'fake-token-nid',
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
    expect(result.phone, '777123456');
    expect(result.token, 'fake-token');
  });

  test('calls loginWithNationalId when method is nationalId', () async {
    final result = await useCase(
      identifier: '9123456789',
      password: 'pass123',
      method: LoginMethod.nationalId,
    );
    expect(repo.lastNationalId, '9123456789');
    expect(result.nationalId, '9123456789');
    expect(result.token, 'fake-token-nid');
  });
}
