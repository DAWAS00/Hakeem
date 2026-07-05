import 'package:fpdart/fpdart.dart';

import '../../../../core/error_handling/failure.dart';
import '../entities/signup_form_data.dart';
import '../entities/user_entity.dart';

abstract interface class SignupRepository {
  /// Sends an SMS OTP to [SignupFormData.phone] to verify the phone number.
  Future<Either<Failure, void>> sendOtp(SignupFormData data);

  /// Verifies the OTP code, creating the Supabase session and writing the
  /// rest of the signup form's data into the user's `profiles` row.
  Future<Either<Failure, UserEntity>> verifyOtp({
    required SignupFormData data,
    required String otp,
  });
}
