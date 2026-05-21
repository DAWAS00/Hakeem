import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<UserEntity> loginWithPhone({
    required String phone,
    required String password,
  }) =>
      _datasource.login(
        LoginRequestModel(identifier: phone, password: password, method: 'phone'),
      );

  @override
  Future<UserEntity> loginWithNationalId({
    required String nationalId,
    required String password,
  }) =>
      _datasource.login(
        LoginRequestModel(
          identifier: nationalId,
          password: password,
          method: 'national_id',
        ),
      );
}
