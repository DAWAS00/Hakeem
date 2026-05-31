---
goal: Phase 3 — عائلتي as Embedded Home Screen Feature Cards (no new nav tab)
version: 2.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: DAWAS00
status: 'Completed'
tags: [feature, family, emergency-card, guardian, genetic-risk, home-screen, cards]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

**Architecture decision (v2.0):** Instead of replacing the `SettingsScreen` nav tab with a dedicated `FamilyHubScreen`, the family hub features are embedded as **cards and sections within the existing Home screen**. The bottom nav stays unchanged — Settings remains at index 4. No new tab. No wasted navigation slot.

**Nav stays:** `[ Dashboard | حكيم | Home ★ | صحتي | Settings ]`

Three feature cards are added to `HomeScreen`'s scroll view, below the existing sections:
1. **Emergency Card** — blood type + allergies + QR placeholder. Compact, always visible.
2. **Family Health Cards** — one card per linked family member showing compliance + flags.
3. **Genetic Risk Strip** — horizontal scroll of risk flag chips, tapping expands a detail sheet.

Settings stays exactly where it is. The family profile switcher in `HomeHeader` (already built) serves as the entry point for switching between family members. These new cards enrich what's visible *about* the family on the Home screen itself.

---

## 1. Requirements & Constraints

- **REQ-001**: No changes to bottom nav items, `CustomBottomNavBar`, or `MainLayoutScreen` — Settings stays at index 4.
- **REQ-002**: All three feature cards slot into `HomeScreen`'s existing `CustomScrollView` sliver list, below `MedicationScheduleCard` and `AppointmentCard` sections.
- **REQ-003**: Emergency card section renders with zero network calls — reads from `SharedPreferences` mock only.
- **REQ-004**: Genetic risk chip disclaimer (`"هذا ليس تشخيصاً"`) appears as a `showDialog` on first expansion of any flag, `barrierDismissible: false`. Shown once per device via `SharedPreferences` key `genetic_disclaimer_shown`.
- **REQ-005**: Family member cards are read-only — no edit actions in the UI.
- **REQ-006**: QR code is a styled placeholder with `"قريباً"` badge — real encrypted QR ships in Phase 8 of `feature-ai-clinical-roadmap-1.md`.
- **REQ-007**: `flutter analyze` = 0 after every phase.
- **CON-001**: `HomeScreen` already uses `CustomScrollView` with `SliverToBoxAdapter` and `SliverList` — new sections added as additional `SliverToBoxAdapter` widgets at the bottom of the sliver list, above the existing bottom padding.
- **CON-002**: `HomeState` (from `home_provider.dart`) must **not** be modified to carry family data — family hub has its own separate provider to avoid coupling.
- **CON-003**: Clean architecture — domain → data → presentation. No business logic in widget files.
- **CON-004**: Only one new package: `qr_flutter: any`. No other additions needed.
- **GUD-001**: Design tokens only — `HakimColors.*` and `HakimSpacing.*`. No hardcoded hex or pixel values.
- **GUD-002**: All new strings are Arabic-first RTL. Any new localization keys added to both `app_localizations_ar.dart` and `app_localizations_en.dart`.
- **PAT-001**: `NotifierProvider<Notifier, AsyncValue<FamilyHubData>>` — separate from `homeProvider`. Home screen watches both independently.
- **PAT-002**: `RiskLevel` is an enum: `low | moderate | high`. Never a raw string.
- **PAT-003**: Mock repository ships first — UI fully demonstrable before any backend.

---

## 2. Implementation Steps

---

### Implementation Phase 3.1 — Domain Models

- **GOAL-3.1**: Pure Dart models — no Flutter, no Riverpod. Everything the feature cards display.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-301 | Create `lib/features/family_hub/domain/models/emergency_card.dart` — fields: `bloodType: String`, `allergies: List<String>`, `chronicConditions: List<String>`, `emergencyContactName: String`, `emergencyContactPhone: String`. Add `toJson` / `fromJson`. | | |
| TASK-302 | Create `lib/features/family_hub/domain/models/family_member.dart` — fields: `id: String`, `name: String`, `relation: String`, `initials: String`, `medicationCompliancePercent: double`, `labFlags: List<String>`, `nextAppointmentDate: DateTime?`, `aiSummaryAr: String`. | | |
| TASK-303 | Create `lib/features/family_hub/domain/models/genetic_risk_flag.dart` with `enum RiskLevel { low, moderate, high }` in the same file. Fields: `condition: String`, `riskLevel: RiskLevel`, `affectedRelativesCount: int`, `explanationAr: String`, `recommendationAr: String`. | | |
| TASK-304 | Create `lib/features/family_hub/domain/models/family_hub_data.dart` — aggregate: `emergencyCard: EmergencyCard`, `members: List<FamilyMember>`, `geneticFlags: List<GeneticRiskFlag>`. | | |

**Completion criteria:** 4 files, pure Dart, no Flutter imports. `flutter analyze lib/features/family_hub/domain/` = 0.

---

### Implementation Phase 3.2 — Data Layer

- **GOAL-3.2**: Abstract interface + mock returning realistic demo data ready for Home screen consumption.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-305 | Create `lib/features/family_hub/data/repositories/family_hub_repository.dart` — abstract with one method: `Future<FamilyHubData> getFamilyHubData()`. | | |
| TASK-306 | Create `lib/features/family_hub/data/repositories/mock_family_hub_repository.dart` — returns: blood type `"A+"`, allergies `["البنسلين", "الأسبرين"]`, chronic conditions `["داء السكري من النوع 2", "ارتفاع ضغط الدم"]`, emergency contact `"محمد / 0791234567"`. Two family members: (1) أم — compliance 85%, `labFlags: ["سكر مرتفع"]`, next appt in 5 days; (2) ابن — compliance 100%, no flags. One genetic flag: T2DM, `RiskLevel.high`, 2 affected relatives. | | |
| TASK-307 | Create `lib/features/family_hub/data/providers/family_hub_providers.dart` — `final familyHubRepositoryProvider = Provider<FamilyHubRepository>((ref) => MockFamilyHubRepository())`. | | |

**Completion criteria:** `MockFamilyHubRepository().getFamilyHubData()` returns fully populated `FamilyHubData`. `flutter analyze` = 0.

---

### Implementation Phase 3.3 — State Management

- **GOAL-3.3**: Isolated Riverpod notifier. `HomeScreen` watches this alongside `homeProvider` — they never merge.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-308 | Create `lib/features/family_hub/presentation/providers/family_hub_notifier.dart`. Class `FamilyHubNotifier extends Notifier<AsyncValue<FamilyHubData>>`. `build()` calls `_load()`. `_load()`: set state to `AsyncValue.loading()`, call repository, set `AsyncValue.data(result)` or `AsyncValue.error(e, st)`. Expose `refresh()` that calls `_load()`. | | |
| TASK-309 | At bottom of same file: `final familyHubProvider = NotifierProvider<FamilyHubNotifier, AsyncValue<FamilyHubData>>(FamilyHubNotifier.new);` | | |

**Completion criteria:** Provider initializes, `state` is `AsyncValue<FamilyHubData>`. `flutter analyze` = 0.

---

### Implementation Phase 3.4 — Feature Card Widgets

- **GOAL-3.4**: Three self-contained card widgets. Each is a `StatelessWidget` or `StatefulWidget` — no Riverpod inside, data passed via constructor. This makes them testable in isolation.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-310 | Add `qr_flutter: any` to `pubspec.yaml` dependencies. Run `flutter pub get`. | | |
| TASK-311 | Create `lib/features/family_hub/presentation/widgets/emergency_card_home.dart`. A compact card (not full-screen). Sections stacked vertically inside a `Container` with rounded corners and a blue gradient header strip: (A) Header row: shield icon + "بطاقة الطوارئ" + blood type chip in red. (B) Allergies: row of small red chips. (C) Emergency contact: phone icon + name + number. (D) QR placeholder: centered 120×120 grey container with lock icon + "مشفّرة — قريباً" text beneath. Entire card has `onTap` → expands to a `showModalBottomSheet` with the full emergency details. | | |
| TASK-312 | Create `lib/features/family_hub/presentation/widgets/family_member_home_card.dart`. Horizontal scrollable row of member cards (use `SizedBox(height: 130)` + `ListView.builder` with `scrollDirection: Axis.horizontal`). Each member card: avatar circle (initials + gradient), name, relation, compliance badge (green ≥80%, amber 50–79%, red <50%), one-line AI summary. Tapping a card expands a `showModalBottomSheet` with: lab flags list, next appointment date, full AI summary + `AiDisclaimerBanner`. | | |
| TASK-313 | Create `lib/features/family_hub/presentation/widgets/genetic_risk_strip.dart`. Section header + horizontal `SingleChildScrollView` of `FilterChip`-style risk chips. Each chip: condition name + colored dot (green/amber/red) + icon. Color paired with text always (not color alone — CLN-001). Tapping a chip: (1) check `SharedPreferences` key `genetic_disclaimer_shown` — if false, show `showDialog(barrierDismissible: false)` with disclaimer text and "فهمت" button that sets the key to true; (2) after disclaimer (or if already shown), open `showModalBottomSheet` with full `GeneticRiskFlag` detail: risk badge, affected relatives count, `explanationAr`, `recommendationAr`, mandatory footer "هذا ليس تشخيصاً". | | |
| TASK-314 | Create `lib/features/family_hub/presentation/widgets/family_hub_section_header.dart` — reusable row of: icon container + section title + optional "عرض الكل" action text. Matches visual style of `HomeSectionHeader` but with a slightly different icon container style (gradient instead of flat). | | |

**Completion criteria:** All cards build with mock data passed as constructor args. Emergency card bottom sheet opens. Genetic chip disclaimer fires as non-dismissable dialog. Family horizontal scroll works. `flutter analyze` = 0.

---

### Implementation Phase 3.5 — Home Screen Integration

- **GOAL-3.5**: Wire all three cards into `HomeScreen`'s existing sliver list. No structural changes to existing sections.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-315 | In `lib/features/home/presentation/screens/home_screen.dart`: add `ref.watch(familyHubProvider)` alongside existing `ref.watch(homeProvider)`. Handle the `AsyncValue` inline: loading = skip rendering family cards (existing content still shows), error = skip silently (family section is non-critical), data = render. | | |
| TASK-316 | In the `data` branch of `homeAsync.when(...)`, add these `SliverToBoxAdapter` sections **after** the appointments section and **before** the final bottom padding `SizedBox`: (1) `HomeSectionHeader` with title `'بطاقة الطوارئ'`; (2) `EmergencyCardHome(card: familyData.emergencyCard)`; (3) `HomeSectionHeader` with title `'صحة العائلة'` + action `'إضافة فرد'`; (4) `FamilyMemberHomeCard(members: familyData.members)`; (5) `HomeSectionHeader` with title `'تنبيهات وراثية'`; (6) `GeneticRiskStrip(flags: familyData.geneticFlags)`. | | |
| TASK-317 | Wrap each family section in a `familyHubProvider.when(...)` inside the existing `homeAsync.when(data: ...)` block. Loading state: each section replaced with a `_FamilyCardShimmer()` placeholder (a `Shimmer`-colored rounded container matching the card height). Error state: omit the section silently. | | |
| TASK-318 | Create `lib/features/family_hub/presentation/widgets/family_card_shimmer.dart` — private-use shimmer placeholder. Uses `shimmer` package (already in `pubspec.yaml`). Rounded container 120px height, full width, shimmer effect matching `c.bgCard` color. | | |

**Completion criteria:** Home screen shows all 3 family sections below appointments. Shimmer appears during load. Sections are absent (not errored) if data fails. Existing Home sections unchanged. `flutter analyze` = 0.

---

## 3. Alternatives

- **ALT-001**: Dedicated nav tab (previous v1.0 plan) — rejected by user. Nav stays as-is; family content lives in Home.
- **ALT-002**: Put family cards on Dashboard screen instead of Home — rejected. Dashboard is data-dense (vitals, charts). Home is the daily-use entry point — better fit for family context cards.
- **ALT-003**: Merge family data into `homeProvider` and `HomeState` — rejected (CON-002). Coupling family data to the home data model creates a fat state object and breaks separation of concerns. Independent providers load independently.
- **ALT-004**: Full-page push screen for family details instead of bottom sheets — considered. Bottom sheets chosen for Phase 3 to keep implementation lean. Full push screens can be added in Phase 9 when guardian/family features are fully backed.
- **ALT-005**: Show shimmer for all three family sections as one unit — rejected. Each section loads the same data source so shimmer should appear per-section to feel more responsive.

---

## 4. Dependencies

- **DEP-001**: `qr_flutter: any` — QR placeholder widget in TASK-311. Add to `pubspec.yaml`.
- **DEP-002**: `shimmer: ^3.0.0` — already in `pubspec.yaml`. Used for `FamilyCardShimmer` in TASK-318.
- **DEP-003**: `shared_preferences` — already in `pubspec.yaml`. Used for `genetic_disclaimer_shown` flag in TASK-313.
- **DEP-004**: `feature-ai-clinical-roadmap-1.md` Phase 8 — real QR encryption. Placeholder QR ships now; Phase 8 wires real payload.
- **DEP-005**: `feature-ai-clinical-roadmap-1.md` Phase 9 — real guardian/family API. Mock data ships now.

---

## 5. Files

**New files (create):**
- **FILE-001**: `lib/features/family_hub/domain/models/emergency_card.dart`
- **FILE-002**: `lib/features/family_hub/domain/models/family_member.dart`
- **FILE-003**: `lib/features/family_hub/domain/models/genetic_risk_flag.dart` (includes `RiskLevel` enum)
- **FILE-004**: `lib/features/family_hub/domain/models/family_hub_data.dart`
- **FILE-005**: `lib/features/family_hub/data/repositories/family_hub_repository.dart`
- **FILE-006**: `lib/features/family_hub/data/repositories/mock_family_hub_repository.dart`
- **FILE-007**: `lib/features/family_hub/data/providers/family_hub_providers.dart`
- **FILE-008**: `lib/features/family_hub/presentation/providers/family_hub_notifier.dart`
- **FILE-009**: `lib/features/family_hub/presentation/widgets/emergency_card_home.dart`
- **FILE-010**: `lib/features/family_hub/presentation/widgets/family_member_home_card.dart`
- **FILE-011**: `lib/features/family_hub/presentation/widgets/genetic_risk_strip.dart`
- **FILE-012**: `lib/features/family_hub/presentation/widgets/family_hub_section_header.dart`
- **FILE-013**: `lib/features/family_hub/presentation/widgets/family_card_shimmer.dart`

**Modified files:**
- **FILE-014**: `pubspec.yaml` — add `qr_flutter: any` (TASK-310)
- **FILE-015**: `lib/features/home/presentation/screens/home_screen.dart` — watch `familyHubProvider`, add 3 sliver sections (TASK-315 → 317)

**Unchanged files (confirmed):**
- **FILE-016**: `lib/features/main_layout/presentation/screens/main_layout_screen.dart` — no change
- **FILE-017**: `lib/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart` — no change
- **FILE-018**: `lib/features/settings/presentation/screens/settings_screen.dart` — no change

---

## 6. Testing

- **TEST-001**: `test/features/family_hub/mock_family_hub_repository_test.dart` — `getFamilyHubData()` returns blood type `"A+"`, 2 allergies, 2 members, 1 flag `RiskLevel.high`.
- **TEST-002**: `test/features/family_hub/family_hub_notifier_test.dart` — state starts as `AsyncValue.loading()`, transitions to `AsyncValue.data(...)`.
- **TEST-003**: Widget test — `FamilyMemberHomeCard` with compliance `75.0` renders amber badge.
- **TEST-004**: Widget test — `FamilyMemberHomeCard` with compliance `95.0` renders green badge.
- **TEST-005**: Widget test — `GeneticRiskStrip` chip with `RiskLevel.high` shows red dot + warning icon + "مرتفع" text (CLN-001).
- **TEST-006**: Widget test — tapping a genetic chip triggers `showDialog` with `barrierDismissible: false` on first tap.
- **TEST-007**: Widget test — `EmergencyCardHome` renders blood type badge + 2 allergy chips without any network call.
- **TEST-008**: Widget test — `HomeScreen` with `familyHubProvider` loading shows `FamilyCardShimmer` in place of family sections.
- **TEST-009**: `flutter analyze` full project — 0 issues after all tasks complete.

---

## 7. Risks & Assumptions

- **RISK-001**: `HomeScreen` already has a long `CustomScrollView` — adding 3 more sections increases scroll length. Mitigation: sections are compact; emergency card collapses to ~150px, member row to 130px, genetic strip to ~60px. Total addition ~340px — acceptable.
- **RISK-002**: Two async providers (`homeProvider` + `familyHubProvider`) in one screen — if both fail, the screen shows two error states. Mitigation: family sections fail silently (omitted, not error-displayed). Only `homeProvider` error shows the `HomeErrorView`.
- **RISK-003**: `SharedPreferences` disclaimer flag is per-device, not per-user — if two users share a device, disclaimer shown once for both. Acceptable for Phase 3; multi-user fix deferred to Phase 9.
- **RISK-004**: Horizontal scroll for family members may feel unexpected in a vertical-scroll screen. Mitigation: add a subtle shadow on right edge to hint scrollability. If UX testing shows confusion, switch to vertical stacked cards.
- **ASSUMPTION-001**: `homeProvider` `data` branch already renders inside `homeAsync.when(data: (state) => ...)` — family sections are added within the same `data` branch. Confirmed from reading `home_screen.dart`.
- **ASSUMPTION-002**: `HomeSectionHeader` widget accepts optional `actionLabel` — confirmed from existing usage in `home_screen.dart` (`actionLabel: l10n.viewAll`).
- **ASSUMPTION-003**: `shimmer` package is already initialized and usable — confirmed it is in `pubspec.yaml`.

---

## 8. Related Specifications / Further Reading

- [`plan/feature-navigation-screen-redesign-1.md`](./feature-navigation-screen-redesign-1.md) — parent redesign plan; Phase 3 section superseded by this document (v2.0 decision: feature cards on Home, not nav tab)
- [`plan/feature-ai-clinical-roadmap-1.md`](./feature-ai-clinical-roadmap-1.md) — Phase 8 (real QR), Phase 9 (real guardian API)
- [`plan/feature-ai-assistant-implementation-1.md`](./feature-ai-assistant-implementation-1.md) — Phase 2 completed reference
- `lib/features/home/presentation/screens/home_screen.dart` — integration target
- `lib/features/home/presentation/widgets/home_section_header.dart` — reuse for section headers
- `lib/features/smart_health/` — reference for card widget patterns
- `lib/core/constants/hakim_colors.dart` — color tokens
