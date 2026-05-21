import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/signup_repository.dart';
import '../../domain/usecases/register_usecase.dart';
import '../datasources/signup_remote_datasource.dart';
import '../repositories/signup_repository_impl.dart';
import 'auth_providers.dart';

final signupDatasourceProvider = Provider<SignupRemoteDatasource>(
  (ref) => SignupRemoteDatasourceImpl(ref.watch(dioProvider)),
);

final signupRepositoryProvider = Provider<SignupRepository>(
  (ref) => SignupRepositoryImpl(ref.watch(signupDatasourceProvider)),
);

final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(signupRepositoryProvider)),
);
