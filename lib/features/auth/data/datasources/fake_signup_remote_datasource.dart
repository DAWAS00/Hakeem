import '../../domain/entities/signup_form_data.dart';
import '../models/user_model.dart';
import 'signup_remote_datasource.dart';

/// In-memory stand-in for [SignupRemoteDatasourceImpl] — no network/Supabase
/// calls at all. Wired in via `signup_providers.dart` while the app runs
/// without a live Supabase connection; the real Supabase-backed
/// implementation is left untouched in `signup_remote_datasource.dart` for
/// when it's wired back in.
class FakeSignupRemoteDatasource implements SignupRemoteDatasource {
  const FakeSignupRemoteDatasource();

  @override
  Future<void> sendOtp(String phone) async {}

  @override
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
    required SignupFormData data,
  }) async {
    return UserModel(
      id: 'fake-user-id',
      name: data.fullName,
      phone: phone,
      nationalId: data.nationalId.isEmpty ? null : data.nationalId,
      token: 'fake-token',
    );
  }
}
