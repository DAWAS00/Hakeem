import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> loginWithPhone({
    required String phone,
    required String password,
  });

  Future<UserEntity> loginWithNationalId({
    required String nationalId,
    required String password,
  });
}
