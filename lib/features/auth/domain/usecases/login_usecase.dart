import '../entities/user_entity.dart';
import '../enums/login_method.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String identifier,
    required String password,
    required LoginMethod method,
  }) {
    return switch (method) {
      LoginMethod.phone => _repository.loginWithPhone(
          phone: identifier,
          password: password,
        ),
      LoginMethod.nationalId => _repository.loginWithNationalId(
          nationalId: identifier,
          password: password,
        ),
    };
  }
}
