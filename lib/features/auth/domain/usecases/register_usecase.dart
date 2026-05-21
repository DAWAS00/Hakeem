import '../entities/signup_form_data.dart';
import '../entities/user_entity.dart';
import '../repositories/signup_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final SignupRepository _repository;

  Future<UserEntity> call(SignupFormData data) => _repository.register(data);
}
