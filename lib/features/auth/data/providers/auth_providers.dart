import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repository_guard_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/fake_auth_remote_datasource.dart';
import '../repositories/auth_repository_impl.dart';

// Wired to the fake, no-network datasource while the app runs without a
// live Supabase connection — swap back to
// `AuthRemoteDatasourceImpl(ref.watch(supabaseClientProvider))` to
// reconnect (see core/network/supabase_client_provider.dart, which is left
// in place unwired for exactly this).
final authDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => const FakeAuthRemoteDatasource(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authDatasourceProvider),
    guard: ref.watch(repositoryGuardProvider),
  ),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);
