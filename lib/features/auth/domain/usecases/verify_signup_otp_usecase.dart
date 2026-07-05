import 'package:fpdart/fpdart.dart';

import '../../../../core/error_handling/failure.dart';
import '../entities/signup_form_data.dart';
import '../entities/user_entity.dart';
import '../repositories/signup_repository.dart';

class VerifySignupOtpUseCase {
  const VerifySignupOtpUseCase(this._repository);

  final SignupRepository _repository;

  Future<Either<Failure, UserEntity>> call({
    required SignupFormData data,
    required String otp,
  }) =>
      _repository.verifyOtp(data: data, otp: otp);
}
