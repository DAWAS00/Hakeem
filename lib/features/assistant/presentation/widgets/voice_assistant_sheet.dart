import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/constants/hakim_icons.dart';

enum VoiceState { listening, thinking, speaking }

class VoiceAssistantSheet extends StatefulWidget {
  const VoiceAssistantSheet({super.key});

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> {
  VoiceState _state = VoiceState.listening;
  String _message = 'أستمع إليك... تفضل بالتحدث';

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() async {
    // 1. Listening for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    setState(() {
      _state = VoiceState.thinking;
      _message = 'جاري التفكير ومعالجة طلبك...';
    });

    // 2. Thinking for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _state = VoiceState.speaking;
      _message = 'لا تقلق، بناءً على تحاليلك الأخيرة وقراءات ضغط الدم، كل شيء يسير بشكل جيد. هل تود أن أحجز لك موعداً للمتابعة؟';
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),
          
          // Animated Mascot & Waves
          Stack(
            alignment: Alignment.center,
            children: [
              if (_state != VoiceState.thinking)
                ...List.generate(3, (i) => _PulsingRing(delay: (i * 400).ms, color: c.primary)),
              
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: 300.ms,
                  child: SvgPicture.asset(
                    _getMascotIcon(_state),
                    key: ValueKey(_state),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // Status Text
          Text(
            _state == VoiceState.listening 
                ? 'جاري الاستماع' 
                : (_state == VoiceState.thinking ? 'معالجة' : 'حكيم يتحدث'),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _state == VoiceState.listening ? c.primary : c.textHint,
              letterSpacing: 1.2,
            ),
          ).animate(key: ValueKey(_state)).fadeIn().scale(),
          
          const SizedBox(height: 16),
          
          // AI Message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ).animate(key: ValueKey(_message)).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          ),
          
          const SizedBox(height: 40),
          
          // Waveform placeholder or action button
          if (_state == VoiceState.speaking)
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                elevation: 0,
              ),
              child: const Text('فهمت، شكراً لك', style: TextStyle(fontWeight: FontWeight.w700)),
            ).animate().fadeIn().scale()
          else
            const SizedBox(height: 48), // Spacer to maintain height
            
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getMascotIcon(VoiceState state) {
    switch (state) {
      case VoiceState.listening:
        return HakimIcons.mascotListening;
      case VoiceState.thinking:
        return HakimIcons.mascotThinking;
      case VoiceState.speaking:
        return HakimIcons.mascotHappy;
    }
  }
}

class _PulsingRing extends StatelessWidget {
  const _PulsingRing({required this.delay, required this.color});
  final Duration delay;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
      ),
    )
    .animate(onPlay: (c) => c.repeat())
    .scale(
      begin: const Offset(1, 1),
      end: const Offset(2.2, 2.2),
      duration: 1500.ms,
      delay: delay,
      curve: Curves.easeOut,
    )
    .fadeOut(duration: 1500.ms);
  }
}
