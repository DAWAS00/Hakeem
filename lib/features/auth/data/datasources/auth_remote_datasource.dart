import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel> loginWithPhone({
    required String phone,
    required String password,
  });

  Future<UserModel> loginWithNationalId({
    required String nationalId,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  const AuthRemoteDatasourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<UserModel> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      phone: phone,
      password: password,
    );
    return _toUserModel(response);
  }

  @override
  Future<UserModel> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    // Two-step: resolve the national ID to an email via the Edge Function
    // (which never exposes this lookup to the client directly — see
    // supabase/functions/resolve-login-identifier), then sign in normally.
    final result = await _supabase.functions.invoke(
      'resolve-login-identifier',
      body: {'national_id': nationalId},
    );

    final email = (result.data as Map<String, dynamic>?)?['email'] as String?;
    if (email == null) {
      throw const AuthException('Login identifier not found', code: 'identifier_not_found');
    }

    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _toUserModel(response);
  }

  Future<UserModel> _toUserModel(AuthResponse response) async {
    final user = response.user;
    final session = response.session;
    if (user == null || session == null) {
      throw const AuthException('No session returned', code: 'session_not_found');
    }

    final profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromSupabase(user: user, session: session, profile: profile);
  }
}
