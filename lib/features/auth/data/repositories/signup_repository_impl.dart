import '../../domain/entities/signup_form_data.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/signup_repository.dart';
import '../datasources/signup_remote_datasource.dart';

class SignupRepositoryImpl implements SignupRepository {
  const SignupRepositoryImpl(this._datasource);

  final SignupRemoteDatasource _datasource;

  @override
  Future<UserEntity> register(SignupFormData data) =>
      _datasource.register(data);
}
