import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/providers/auth_providers.dart';
import '../../domain/enums/login_method.dart';
import 'login_state.dart';

final loginNotifierProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);

class LoginNotifier extends Notifier<LoginState> {
  final _localAuth = LocalAuthentication();

  @override
  LoginState build() {
    _checkBiometricSupport();
    return const LoginState();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      if (isSupported) {
        state = state.copyWith(canUseBiometric: true);
      }
    } catch (_) {}
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

    try {
      final useCase = ref.read(loginUseCaseProvider);
      await useCase(
        identifier: identifier,
        password: password,
        method: state.activeTab,
      );
      state = state.copyWith(status: LoginStatus.success);
    } on DioException catch (e) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: _mapDioError(e),
      );
    } catch (_) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
      );
    }
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

  String _mapDioError(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout =>
          'انتهت مهلة الاتصال، تحقق من اتصالك',
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
            401 => 'بيانات الدخول غير صحيحة',
            403 => 'الحساب موقوف، تواصل مع الدعم',
            _ => 'خطأ في الخادم (${e.response?.statusCode})',
          },
        _ => 'تعذر الاتصال بالخادم',
      };
}
