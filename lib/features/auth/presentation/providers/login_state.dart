import '../../domain/enums/login_method.dart';

enum LoginStatus { idle, loading, success, failure }

class LoginState {
  const LoginState({
    this.activeTab = LoginMethod.phone,
    this.obscurePassword = true,
    this.status = LoginStatus.idle,
    this.errorMessage,
    this.canUseBiometric = false,
    this.isOffline = false,
  });

  final LoginMethod activeTab;
  final bool obscurePassword;
  final LoginStatus status;
  final String? errorMessage;
  final bool canUseBiometric;
  final bool isOffline;

  bool get isLoading => status == LoginStatus.loading;
  bool get hasError => status == LoginStatus.failure && errorMessage != null;

  LoginState copyWith({
    LoginMethod? activeTab,
    bool? obscurePassword,
    LoginStatus? status,
    String? errorMessage,
    bool? canUseBiometric,
    bool? isOffline,
    bool clearError = false,
  }) {
    return LoginState(
      activeTab: activeTab ?? this.activeTab,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      canUseBiometric: canUseBiometric ?? this.canUseBiometric,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}
