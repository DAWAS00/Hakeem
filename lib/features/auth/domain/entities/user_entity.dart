class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.nationalId,
    required this.token,
  });

  final String id;
  final String name;
  final String phone;
  final String? nationalId;
  final String token;
}
