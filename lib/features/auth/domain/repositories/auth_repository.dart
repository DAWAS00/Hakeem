import 'package:fpdart/fpdart.dart';

import '../../../../core/error_handling/failure.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithPhone({
    required String phone,
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithNationalId({
    required String nationalId,
    required String password,
  });
}
