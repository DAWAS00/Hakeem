import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/signup_form_data.dart';
import '../models/signup_profile_update.dart';
import '../models/user_model.dart';

abstract interface class SignupRemoteDatasource {
  Future<void> sendOtp(String phone);

  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
    required SignupFormData data,
  });
}

class SignupRemoteDatasourceImpl implements SignupRemoteDatasource {
  const SignupRemoteDatasourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<void> sendOtp(String phone) async {
    await _supabase.auth.signInWithOtp(phone: phone);
  }

  @override
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
    required SignupFormData data,
  }) async {
    final response = await _supabase.auth.verifyOTP(
      type: OtpType.sms,
      phone: phone,
      token: otp,
    );

    final user = response.user;
    final session = response.session;
    if (user == null || session == null) {
      throw const AuthException('No session returned', code: 'session_not_found');
    }

    // `handle_new_user` (supabase/migrations/0001_profiles_and_auth.sql)
    // already created a bare profiles row (id, phone) on auth.users insert —
    // fill in the rest of the multi-step signup form now that the phone is
    // verified and an authenticated session exists (RLS: owner-only update).
    final profile = await _supabase
        .from('profiles')
        .update(SignupProfileUpdate(data).toJson())
        .eq('id', user.id)
        .select()
        .single();

    // Best-effort: link an email so this user can later use national-ID
    // login (which resolves national ID -> email, see
    // resolve_identifier_by_national_id in the auth migration). Optional in
    // the signup form, so only attempted when provided.
    if (data.email.isNotEmpty) {
      await _supabase.auth.updateUser(UserAttributes(email: data.email));
    }

    return UserModel.fromSupabase(user: user, session: session, profile: profile);
  }
}
