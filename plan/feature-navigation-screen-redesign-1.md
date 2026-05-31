---
goal: Replace Three Bottom Nav Screens with High-Value AI-Powered Alternatives
version: 1.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: DAWAS00
status: 'Planned'
tags: [feature, navigation, ux, ai, redesign, screens]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

The current bottom navigation has three screens that provide low daily utility: **RecordsScreen** (passive file list), **AppointmentsScreen** (mostly empty, hardcoded triage), and **SettingsScreen** (set once, never revisited). This plan replaces all three with AI-powered screens that users open every day. Settings moves to a gear icon inside the Home header. Appointment booking is preserved as a chip inside the new AI Assistant screen. No existing functionality is removed — only elevated and reorganized.

**Current nav:** `Dashboard | Appointments | Home | Records | Settings`
**Proposed nav:** `Dashboard | صحتي | Home ★ | حكيم AI | عائلتي`

---

## 1. Requirements & Constraints

- **REQ-001**: All three existing screens' core functionality must remain accessible — no feature is deleted, only relocated.
- **REQ-002**: Settings moves to a gear icon `⚙` reachable from the Home screen header (profile avatar tap or icon button). All current settings options preserved.
- **REQ-003**: Appointment booking remains accessible via an action chip inside the AI Assistant screen (`"احجز موعداً"`).
- **REQ-004**: All new screens must be Arabic-first, RTL, and use existing `HakimColors.*` and `HakimSpacing.*` tokens only.
- **REQ-005**: Each new screen must be independently useful with zero network (cached data + offline fallback state).
- **REQ-006**: AI-generated content on all screens must show `AiDisclaimerBanner` ("اقتراح الذكاء الاصطناعي — لم يؤكده الطبيب بعد") until doctor-confirmed.
- **CON-001**: AI features in Phases 4, 5, 6, 7, 8, 9 from `feature-ai-clinical-roadmap-1.md` are the data sources for these screens. Screens use mock data until those phases ship.
- **CON-002**: Bottom nav remains 5 items — no structural change to `CustomBottomNavBar` or `MainLayoutScreen` PageView beyond swapping screen widgets.
- **CON-003**: `flutter analyze` must report 0 issues after each screen is implemented.
- **GUD-001**: Clean architecture pattern — domain → data → presentation. No business logic in screen widgets.
- **GUD-002**: Each screen is a `ConsumerStatefulWidget` with `AutomaticKeepAliveClientMixin` (PageView caching).
- **PAT-001**: Mock repositories ship with each screen so the UI is demonstrable before backend is ready.

---

## 2. Implementation Steps

---

### Implementation Phase 1 — "صحتي" Smart Health Hub (replaces RecordsScreen)

- **GOAL-001**: Replace the passive medical records list with an active health intelligence screen. Users check it daily to understand their lab results, track symptoms, and read AI-simplified health summaries.

**Screen location:** `lib/features/smart_health/presentation/screens/smart_health_screen.dart`
**Nav position:** Index 3 (was RecordsScreen)
**Nav label:** صحتي | **Nav icon:** `Icons.favorite_rounded`

#### What the screen contains (top to bottom):

**Section A — AI Weekly Health Summary Card**
- One-sentence plain Arabic summary: e.g. "نتائجك هذا الأسبوع جيدة بشكل عام — فقط قراءة السكر تحتاج متابعة"
- Shows `AiDisclaimerBanner` until doctor confirms
- Tapping expands to full AI analysis

**Section B — Symptom Check-In Button**
- Prominent card: "كيف تشعر اليوم؟" with mic icon
- Opens `DiaryCheckinSheet` (conversational NLP check-in from Phase 6)
- Shows last check-in date: "آخر تسجيل: قبل 3 أيام"

**Section C — Lab Results with AI Flags**
- Replaces the current static list from `RecordsScreen`
- Each lab tile: value + unit + color-coded status (green/amber/red) + text label (not color alone)
- Trend arrow vs previous result (↑↓→)
- Tapping a tile opens `LabDetailSheet` with AI plain-language explanation
- Critical values show persistent red badge — not dismissable

**Section D — Doctor Notes with Simplified Toggle**
- Toggle chip: "ملاحظات الطبيب" ↔ "شرح مبسّط"
- Simplified view uses Phase 5 NLP output
- Medical terms underlined → tap → `MedicalTermTooltip` bottom sheet

**Section E — Prescriptions & Imaging (preserved from RecordsScreen)**
- Collapsed accordion sections
- Share button preserved (`_showSecureShare` logic migrated)

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | Create `lib/features/smart_health/` directory with domain/data/presentation structure | | |
| TASK-002 | Create `lib/features/smart_health/domain/models/health_summary.dart` — fields: `weekSummaryAr`, `weekSummaryEn`, `isConfirmed`, `riskLevel`, `labFlags: List<LabFlag>` | | |
| TASK-003 | Create `lib/features/smart_health/data/repositories/mock_smart_health_repository.dart` — returns hardcoded `HealthSummary` with 2 abnormal lab values and 1 simplified doctor note | | |
| TASK-004 | Create `lib/features/smart_health/presentation/providers/smart_health_provider.dart` — `NotifierProvider<SmartHealthNotifier, SmartHealthState>` | | |
| TASK-005 | Create `lib/features/smart_health/presentation/widgets/health_summary_ai_card.dart` — Section A. Shows `AiDisclaimerBanner`. Expandable. | | |
| TASK-006 | Create `lib/features/smart_health/presentation/widgets/symptom_checkin_card.dart` — Section B. "كيف تشعر اليوم؟" card with mic icon. Taps opens diary sheet. | | |
| TASK-007 | Create `lib/features/smart_health/presentation/widgets/lab_result_tile.dart` — Section C. Value + trend arrow + color+icon+text status. Abnormal badge. Tap → detail sheet. | | |
| TASK-008 | Create `lib/features/smart_health/presentation/widgets/doctor_notes_card.dart` — Section D. Toggle chip. Simplified view with tappable underlined medical terms. | | |
| TASK-009 | Migrate `_buildRecordTile` and `_showSecureShare` logic from `RecordsScreen` into `lib/features/smart_health/presentation/widgets/record_tile.dart` — Section E. | | |
| TASK-010 | Create `lib/features/smart_health/presentation/screens/smart_health_screen.dart` — assembles all sections in a `CustomScrollView` with `SliverList`. `AutomaticKeepAliveClientMixin`. | | |
| TASK-011 | Swap `RecordsScreen()` → `SmartHealthScreen()` in `MainLayoutScreen` PageView children list (index 3). | | |
| TASK-012 | Update `CustomBottomNavBar.items` — change index 3 icon to `Icons.favorite_rounded`, label to `'صحتي'`. | | |

**Completion criteria:** Screen renders with mock data showing 2 flagged lab values (color + icon + text), AI summary card with disclaimer, toggle between raw/simplified doctor notes. `flutter analyze` = 0 issues.

---

### Implementation Phase 2 — "حكيم AI" Assistant Screen (replaces AppointmentsScreen)

- **GOAL-002**: Replace the mostly-empty appointments list with a conversational AI assistant that patients use daily. Appointment booking is preserved as a suggested action chip inside the assistant. Elderly-friendly design: large text, voice-first.

**Screen location:** `lib/features/ai_assistant/presentation/screens/ai_assistant_screen.dart`
**Nav position:** Index 1 (was AppointmentsScreen)
**Nav label:** حكيم | **Nav icon:** `Icons.auto_awesome_rounded`

#### What the screen contains:

**Header**
- Title: "حكيم — مساعدك الصحي" with subtle AI shimmer animation
- Subtitle: "اسألني أي شيء عن صحتك"

**Section A — Suggested Action Chips (scrollable horizontal row)**
Chips that pre-fill the assistant:
- `"متى موعدي القادم؟"` → answers from appointment data
- `"متى آخذ دوائي؟"` → answers from medication schedule
- `"ماذا تعني نتيجة السكر؟"` → explains last lab result
- `"احجز موعداً"` → opens the existing triage modal from `AppointmentsScreen` (migrated, not deleted)
- `"كيف آخذ دوائي؟"` → medication instructions from prescription

**Section B — Chat History**
- Bubble UI, RTL. User bubbles right-aligned, Hakeem bubbles left-aligned.
- Each Hakeem response shows source tag: `[من مواعيدك]` / `[من دوائك]` / `[من نتائجك]`
- Safety guardrail footer on symptom responses: "للأعراض الطبية راجع طبيبك دائماً 🏥"

**Section C — Input Row**
- Text field: "اكتب سؤالك..."
- Mic button (voice input via `speech_to_text`) — large, 56px, for elderly
- Send button

**Elderly Mode** (toggled in settings):
- Font size bumped +4sp
- Input row height 64px
- Chips larger: 48px height
- Assistant speaks response aloud (TTS)

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-013 | Migrate `_showTriageModal()` from `AppointmentsScreen` into `lib/features/ai_assistant/presentation/widgets/triage_modal.dart` — standalone widget, callable from chip tap | | |
| TASK-014 | Create `lib/features/ai_assistant/domain/models/chat_message.dart` — `role: MessageRole`, `content`, `timestamp`, `sourceTag: String?`, `isVoiceInput: bool` (may already exist — check `lib/features/assistant/`) | | |
| TASK-015 | Create `lib/features/ai_assistant/domain/repositories/assistant_repository.dart` — abstract: `sendMessage(String query, PatientContext context)` → `Stream<String>` (streamed response) | | |
| TASK-016 | Create `lib/features/ai_assistant/data/repositories/mock_assistant_repository.dart` — returns hardcoded streamed responses for the 5 chip queries. No real API call yet. | | |
| TASK-017 | Create `lib/features/ai_assistant/presentation/providers/assistant_provider.dart` — manages chat history list, loading state, voice input state | | |
| TASK-018 | Create `lib/features/ai_assistant/presentation/widgets/suggestion_chips_row.dart` — horizontal `SingleChildScrollView` of `ActionChip` widgets. Chip tap calls `notifier.sendMessage(chipText)`. | | |
| TASK-019 | Create `lib/features/ai_assistant/presentation/widgets/chat_bubble.dart` — user vs assistant styling. Source tag shown as small grey pill below assistant bubble. Safety footer shown when `containsSymptomKeywords = true`. | | |
| TASK-020 | Create `lib/features/ai_assistant/presentation/widgets/voice_input_button.dart` — mic FAB, 56px. States: idle / listening (red pulse) / processing (shimmer). Calls `speech_to_text`, fills text field on result. | | |
| TASK-021 | Create `lib/features/ai_assistant/presentation/screens/ai_assistant_screen.dart` — assembles header + chips + chat list + input row. `AutomaticKeepAliveClientMixin`. Keyboard-aware: `resizeToAvoidBottomInset: true`. | | |
| TASK-022 | Swap `AppointmentsScreen()` → `AiAssistantScreen()` in `MainLayoutScreen` PageView children (index 1). | | |
| TASK-023 | Update `CustomBottomNavBar.items` — change index 1 icon to `Icons.auto_awesome_rounded`, label to `'حكيم'`. | | |

**Completion criteria:** Chips pre-fill assistant and return mock responses. "احجز موعداً" chip opens triage modal. Voice mic captures Arabic text and sends. Chat history scrolls correctly. `flutter analyze` = 0 issues.

---

### Implementation Phase 3 — "عائلتي" Emergency & Family Screen (replaces SettingsScreen)

- **GOAL-003**: Replace the rarely-visited settings tab with a high-value daily-use screen covering emergency card, linked family members, and health alerts. Settings moves to a gear icon inside the Home header.

**Screen location:** `lib/features/family_hub/presentation/screens/family_hub_screen.dart`
**Nav position:** Index 4 (was SettingsScreen)
**Nav label:** عائلتي | **Nav icon:** `Icons.shield_rounded`

#### What the screen contains (top to bottom):

**Section A — Emergency Card**
- Blood type badge (large, always visible, no login required for this section)
- Top 2 allergies listed with red warning icons
- "بطاقة الطوارئ" QR code (generated from encrypted payload)
- "اضف للشاشة الرئيسية" button → walks user through adding home screen widget
- Works 100% offline — data read from `flutter_secure_storage`

**Section B — Family Members**
- Horizontal scrollable avatar row of linked family accounts
- Tap → expands to that member's health card:
  - Last appointment date
  - Medication compliance % (e.g. "أخذ 6 من 7 جرعات هذا الأسبوع")
  - Any lab flags
  - AI one-sentence summary
- "إضافة فرد عائلي" add button → consent flow

**Section C — Genetic Risk Flags**
- Cards per flagged condition: "السكري — خطر مرتفع بسبب تاريخ عائلي"
- Risk level badge: منخفض / متوسط / مرتفع
- Expandable: "ما المقصود؟" plain Arabic explanation
- Mandatory non-skippable disclaimer: "هذا ليس تشخيصاً — استشر طبيبك"

**Section B — Weekly Family Report**
- AI-generated card per linked member
- Medication adherence, upcoming appointments, flagged symptoms
- "إرسال تقرير للطبيب" button

**Settings Access (relocated)**
- Gear icon `⚙` added to `HomeScreen` app bar (right side, next to notification bell)
- Tapping navigates to `SettingsScreen` via `GoRouter` push (not a nav tab)
- `SettingsScreen` remains unchanged — only its nav tab entry is removed

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-024 | Create `lib/features/family_hub/` directory with domain/data/presentation structure | | |
| TASK-025 | Create `lib/features/family_hub/domain/models/emergency_card.dart` — `bloodType`, `allergies: List<String>`, `chronicConditions: List<String>`, `emergencyContact`. Serializes to encrypted JSON via `encrypt` package. | | |
| TASK-026 | Create `lib/features/family_hub/domain/models/family_member.dart` — `name`, `relation`, `avatarUrl`, `medicationCompliance: double`, `lastAppointment: DateTime?`, `labFlags: List<String>`, `aiSummaryAr: String` | | |
| TASK-027 | Create `lib/features/family_hub/domain/models/genetic_risk_flag.dart` — `condition`, `riskLevel: RiskLevel`, `affectedRelatives: int`, `explanationAr`, `explanationEn` | | |
| TASK-028 | Create `lib/features/family_hub/data/repositories/mock_family_hub_repository.dart` — returns: blood type A+, 2 allergies, 2 family members, 1 genetic flag (T2DM high risk) | | |
| TASK-029 | Create `lib/features/family_hub/presentation/providers/family_hub_provider.dart` — `NotifierProvider<FamilyHubNotifier, FamilyHubState>` | | |
| TASK-030 | Create `lib/features/family_hub/presentation/widgets/emergency_card_widget.dart` — Section A. Blood type large badge. Allergy list. QR placeholder (real QR in Phase 8 of AI roadmap). Offline-safe: reads from `SharedPreferences` mock. | | |
| TASK-031 | Create `lib/features/family_hub/presentation/widgets/family_member_card.dart` — Section B. Avatar + name + compliance % + AI summary sentence. Expandable. | | |
| TASK-032 | Create `lib/features/family_hub/presentation/widgets/genetic_risk_card.dart` — Section C. Condition + risk badge. Non-skippable disclaimer on first view (stored in `SharedPreferences`). Expandable explanation. | | |
| TASK-033 | Create `lib/features/family_hub/presentation/screens/family_hub_screen.dart` — assembles all sections in `CustomScrollView`. `AutomaticKeepAliveClientMixin`. | | |
| TASK-034 | Add gear icon `⚙` (`Icons.settings_rounded`) to `HomeScreen` AppBar actions. `onTap` → `context.push('/settings')`. Register `/settings` as a pushable route in `app_router.dart`. | | |
| TASK-035 | Swap `SettingsScreen()` → `FamilyHubScreen()` in `MainLayoutScreen` PageView children (index 4). | | |
| TASK-036 | Update `CustomBottomNavBar.items` — change index 4 icon to `Icons.shield_rounded`, label to `'عائلتي'`. | | |

**Completion criteria:** Emergency card renders with mock data offline. Family member card shows compliance %. Genetic risk card shows non-skippable disclaimer on first open. Settings accessible via gear icon in Home header. `flutter analyze` = 0 issues.

---

## 3. Alternatives

- **ALT-001**: Keep AppointmentsScreen and add AI assistant as a 6th tab — rejected. 6 tabs exceed mobile UX limits; users can't remember more than 5. Appointments happen monthly, AI assistant daily — clear winner for the slot.
- **ALT-002**: Merge Family + Emergency into Settings (as a section) — rejected. Settings is a configuration screen; emergency and family data are primary health content that deserve their own space and daily visibility.
- **ALT-003**: Move Settings to a hamburger drawer — rejected. Drawer pattern is uncommon in Arabic mobile apps and adds an extra tap. Gear icon in Home header is faster and more discoverable.
- **ALT-004**: Replace DashboardScreen instead of RecordsScreen with Smart Health — rejected. Dashboard (vitals + health summary) is high-value and already well-designed. RecordsScreen is weaker and overlaps with Smart Health's scope.
- **ALT-005**: Put AI assistant in a floating action button rather than a nav tab — rejected. FAB is easily missed and communicates low importance. A nav tab signals this is a primary feature of the app.

---

## 4. Dependencies

- **DEP-001**: `feature-ai-clinical-roadmap-1.md` Phase 4 (Lab Intelligence) — data source for صحتي lab section. Screen ships with mock data until Phase 4 is built.
- **DEP-002**: `feature-ai-clinical-roadmap-1.md` Phase 5 (Patient Note Simplifier) — data source for doctor notes toggle in صحتي.
- **DEP-003**: `feature-ai-clinical-roadmap-1.md` Phase 6 (Symptom Diary) — data source for check-in card in صحتي.
- **DEP-004**: `feature-ai-clinical-roadmap-1.md` Phase 7 (AI Assistant) — full AI backend for حكيم screen. Mock ships first.
- **DEP-005**: `feature-ai-clinical-roadmap-1.md` Phase 8 (Emergency Card) — real QR + encryption for عائلتي Section A. Mock ships first.
- **DEP-006**: `feature-ai-clinical-roadmap-1.md` Phase 9 (Guardian + Genetic Flags) — real data for عائلتي Sections B and C. Mock ships first.
- **DEP-007**: `speech_to_text` package — voice input for حكيم AI assistant (Phase 2, TASK-020).
- **DEP-008**: `qr_flutter` package — QR code generation for emergency card (Phase 3, TASK-030).
- **DEP-009**: `encrypt` package — AES-256 encryption for emergency card payload (Phase 3, TASK-025).

---

## 5. Files

**Modified files:**
- **FILE-001**: `lib/features/main_layout/presentation/screens/main_layout_screen.dart` — swap 3 screen widgets in PageView (TASK-011, TASK-022, TASK-035)
- **FILE-002**: `lib/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart` — update 3 nav items (icons + labels) (TASK-012, TASK-023, TASK-036)
- **FILE-003**: `lib/features/home/presentation/screens/home_screen.dart` — add gear icon to AppBar (TASK-034)
- **FILE-004**: `lib/core/router/app_router.dart` — add `/settings` as pushable route (TASK-034)

**New feature directories:**
- **FILE-005**: `lib/features/smart_health/` — صحتي screen (10 new files, TASK-001 to TASK-010)
- **FILE-006**: `lib/features/ai_assistant/` — حكيم AI screen (9 new files, TASK-013 to TASK-021)
- **FILE-007**: `lib/features/family_hub/` — عائلتي screen (10 new files, TASK-024 to TASK-033)

**Preserved (not deleted):**
- **FILE-008**: `lib/features/medical_records/presentation/screens/records_screen.dart` — kept, unused in nav. Can be deep-linked from صحتي if needed.
- **FILE-009**: `lib/features/appointments/presentation/screens/appointments_screen.dart` — triage modal migrated to `Triage Modal` widget; file kept for reference.
- **FILE-010**: `lib/features/settings/presentation/screens/settings_screen.dart` — kept, now accessed via gear icon push route.

---

## 6. Testing

- **TEST-001**: `test/features/smart_health/smart_health_provider_test.dart` — mock repo returns 2 abnormal labs; state reflects `labFlags.length == 2`.
- **TEST-002**: Widget test — `LabResultTile` with `status: LabStatus.critical` shows red color AND warning icon AND text label (CLN-001 compliance).
- **TEST-003**: Widget test — `DoctorNotesCard` toggle chip switches between raw and simplified text correctly.
- **TEST-004**: `test/features/ai_assistant/assistant_provider_test.dart` — sending "متى موعدي؟" returns mock response with `sourceTag: '[من مواعيدك]'`.
- **TEST-005**: Widget test — `SuggestionChipsRow` chip "احجز موعداً" tap opens `TriageModal` bottom sheet.
- **TEST-006**: Widget test — `VoiceInputButton` shows red pulse animation in listening state.
- **TEST-007**: `test/features/family_hub/family_hub_provider_test.dart` — mock repo returns blood type "A+" and 2 allergies; `EmergencyCardWidget` renders both.
- **TEST-008**: Widget test — `GeneticRiskCard` shows non-skippable disclaimer on first render (`barrierDismissible: false` pattern).
- **TEST-009**: Integration test — Settings accessible via gear icon in Home AppBar after SettingsScreen removed from nav. `context.push('/settings')` navigates correctly.
- **TEST-010**: `flutter analyze` — 0 issues after all 3 phases complete.

---

## 7. Risks & Assumptions

- **RISK-001**: Migrating triage modal from `AppointmentsScreen` to `TriageModal` widget — low risk, logic is self-contained `StatefulBuilder`. Verify modal still opens correctly post-migration.
- **RISK-002**: Users may not discover Settings via gear icon after removing the nav tab — mitigation: onboarding tooltip on first launch pointing to gear icon. Also surfaced in "عائلتي" screen as a small "الإعدادات" text link at the bottom.
- **RISK-003**: Mock data for AI summaries may mislead users into thinking the AI is real — mitigation: `AiDisclaimerBanner` mandatory on all AI content cards from day 1, even with mocks.
- **RISK-004**: `CustomBottomNavBar` may have hardcoded item count assumptions — inspect before TASK-012. If items list length is checked, update accordingly.
- **RISK-005**: Emergency card QR is a placeholder until Phase 8 encryption ships — mitigation: display static informational QR with `"قريباً"` overlay badge. Never display unencrypted sensitive data in QR.
- **ASSUMPTION-001**: `CustomBottomNavBar.items` is a modifiable list of `NavItem` objects (confirmed from `lib/features/main_layout/domain/models/nav_item.dart`).
- **ASSUMPTION-002**: `GoRouter` supports `context.push('/settings')` in addition to `context.go()` — standard GoRouter behavior, assumed available.
- **ASSUMPTION-003**: Existing `lib/features/assistant/` files (chat_message, ai_chat_screen etc.) are a prior draft. New implementation in `lib/features/ai_assistant/` is the canonical version. Prior files are kept but not wired to nav.

---

## 8. Related Specifications / Further Reading

- [`plan/feature-ai-clinical-roadmap-1.md`](./feature-ai-clinical-roadmap-1.md) — AI feature phases that power these three screens
- `lib/features/main_layout/presentation/screens/main_layout_screen.dart` — PageView wiring reference
- `lib/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart` — nav items structure
- `lib/features/appointments/presentation/screens/appointments_screen.dart` — triage modal to migrate
- `lib/features/medical_records/presentation/screens/records_screen.dart` — record tile + secure share to migrate
- `lib/features/settings/presentation/screens/settings_screen.dart` — preserved, push-routed
- [Healthcare EMR Patterns Skill](../skills/healthcare-emr-patterns/SKILL.md) — clinical UI safety patterns applied throughout
