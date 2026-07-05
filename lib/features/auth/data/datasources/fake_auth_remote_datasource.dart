import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// In-memory stand-in for [AuthRemoteDatasourceImpl] — no network/Supabase
/// calls at all. Wired in via `auth_providers.dart` while the app runs
/// without a live Supabase connection; the real Supabase-backed
/// implementation is left untouched in `auth_remote_datasource.dart` for
/// when it's wired back in.
class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  const FakeAuthRemoteDatasource();

  @override
  Future<UserModel> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    return UserModel(id: 'fake-user-id', name: 'مستخدم تجريبي', phone: phone, token: 'fake-token');
  }

  @override
  Future<UserModel> loginWithNationalId({
    required String nationalId,
    required String password,
  }) async {
    return UserModel(
      id: 'fake-user-id',
      name: 'مستخدم تجريبي',
      phone: '',
      nationalId: nationalId,
      token: 'fake-token',
    );
  }
}
