class LoginRequestModel {
  const LoginRequestModel({
    required this.identifier,
    required this.password,
    required this.method,
  });

  final String identifier;
  final String password;
  final String method;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'password': password,
        'method': method,
      };
}
