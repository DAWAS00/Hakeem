import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
    super.nationalId,
    required super.token,
  });

  /// Builds from a Supabase auth `User` + `Session` and the joined
  /// `profiles` row (see supabase/migrations/0001_profiles_and_auth.sql).
  factory UserModel.fromSupabase({
    required User user,
    required Session session,
    required Map<String, dynamic> profile,
  }) =>
      UserModel(
        id: user.id,
        name: profile['full_name'] as String? ?? '',
        phone: profile['phone'] as String? ?? user.phone ?? '',
        nationalId: profile['national_id'] as String?,
        token: session.accessToken,
      );
}
