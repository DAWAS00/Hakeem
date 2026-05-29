import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../domain/models/settings_models.dart';

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({super.key, required this.onAdd});

  final void Function(EmergencyContact contact) onAdd;

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(
      EmergencyContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        relationship: _relationController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        HakimSpacing.lg,
        HakimSpacing.lg,
        HakimSpacing.lg,
        MediaQuery.of(context).viewInsets.bottom + HakimSpacing.xl,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.borderMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: HakimSpacing.lg),
            Text(
              'إضافة جهة طوارئ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HakimSpacing.xl),
            _buildField(
              context,
              controller: _nameController,
              label: 'الاسم الكامل',
              hint: 'محمد أحمد',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'الاسم مطلوب' : null,
            ),
            const SizedBox(height: HakimSpacing.md),
            _buildField(
              context,
              controller: _relationController,
              label: 'صلة القرابة',
              hint: 'الأب / الأم / الزوج',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'صلة القرابة مطلوبة' : null,
            ),
            const SizedBox(height: HakimSpacing.md),
            _buildField(
              context,
              controller: _phoneController,
              label: 'رقم الهاتف',
              hint: '07XXXXXXXX',
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 10) ? 'رقم هاتف غير صحيح' : null,
            ),
            const SizedBox(height: HakimSpacing.xl),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.primaryText,
                padding: const EdgeInsets.symmetric(vertical: HakimSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'إضافة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final c = HakimColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: c.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: 15, color: c.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: c.textHint),
            filled: true,
            fillColor: c.bgInput,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: c.borderFocus, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: HakimSpacing.md,
              vertical: HakimSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}
