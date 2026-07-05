import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error_handling/failure_localizer.dart';
import '../../../../core/telemetry/talker_provider.dart';
import '../../data/providers/auth_providers.dart';
import '../../domain/enums/login_method.dart';
import 'login_state.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  final _localAuth = LocalAuthentication();
  static const _localizer = FailureLocalizer();

  @override
  LoginState build() {
    _checkBiometricSupport();
    return const LoginState();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (!ref.mounted) return;
      if (isSupported) {
        state = state.copyWith(canUseBiometric: true);
      }
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      ref.read(talkerProvider).handle(e, stackTrace, 'Biometric support check failed');
    }
  }

  void switchTab(LoginMethod method) {
    if (state.activeTab == method) return;
    state = state.copyWith(activeTab: method, clearError: true);
  }

  void togglePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );

    if (!hasConnection) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'لا يوجد اتصال بالإنترنت',
      );
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, clearError: true);

    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(
      identifier: identifier,
      password: password,
      method: state.activeTab,
    );

    state = result.fold(
      (failure) => state.copyWith(
        status: LoginStatus.failure,
        errorMessage: _localizer.localize(failure),
      ),
      (_) => state.copyWith(status: LoginStatus.success),
    );
  }

  Future<void> loginWithBiometric() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'تسجيل الدخول ببصمتك',
        persistAcrossBackgrounding: true,
      );
      if (authenticated) {
        state = state.copyWith(status: LoginStatus.success);
      }
    } on LocalAuthException catch (e) {
      final msg = switch (e.code) {
        LocalAuthExceptionCode.noBiometricsEnrolled ||
        LocalAuthExceptionCode.noCredentialsSet =>
          'لا توجد بصمة مسجّلة على هذا الجهاز',
        LocalAuthExceptionCode.temporaryLockout ||
        LocalAuthExceptionCode.biometricLockout =>
          'الجهاز مقفل مؤقتاً بسبب محاولات كثيرة',
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled =>
          '',
        _ => 'فشل التحقق البيومتري',
      };
      if (msg.isNotEmpty) {
        state = state.copyWith(status: LoginStatus.failure, errorMessage: msg);
      }
    } catch (_) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'فشل التحقق البيومتري',
      );
    }
  }
}
