import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/signup_providers.dart';
import '../../domain/entities/signup_form_data.dart';
import 'signup_state.dart';

final signupNotifierProvider =
    NotifierProvider<SignupNotifier, SignupState>(SignupNotifier.new);

class SignupNotifier extends Notifier<SignupState> {
  @override
  SignupState build() => const SignupState();

  void goToStep(SignupStep step) {
    state = state.copyWith(currentStep: step, clearError: true);
  }

  void nextStep() {
    final next = state.currentStep.next;
    if (next != null) state = state.copyWith(currentStep: next, clearError: true);
  }

  void previousStep() {
    final prev = state.currentStep.previous;
    if (prev != null) state = state.copyWith(currentStep: prev, clearError: true);
  }

  void updateFormData(SignupFormData data) {
    state = state.copyWith(formData: data);
  }

  Future<void> register() async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );

    if (!hasConnection) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'لا يوجد اتصال بالإنترنت',
      );
      return;
    }

    state = state.copyWith(status: SignupStatus.loading, clearError: true);

    try {
      final useCase = ref.read(registerUseCaseProvider);
      await useCase(state.formData);
      state = state.copyWith(status: SignupStatus.success);
    } on DioException catch (e) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: _mapDioError(e),
      );
    } catch (_) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
      );
    }
  }

  String _mapDioError(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout =>
          'انتهت مهلة الاتصال، تحقق من اتصالك',
        DioExceptionType.badResponse => switch (e.response?.statusCode) {
            409 => 'هذا الحساب مسجل مسبقاً',
            422 => 'تحقق من البيانات المدخلة',
            _ => 'خطأ في الخادم (${e.response?.statusCode})',
          },
        _ => 'تعذر الاتصال بالخادم',
      };
}
