import 'package:flutter_test/flutter_test.dart';
import 'package:hakeem/features/auth/domain/enums/login_method.dart';
import 'package:hakeem/features/auth/presentation/providers/login_state.dart';

void main() {
  group('LoginState', () {
    test('default values', () {
      const state = LoginState();
      expect(state.activeTab, LoginMethod.phone);
      expect(state.obscurePassword, true);
      expect(state.status, LoginStatus.idle);
      expect(state.errorMessage, isNull);
      expect(state.canUseBiometric, false);
      expect(state.isLoading, false);
      expect(state.hasError, false);
    });

    test('isLoading returns true when status is loading', () {
      const state = LoginState(status: LoginStatus.loading);
      expect(state.isLoading, true);
    });

    test('hasError returns true when status is failure with message', () {
      const state = LoginState(
        status: LoginStatus.failure,
        errorMessage: 'خطأ',
      );
      expect(state.hasError, true);
    });

    test('copyWith updates only specified fields', () {
      const state = LoginState();
      final updated = state.copyWith(
        activeTab: LoginMethod.nationalId,
        obscurePassword: false,
      );
      expect(updated.activeTab, LoginMethod.nationalId);
      expect(updated.obscurePassword, false);
      expect(updated.status, LoginStatus.idle);
    });

    test('copyWith clearError removes errorMessage', () {
      const state = LoginState(
        status: LoginStatus.failure,
        errorMessage: 'خطأ',
      );
      final cleared = state.copyWith(
        status: LoginStatus.idle,
        clearError: true,
      );
      expect(cleared.errorMessage, isNull);
    });
  });
}
