import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/signup/signup_stepper_bar.dart';
import '../widgets/signup/signup_top_bar.dart';
import '../widgets/signup/steps/step_1_personal.dart';
import '../widgets/signup/steps/step_2_contact.dart';
import '../widgets/signup/steps/step_3_health.dart';
import '../widgets/signup/steps/step_4_consent.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _step = 0;

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

  void _next() {
    if (_step < 3) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _finish() {
    // TODO: submit to auth provider / repository
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              SignupTopBar(step: _step, onBack: _back),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: SignupStepperBar(currentStep: _step),
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
                    key: ValueKey(_step),
                    child: _buildStep(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Step1Personal(
          fullNameCtrl:   _fullNameCtrl,
          nationalIdCtrl: _nationalIdCtrl,
          dobCtrl:        _dobCtrl,
          phoneCtrl:      _phoneCtrl,
          gender:         _gender,
          onGenderChanged: (v) => setState(() => _gender = v),
          onNext:         _next,
        );
      case 1:
        return Step2Contact(
          emailCtrl:         _emailCtrl,
          governorate:       _governorate,
          city:              _city,
          onGovernorateChanged: (v) => setState(() => _governorate = v),
          onCityChanged:     (v) => setState(() => _city = v),
          onNext:            _next,
        );
      case 2:
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
      case 3:
        return Step4Consent(
          acceptedTerms:    _acceptedTerms,
          notificationsOn:  _notificationsOn,
          dataAccuracy:     _dataAccuracy,
          onTermsChanged:   (v) => setState(() => _acceptedTerms = v ?? false),
          onNotifChanged:   (v) => setState(() => _notificationsOn = v),
          onDataChanged:    (v) => setState(() => _dataAccuracy = v ?? false),
          onFinish:         _finish,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
