import 'package:fpdart/fpdart.dart';

import '../../../../core/data/repository_guard.dart';
import '../../../../core/error_handling/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource, {required RepositoryGuard guard})
      : _guard = guard;

  final AuthRemoteDatasource _datasource;
  final RepositoryGuard _guard;

  @override
  Future<Either<Failure, UserEntity>> loginWithPhone({
    required String phone,
    required String password,
  }) {
    return _guard(
      () => _datasource.loginWithPhone(phone: phone, password: password),
      context: 'loginWithPhone',
    );
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithNationalId({
    required String nationalId,
    required String password,
  }) {
    return _guard(
      () => _datasource.loginWithNationalId(
        nationalId: nationalId,
        password: password,
      ),
      context: 'loginWithNationalId',
    );
  }
}
