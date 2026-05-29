import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/home_models.dart';

class FamilyProfileNotifier extends Notifier<FamilyMember> {
  static const List<FamilyMember> members = [
    FamilyMember(id: '1', name: 'أحمد داود', relationship: 'أنا', isMe: true),
    FamilyMember(id: '2', name: 'سارة أحمد', relationship: 'الابنة'),
    FamilyMember(id: '3', name: 'محمد داود', relationship: 'الأب'),
  ];

  @override
  FamilyMember build() => members.first;

  void selectProfile(FamilyMember member) {
    state = member;
  }
}

final familyProfileProvider = NotifierProvider<FamilyProfileNotifier, FamilyMember>(
  FamilyProfileNotifier.new,
);

final availableProfilesProvider = Provider<List<FamilyMember>>((ref) {
  return FamilyProfileNotifier.members;
});
