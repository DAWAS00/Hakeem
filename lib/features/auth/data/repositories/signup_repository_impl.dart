import 'package:fpdart/fpdart.dart';

import '../../../../core/data/repository_guard.dart';
import '../../../../core/error_handling/failure.dart';
import '../../domain/entities/signup_form_data.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/signup_repository.dart';
import '../datasources/signup_remote_datasource.dart';

class SignupRepositoryImpl implements SignupRepository {
  const SignupRepositoryImpl(this._datasource, {required RepositoryGuard guard})
      : _guard = guard;

  final SignupRemoteDatasource _datasource;
  final RepositoryGuard _guard;

  @override
  Future<Either<Failure, void>> sendOtp(SignupFormData data) {
    return _guard(
      () => _datasource.sendOtp(data.phone),
      context: 'sendSignupOtp',
    );
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required SignupFormData data,
    required String otp,
  }) {
    return _guard(
      () => _datasource.verifyOtp(phone: data.phone, otp: otp, data: data),
      context: 'verifySignupOtp',
    );
  }
}
