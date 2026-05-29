import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/providers/app_settings_provider.dart';
import '../../domain/models/settings_models.dart';
import '../providers/settings_notifier.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: c.bgBase,
      appBar: AppBar(
        backgroundColor: c.bgBase,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإعدادات',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: settingsAsync.when(
        loading: () => _buildSkeleton(c),
        error: (e, s) => _buildError(),
        data: (settings) => RefreshIndicator(
          onRefresh: () => ref.read(settingsNotifierProvider.notifier).refresh(),
          color: c.primary,
          backgroundColor: c.bgCard,
          child: _buildContent(context, c, settings),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HakimColorScheme c,
    SettingsState settings,
  ) {
    final appSettings = ref.watch(appSettingsProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return ListView(
      children: [
        // Profile header
        _ProfileHeader(profile: settings.profile)
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: -0.05, end: 0),

        // Section: Account
        const SettingsSectionHeader(title: 'الحساب'),
        _SectionCard(
          children: [
            SettingsTile(
              title: 'الاسم الكامل',
              subtitle: settings.profile.fullName,
              leading: Icon(Icons.person_outline_rounded, color: c.primary, size: 20),
            ),
            const SettingsDivider(),
            SettingsTile(
              title: 'رقم الهاتف',
              subtitle: settings.profile.phone,
              leading: Icon(Icons.phone_outlined, color: c.primary, size: 20),
            ),
            const SettingsDivider(),
            SettingsTile(
              title: 'البريد الإلكتروني',
              subtitle: settings.profile.email,
              leading: Icon(Icons.email_outlined, color: c.primary, size: 20),
            ),
            const SettingsDivider(),
            SettingsTile(
              title: 'الرقم الوطني',
              subtitle: settings.profile.maskedNationalId,
              leading: Icon(Icons.badge_outlined, color: c.primary, size: 20),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

        // Section: App
        const SettingsSectionHeader(title: 'التطبيق'),
        _SectionCard(
          children: [
            _LanguageTile(currentLocale: appSettings.locale.languageCode),
            const SettingsDivider(),
            _ThemeTile(currentTheme: appSettings.themeMode),
          ],
        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

        // Section: Notifications
        const SettingsSectionHeader(title: 'الإشعارات'),
        _SectionCard(
          children: [
            _SwitchTile(
              title: 'تذكير المواعيد',
              icon: Icons.calendar_month_outlined,
              value: settings.notifications.appointments,
              onChanged: notifier.toggleAppointmentNotif,
            ),
            const SettingsDivider(),
            _SwitchTile(
              title: 'تذكير الأدوية',
              icon: Icons.medication_outlined,
              value: settings.notifications.medications,
              onChanged: notifier.toggleMedicationNotif,
            ),
            const SettingsDivider(),
            _SwitchTile(
              title: 'نتائج المختبر',
              icon: Icons.biotech_outlined,
              value: settings.notifications.labResults,
              onChanged: notifier.toggleLabResultsNotif,
            ),
          ],
        ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

        // Section: Emergency Contacts
        const SettingsSectionHeader(title: 'جهات الطوارئ'),
        ...settings.emergencyContacts.map(
          (contact) => EmergencyContactCard(
            contact: contact,
            onDelete: () => _confirmDelete(context, contact),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: HakimSpacing.lg,
            vertical: HakimSpacing.sm,
          ),
          child: OutlinedButton.icon(
            onPressed: () => _showAddContactSheet(context),
            icon: Icon(Icons.add_rounded, color: c.primary, size: 18),
            label: Text(
              'إضافة جهة طوارئ',
              style: TextStyle(color: c.primary, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: c.borderFocus),
              padding: const EdgeInsets.symmetric(vertical: HakimSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

        // Section: About
        const SettingsSectionHeader(title: 'عن التطبيق'),
        _SectionCard(
          children: [
            SettingsTile(
              title: 'الإصدار',
              subtitle: 'v1.0.0',
              leading: Icon(Icons.info_outline_rounded, color: c.primary, size: 20),
            ),
            const SettingsDivider(),
            SettingsTile(
              title: 'شروط الاستخدام',
              leading: Icon(Icons.gavel_outlined, color: c.primary, size: 20),
              onTap: () {},
            ),
            const SettingsDivider(),
            SettingsTile(
              title: 'سياسة الخصوصية',
              leading: Icon(Icons.shield_outlined, color: c.primary, size: 20),
              onTap: () {},
            ),
          ],
        ).animate().fadeIn(duration: 300.ms, delay: 250.ms),

        const SizedBox(height: HakimSpacing.xxxl),
      ],
    );
  }

  void _showAddContactSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: HakimColorScheme.of(context).bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddContactSheet(
        onAdd: (contact) =>
            ref.read(settingsNotifierProvider.notifier).addContact(contact),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EmergencyContact contact) {
    final c = HakimColorScheme.of(context);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.bgCard,
        title: Text(
          'حذف جهة الطوارئ',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'هل تريد حذف ${contact.name}؟',
          style: TextStyle(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إلغاء', style: TextStyle(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(settingsNotifierProvider.notifier).deleteContact(contact.id);
            },
            child: Text('حذف', style: TextStyle(color: c.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(HakimColorScheme c) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(HakimSpacing.lg),
          height: 100,
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        ...List.generate(
          4,
          (_) => Container(
            margin: const EdgeInsets.symmetric(
              horizontal: HakimSpacing.lg,
              vertical: HakimSpacing.xs,
            ),
            height: 56,
            decoration: BoxDecoration(
              color: c.bgCard,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
          const SizedBox(height: HakimSpacing.md),
          const Text('حدث خطأ في تحميل الإعدادات'),
          const SizedBox(height: HakimSpacing.md),
          FilledButton(
            onPressed: () => ref.invalidate(settingsNotifierProvider),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

// ── Profile Header ───────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.all(HakimSpacing.lg),
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderCard),
      ),
      child: Row(
        children: [
          ProfileAvatar(initials: profile.initials),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.phone,
                  style: TextStyle(fontSize: 13, color: c.textSecondary),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.infoBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.maskedNationalId,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.infoText,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Card ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderCard),
      ),
      child: Column(children: children),
    );
  }
}

// ── Language Tile ─────────────────────────────────────────────
class _LanguageTile extends ConsumerWidget {
  const _LanguageTile({required this.currentLocale});

  final String currentLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.md,
      ),
      child: Row(
        children: [
          Icon(Icons.language_rounded, color: c.primary, size: 20),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Text(
              'اللغة',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
          _LangChip(
            label: 'عربي',
            selected: currentLocale == 'ar',
            onTap: () => ref.read(appSettingsProvider.notifier).setLocale(
              const Locale('ar'),
            ),
          ),
          const SizedBox(width: HakimSpacing.sm),
          _LangChip(
            label: 'English',
            selected: currentLocale == 'en',
            onTap: () => ref.read(appSettingsProvider.notifier).setLocale(
              const Locale('en'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.primary : c.bgInput,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c.primary : c.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? c.primaryText : c.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ── Theme Tile ─────────────────────────────────────────────
class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.currentTheme});

  final ThemeMode currentTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.md,
      ),
      child: Row(
        children: [
          Icon(
            currentTheme == ThemeMode.dark
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: c.primary,
            size: 20,
          ),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Text(
              'المظهر',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(appSettingsProvider.notifier).toggleTheme(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 30,
              decoration: BoxDecoration(
                color: currentTheme == ThemeMode.dark ? c.primary : c.bgInput,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: c.border),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    right: currentTheme == ThemeMode.dark ? 4 : null,
                    left: currentTheme == ThemeMode.dark ? null : 4,
                    top: 3,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: currentTheme == ThemeMode.dark
                            ? c.primaryText
                            : c.textHint,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        currentTheme == ThemeMode.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 14,
                        color: currentTheme == ThemeMode.dark
                            ? c.primary
                            : c.bgCard,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Switch Tile ────────────────────────────────────────────
class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final IconData icon;
  final bool value;
  final Future<void> Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.xs,
      ),
      child: Row(
        children: [
          Icon(icon, color: c.primary, size: 20),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: c.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: c.primary,
            activeTrackColor: c.primary.withValues(alpha: 0.3),
            inactiveThumbColor: c.textHint,
            inactiveTrackColor: c.bgInput,
          ),
        ],
      ),
    );
  }
}
