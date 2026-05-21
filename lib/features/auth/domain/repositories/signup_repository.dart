import '../entities/signup_form_data.dart';
import '../entities/user_entity.dart';

abstract interface class SignupRepository {
  Future<UserEntity> register(SignupFormData data);
}
