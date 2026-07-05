import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error_handling/failure_localizer.dart';
import '../../data/providers/signup_providers.dart';
import '../../domain/entities/signup_form_data.dart';
import 'signup_state.dart';

part 'signup_notifier.g.dart';

@riverpod
class SignupNotifier extends _$SignupNotifier {
  static const _localizer = FailureLocalizer();

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

  Future<bool> _hasConnection() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );
  }

  /// Sends the SMS OTP for [SignupState.formData]'s phone number and, on
  /// success, advances to [SignupStep.otp].
  Future<void> sendOtp() async {
    if (!await _hasConnection()) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: 'لا يوجد اتصال بالإنترنت',
      );
      return;
    }

    state = state.copyWith(status: SignupStatus.loading, clearError: true);

    final useCase = ref.read(sendSignupOtpUseCaseProvider);
    final result = await useCase(state.formData);

    state = result.fold(
      (failure) => state.copyWith(
        status: SignupStatus.failure,
        errorMessage: _localizer.localize(failure),
      ),
      (_) => state.copyWith(
        status: SignupStatus.idle,
        currentStep: SignupStep.otp,
        clearError: true,
      ),
    );
  }

  /// Verifies the SMS OTP code and completes registration (writes the rest
  /// of the form's data to `profiles`).
  Future<void> verifyOtp(String code) async {
    state = state.copyWith(status: SignupStatus.loading, clearError: true);

    final useCase = ref.read(verifySignupOtpUseCaseProvider);
    final result = await useCase(data: state.formData, otp: code);

    state = result.fold(
      (failure) => state.copyWith(
        status: SignupStatus.failure,
        errorMessage: _localizer.localize(failure),
      ),
      (_) => state.copyWith(status: SignupStatus.success),
    );
  }
}
