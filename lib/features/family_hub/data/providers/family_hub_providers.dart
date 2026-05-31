import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/family_hub_repository.dart';
import '../repositories/mock_family_hub_repository.dart';

final familyHubRepositoryProvider = Provider<FamilyHubRepository>(
  (ref) => const MockFamilyHubRepository(),
);
