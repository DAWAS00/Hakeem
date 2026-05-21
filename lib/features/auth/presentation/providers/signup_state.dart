import '../../domain/entities/signup_form_data.dart';

enum SignupStep { identity, contact, health, consent }

enum SignupStatus { idle, loading, success, failure }

extension SignupStepX on SignupStep {
  int get index => SignupStep.values.indexOf(this);
  int get number => index + 1;
  static const total = 4;

  bool get isFirst => this == SignupStep.identity;
  bool get isLast => this == SignupStep.consent;

  SignupStep? get next => isLast ? null : SignupStep.values[index + 1];
  SignupStep? get previous => isFirst ? null : SignupStep.values[index - 1];
}

class SignupState {
  const SignupState({
    this.currentStep = SignupStep.identity,
    this.status = SignupStatus.idle,
    this.errorMessage,
    this.formData = const SignupFormData(),
  });

  final SignupStep currentStep;
  final SignupStatus status;
  final String? errorMessage;
  final SignupFormData formData;

  bool get isLoading => status == SignupStatus.loading;
  bool get hasError => status == SignupStatus.failure && errorMessage != null;

  SignupState copyWith({
    SignupStep? currentStep,
    SignupStatus? status,
    String? errorMessage,
    SignupFormData? formData,
    bool clearError = false,
  }) {
    return SignupState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      formData: formData ?? this.formData,
    );
  }
}
