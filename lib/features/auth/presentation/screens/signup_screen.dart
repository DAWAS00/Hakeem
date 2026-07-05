import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/signup_notifier.dart';
import '../providers/signup_state.dart';
import '../widgets/error_banner.dart';
import '../widgets/signup/signup_stepper_bar.dart';
import '../widgets/signup/signup_top_bar.dart';
import '../widgets/signup/steps/step_1_personal.dart';
import '../widgets/signup/steps/step_2_contact.dart';
import '../widgets/signup/steps/step_3_health.dart';
import '../widgets/signup/steps/step_4_consent.dart';
import '../widgets/signup/steps/step_5_otp.dart';
import '../../domain/entities/signup_form_data.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // Step 1 data
  final _fullNameCtrl    = TextEditingController();
  final _nationalIdCtrl  = TextEditingController();
  final _dobCtrl         = TextEditingController();
  final _phoneCtrl       = TextEditingController();
  String? _gender;

  // Step 2 data
  final _emailCtrl       = TextEditingController();
  String? _governorate;
  String? _city;

  // Step 3 data
  String? _bloodType;
  final List<String> _chronicDiseases = [];
  final _allergiesCtrl    = TextEditingController();
  final _heightCtrl       = TextEditingController();
  final _weightCtrl       = TextEditingController();
  final _medicationsCtrl  = TextEditingController();

  // Step 4 data
  bool _acceptedTerms     = false;
  bool _notificationsOn   = true;
  bool _dataAccuracy      = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _nationalIdCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _allergiesCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _medicationsCtrl.dispose();
    super.dispose();
  }

  void _next() => ref.read(signupProvider.notifier).nextStep();

  void _back() {
    final currentStep = ref.read(signupProvider).currentStep;
    if (currentStep != SignupStep.identity) {
      ref.read(signupProvider.notifier).previousStep();
    } else {
      context.pop();
    }
  }

  DateTime? _parseDob() {
    final parts = _dobCtrl.text.split('/').map((p) => p.trim()).toList();
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  SignupFormData _buildFormData() => SignupFormData(
        fullName: _fullNameCtrl.text.trim(),
        dateOfBirth: _parseDob(),
        gender: _gender ?? '',
        nationalId: _nationalIdCtrl.text.trim(),
        phone: '+962${_phoneCtrl.text.trim()}',
        email: _emailCtrl.text.trim(),
        governorate: _governorate ?? '',
        city: _city ?? '',
        bloodType: _bloodType ?? '',
        chronicDiseases: List.of(_chronicDiseases),
        allergies: _allergiesCtrl.text.trim(),
        height: int.tryParse(_heightCtrl.text),
        weight: int.tryParse(_weightCtrl.text),
        currentMedications: _medicationsCtrl.text.trim(),
        acceptTerms: _acceptedTerms,
        enableNotifications: _notificationsOn,
        confirmAccuracy: _dataAccuracy,
      );

  void _finish() {
    final notifier = ref.read(signupProvider.notifier);
    notifier.updateFormData(_buildFormData());
    notifier.sendOtp();
  }

  void _resendOtp() => ref.read(signupProvider.notifier).sendOtp();

  void _verifyOtp(String code) =>
      ref.read(signupProvider.notifier).verifyOtp(code);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(signupProvider);

    ref.listen<SignupState>(signupProvider, (_, next) {
      if (next.status == SignupStatus.success) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: SafeArea(
          child: Column(
            children: [
              SignupTopBar(step: state.currentStep.index, onBack: _back),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: SignupStepperBar(currentStep: state.currentStep.index),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: ErrorBanner(message: state.errorMessage!),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.04, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(state.currentStep),
                    child: _buildStep(state),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(SignupState state) {
    switch (state.currentStep) {
      case SignupStep.identity:
        return Step1Personal(
          fullNameCtrl:   _fullNameCtrl,
          nationalIdCtrl: _nationalIdCtrl,
          dobCtrl:        _dobCtrl,
          phoneCtrl:      _phoneCtrl,
          gender:         _gender,
          onGenderChanged: (v) => setState(() => _gender = v),
          onNext:         _next,
        );
      case SignupStep.contact:
        return Step2Contact(
          emailCtrl:         _emailCtrl,
          governorate:       _governorate,
          city:              _city,
          onGovernorateChanged: (v) => setState(() => _governorate = v),
          onCityChanged:     (v) => setState(() => _city = v),
          onNext:            _next,
        );
      case SignupStep.health:
        return Step3Health(
          bloodType:          _bloodType,
          chronicDiseases:    _chronicDiseases,
          allergiesCtrl:      _allergiesCtrl,
          heightCtrl:         _heightCtrl,
          weightCtrl:         _weightCtrl,
          medicationsCtrl:    _medicationsCtrl,
          onBloodTypeChanged: (v) => setState(() => _bloodType = v),
          onDiseaseToggled:   (v) => setState(() {
            _chronicDiseases.contains(v)
                ? _chronicDiseases.remove(v)
                : _chronicDiseases.add(v);
          }),
          onNext: _next,
        );
      case SignupStep.consent:
        return Step4Consent(
          acceptedTerms:    _acceptedTerms,
          notificationsOn:  _notificationsOn,
          dataAccuracy:     _dataAccuracy,
          onTermsChanged:   (v) => setState(() => _acceptedTerms = v ?? false),
          onNotifChanged:   (v) => setState(() => _notificationsOn = v),
          onDataChanged:    (v) => setState(() => _dataAccuracy = v ?? false),
          onFinish:         _finish,
        );
      case SignupStep.otp:
        return Step5Otp(
          isLoading: state.isLoading,
          onVerify:  _verifyOtp,
          onResend:  _resendOtp,
        );
    }
  }
}
