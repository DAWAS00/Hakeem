import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repository_guard_provider.dart';
import '../../domain/repositories/signup_repository.dart';
import '../../domain/usecases/send_signup_otp_usecase.dart';
import '../../domain/usecases/verify_signup_otp_usecase.dart';
import '../datasources/fake_signup_remote_datasource.dart';
import '../datasources/signup_remote_datasource.dart';
import '../repositories/signup_repository_impl.dart';

// Wired to the fake, no-network datasource while the app runs without a
// live Supabase connection — swap back to
// `SignupRemoteDatasourceImpl(ref.watch(supabaseClientProvider))` to
// reconnect (see core/network/supabase_client_provider.dart, which is left
// in place unwired for exactly this).
final signupDatasourceProvider = Provider<SignupRemoteDatasource>(
  (ref) => const FakeSignupRemoteDatasource(),
);

final signupRepositoryProvider = Provider<SignupRepository>(
  (ref) => SignupRepositoryImpl(
    ref.watch(signupDatasourceProvider),
    guard: ref.watch(repositoryGuardProvider),
  ),
);

final sendSignupOtpUseCaseProvider = Provider<SendSignupOtpUseCase>(
  (ref) => SendSignupOtpUseCase(ref.watch(signupRepositoryProvider)),
);

final verifySignupOtpUseCaseProvider = Provider<VerifySignupOtpUseCase>(
  (ref) => VerifySignupOtpUseCase(ref.watch(signupRepositoryProvider)),
);
