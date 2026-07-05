import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error_handling/failure_mapper.dart';
import '../telemetry/talker_provider.dart';
import 'repository_guard.dart';

final failureMapperProvider = Provider<FailureMapper>((ref) => const FailureMapper());

final repositoryGuardProvider = Provider<RepositoryGuard>(
  (ref) => RepositoryGuard(
    ref.watch(failureMapperProvider),
    ref.watch(talkerProvider),
  ),
);
