import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/animations/spring_curve.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../painters/background_cross_painter.dart';
import '../painters/ecg_painter.dart';
import '../painters/particle_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ───────────────────────────────────────────────

  late final AnimationController _crossFadeCtrl;
  late final Animation<double> _crossFadeAnim;

  late final AnimationController _crossRotCtrl;
  late final Animation<double> _crossRotAnim;

  late final AnimationController _particleCtrl;
  late final Animation<double> _particleAnim;

  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final AnimationController _textCtrl;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineOpacity;

  late final AnimationController _badgeCtrl;
  late final Animation<double> _badgeOpacity;
  late final Animation<Offset> _badgeSlide;

  late final AnimationController _ecgCtrl;
  late final Animation<double> _ecgProgress;

  late final AnimationController _pbCtrl;
  late final Animation<double> _pbProgress;

  late final AnimationController _exitCtrl;
  late final Animation<double> _exitOpacity;

  late final List<SplashParticle> _particles;
  bool _navigated = false;

  // ── Lifecycle ─────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _buildParticles();
    _buildAnimations();
    _startSequence();
  }

  void _buildParticles() {
    const count = 12;
    _particles = List.generate(count, (i) {
      final angle = (i / count) * math.pi * 2;
      final speed = 0.82 + (i % 3) * 0.12;
      return SplashParticle(
        angle: angle,
        speed: speed,
        isGreen: i % 3 == 0,
      );
    });
  }

  void _buildAnimations() {
    _crossFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _crossFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _crossFadeCtrl, curve: Curves.easeOut),
    );

    _crossRotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _crossRotAnim = Tween<double>(
      begin: math.pi / 4,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _crossRotCtrl,
      curve: const SpringCurve(damping: 9.0, stiffness: 155.0),
    ));

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    );
    _particleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleCtrl, curve: Curves.easeOut),
    );

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const SpringCurve(damping: 10.0, stiffness: 180.0),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textCtrl,
      curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
    ));
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      ),
    );

    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOut),
    );
    _badgeSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeOut));

    _ecgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _ecgProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ecgCtrl, curve: Curves.easeInOut),
    );

    _pbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pbProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pbCtrl, curve: Curves.easeInOut),
    );

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _crossFadeCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    _crossRotCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _particleCtrl.forward();
    _logoCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _textCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    _badgeCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _ecgCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _pbCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted || _navigated) return;
    _navigated = true;
    await _exitCtrl.forward();

    if (!mounted) return;
    context.go('/login');
  }

  @override
  void dispose() {
    _crossFadeCtrl.dispose();
    _crossRotCtrl.dispose();
    _particleCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _badgeCtrl.dispose();
    _ecgCtrl.dispose();
    _pbCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: HakimColors.bgBase,
      body: FadeTransition(
        opacity: _exitOpacity,
        child: Stack(
          children: [
            // 1. Background radial glows (static)
            _BackgroundGlow(screenSize: size),

            // 2. Animated medical cross — fades in at 45°, spring-rotates to 0°
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([_crossFadeAnim, _crossRotAnim]),
                builder: (context, _) => CustomPaint(
                  painter: BackgroundCrossPainter(
                    opacity: _crossFadeAnim.value * 0.07,
                    rotation: _crossRotAnim.value,
                    color: HakimColors.primary,
                  ),
                ),
              ),
            ),

            // 3. ECG line (below center content)
            Positioned(
              bottom: size.height * 0.205,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _ecgProgress,
                builder: (context, _) => CustomPaint(
                  size: Size(size.width, 48),
                  painter: EcgPainter(
                    progress: _ecgProgress.value,
                    color: HakimColors.primary,
                    opacity: 0.38,
                  ),
                ),
              ),
            ),

            // 4. Particle burst (above cross, below logo)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleAnim,
                builder: (context, _) => CustomPaint(
                  painter: ParticlePainter(
                    progress: _particleAnim.value,
                    particles: _particles,
                    center: Offset(size.width / 2, size.height * 0.38),
                    maxRadius: size.width * 0.36,
                  ),
                ),
              ),
            ),

            // 5. Center content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo circle
                    AnimatedBuilder(
                      animation: _logoCtrl,
                      builder: (_, child) => Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      ),
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: HakimColors.bgCard,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: HakimColors.border, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x384C6A8D),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.monitor_heart_outlined,
                          size: 36,
                          color: HakimColors.accent,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // App name
                    SlideTransition(
                      position: _nameSlide,
                      child: FadeTransition(
                        opacity: _nameOpacity,
                        child: Text(
                          l10n.appTitle,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: HakimColors.accent,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Tagline
                    SlideTransition(
                      position: _taglineSlide,
                      child: FadeTransition(
                        opacity: _taglineOpacity,
                        child: Text(
                          l10n.appSlogan,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 13,
                            color: HakimColors.textSecondary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Trust badge
                    SlideTransition(
                      position: _badgeSlide,
                      child: FadeTransition(
                        opacity: _badgeOpacity,
                        child: const _TrustBadge(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 6. Bottom: progress bar + version tag
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: AnimatedBuilder(
                            animation: _pbProgress,
                            builder: (context, _) => LinearProgressIndicator(
                              value: _pbProgress.value,
                              backgroundColor:
                                  HakimColors.primary.withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  HakimColors.primary),
                              minHeight: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _badgeOpacity,
                        child: const Text(
                          'v1.0.0',
                          style: TextStyle(
                            fontSize: 11,
                            color: HakimColors.textHint,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Background radial glows (static) ─────────────────────────────

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({required this.screenSize});

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: screenSize.height * 0.18,
          left: screenSize.width * 0.5 - 120,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                HakimColors.primary.withValues(alpha: 0.13),
                HakimColors.primary.withValues(alpha: 0.0),
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: screenSize.height * 0.12,
          right: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                HakimColors.sanad.withValues(alpha: 0.06),
                HakimColors.sanad.withValues(alpha: 0.0),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Trust badge ───────────────────────────────────────────────────

class _TrustBadge extends StatelessWidget {
  const _TrustBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: HakimColors.trustBadge,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: HakimColors.border.withValues(alpha: 0.6)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 12, color: HakimColors.sanad),
          SizedBox(width: 5),
          Text(
            'خدمة حكومية رسمية · وزارة الصحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 11, color: HakimColors.textHint),
          ),
        ],
      ),
    );
  }
}
