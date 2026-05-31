import '../../domain/models/family_hub_data.dart';

abstract interface class FamilyHubRepository {
  Future<FamilyHubData> getFamilyHubData();
}
