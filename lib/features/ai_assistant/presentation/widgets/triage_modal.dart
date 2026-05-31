import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class TriageModal extends StatefulWidget {
  const TriageModal({super.key});

  static void show(BuildContext context) {
    final c = HakimColorScheme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const TriageModal(),
    );
  }

  @override
  State<TriageModal> createState() => _TriageModalState();
}

class _TriageModalState extends State<TriageModal> {
  int step = 0;
  final questions = [
    'ما هو العرض الرئيسي الذي تشعر به؟',
    'منذ متى بدأت هذه الأعراض؟',
    'هل تعاني من أي أمراض مزمنة؟',
  ];

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        HakimSpacing.xl,
        HakimSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + HakimSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
          Text(
            'التقييم الذكي قبل الحجز',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: HakimSpacing.md),
          Text(
            'الخطوة ${step + 1} من 3',
            style: TextStyle(fontSize: 14, color: c.primary),
          ),
          const SizedBox(height: HakimSpacing.xl),
          Text(
            questions[step],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'اكتب إجابتك هنا...',
              filled: true,
              fillColor: c.bgInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (step < 2) {
                  setState(() => step++);
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم التحليل. ننصحك بحجز موعد مع طبيب قلب.'),
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(step < 2 ? 'التالي' : 'إكمال التقييم'),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
        ],
      ),
    );
  }
}
