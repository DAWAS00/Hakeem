import 'package:fpdart/fpdart.dart';

import '../../../../core/error_handling/failure.dart';
import '../entities/signup_form_data.dart';
import '../repositories/signup_repository.dart';

class SendSignupOtpUseCase {
  const SendSignupOtpUseCase(this._repository);

  final SignupRepository _repository;

  Future<Either<Failure, void>> call(SignupFormData data) =>
      _repository.sendOtp(data);
}
