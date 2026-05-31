---
goal: Hakeem AI & Clinical Intelligence Feature Roadmap
version: 1.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: DAWAS00
status: 'Planned'
tags: [feature, ai, clinical, nlp, speech, safety, ux, architecture]
---

# Introduction

![Status: Planned](https://img.shields.io/badge/status-Planned-blue)

This plan documents **9 AI and clinical feature clusters** proposed for the Hakeem (حكيم) healthcare app. Each cluster is evaluated for architectural fit, clinical safety impact, and implementation approach within the existing Flutter clean-architecture codebase. No code is written yet — this is a planning and decision document. Features are grouped into phases ordered by dependency and patient-safety priority.

**Core philosophy across all AI features:**
> AI suggests. The doctor always confirms. The system never acts autonomously on clinical data.

---

## 1. Requirements & Constraints

- **REQ-001**: All AI responses must be bilingual (Arabic + English). Arabic is primary — every patient-facing string must render RTL.
- **REQ-002**: Doctor confirmation is mandatory before any AI suggestion becomes a clinical record (diagnosis, prescription, plan).
- **REQ-003**: Drug allergy alerts must be non-dismissable modals — never toasts.
- **REQ-004**: Emergency card data must be accessible fully offline — no network call permitted.
- **REQ-005**: Guardian/family access requires explicit patient consent stored server-side.
- **REQ-006**: All clinical AI suggestions must display a visible "AI-generated — not confirmed by doctor" disclaimer until confirmed.
- **SEC-001**: Emergency card data encrypted at rest using `flutter_secure_storage`. QR payload encrypted with AES-256; only authorized healthcare providers hold the decryption key.
- **SEC-002**: Guardian mode data access scoped by patient-granted permissions; revocable at any time.
- **SEC-003**: Speech-to-text audio must not be stored permanently — transcription only, audio discarded post-processing.
- **CLN-001**: (Clinical Safety)    Lab result abnormal flags must pair color AND icon AND text — never color alone (colorblind clinicians).
- **CLN-002**: (Clinical Safety) Drug interaction severity levels: CRITICAL blocks prescribing; MAJOR requires acknowledgment; MINOR shows passive warning.
- **CON-001**: App targets Jordan (JO) market. Pharmacy inventory integration depends on hospital-side API availability — plan around mock/offline fallback.
- **CON-002**: Bluetooth device integration is platform-split: Android uses `flutter_blue_plus`, iOS uses CoreBluetooth via platform channel.
- **CON-003**: Genetic risk flags are informational only — must never be framed as a diagnosis.
- **GUD-001**: All new features follow existing clean architecture: `domain → data → presentation`. No business logic in widgets.
- **GUD-002**: All Riverpod state uses `NotifierProvider<Notifier, State>` pattern (no AsyncNotifier until codebase migrates).
- **GUD-003**: Design tokens only — `HakimColors.*`, `HakimSpacing.*`. No hardcoded values.
- **PAT-001**: Every AI feature uses a shared `AiServiceRepository` (domain layer) — features never call AI APIs directly from presentation.
- **PAT-002**: NLP extraction results always stored as structured entities, never raw strings.
- **PAT-003**: EMR pattern — locked encounters, addendum-only edits, full audit trail.

---

## 2. Implementation Steps

---

### Implementation Phase 1 — AI Core Infrastructure

- **GOAL-001**: Build the shared AI service layer that all 9 feature clusters depend on. This must ship before any other AI feature.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-001 | Create `lib/core/ai/` — shared domain entities: `AiResponse`, `AiPromptType` enum, `AiSuggestion` (with `isConfirmed: bool` field) | | |
| TASK-002 | Create `lib/core/ai/repositories/ai_service_repository.dart` — abstract interface with methods: `analyzeText()`, `extractClinicalData()`, `translateAndSimplify()`, `analyzeSentiment()` | | |
| TASK-003 | Create `lib/core/ai/data/claude_ai_datasource.dart` — implements `AiServiceRepository` using Claude API (Anthropic SDK). System prompt enforces bilingual AR/EN output and "suggestions only" framing | | |
| TASK-004 | Create `lib/core/ai/data/ai_providers.dart` — Riverpod DI: `aiDatasourceProvider → aiRepositoryProvider`. Override in tests with mock. | | |
| TASK-005 | Add `anthropic_sdk` (or `dio`-based wrapper) to `pubspec.yaml`. Add `ANTHROPIC_API_KEY` to `.env` — never hardcoded. Use `flutter_dotenv`. | | |
| TASK-006 | Create `lib/shared/widgets/ai_disclaimer_banner.dart` — reusable widget showing "اقتراح الذكاء الاصطناعي — لم يؤكده الطبيب بعد" with amber color. Mandatory on all AI-generated content. | | |
| TASK-007 | Create `lib/core/ai/usecases/` — one use case per AI action: `AnalyzeTextUseCase`, `ExtractClinicalDataUseCase`, `TranslateAndSimplifyUseCase` | | |

**Completion criteria:** `flutter analyze` passes; `AiServiceRepository` mock returns bilingual stub responses; `AiDisclaimerBanner` renders correctly in RTL.

---

### Implementation Phase 2 — Drug Safety & Allergy Guard

- **GOAL-002**: Prevent allergic reactions and critical drug interactions at prescription time. Highest patient-safety priority after Phase 1.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-008 | Create `lib/features/drug_safety/domain/entities/drug_entity.dart` — fields: `id`, `name`, `genericName`, `activeIngredients: List<String>`, `interactionRisk: InteractionRiskLevel` | | |
| TASK-009 | Create `lib/features/drug_safety/domain/entities/allergy_check_result.dart` — fields: `hasAllergy: bool`, `allergen: String?`, `severity: AllergySeverity`, `suggestedAlternatives: List<DrugEntity>` | | |
| TASK-010 | Create `lib/features/drug_safety/domain/repositories/drug_safety_repository.dart` — abstract: `checkAllergies(drugId, patientId)`, `checkInteractions(drugIds)`, `getPharmacyStock(drugId)` | | |
| TASK-011 | Create `lib/features/drug_safety/data/` — mock `DrugSafetyRepositoryImpl` backed by local JSON dataset (Jordan Essential Medicines List). Real API integration deferred to Phase 1 backend. | | |
| TASK-012 | Create `lib/features/drug_safety/presentation/widgets/allergy_alert_modal.dart` — NON-DISMISSABLE modal (no `barrierDismissible`). Shows: allergen name, severity badge, suggested alternatives list, "Override with reason" text field. Override reason logged to audit trail. | | |
| TASK-013 | Create `lib/features/drug_safety/presentation/widgets/interaction_warning_banner.dart` — CRITICAL = red blocking modal. MAJOR = amber acknowledgment required. MINOR = blue inline banner. | | |
| TASK-014 | Create `lib/features/drug_safety/presentation/widgets/pharmacy_stock_indicator.dart` — green "متوفر", red "غير متوفر — اقترح بديلاً". Fetches real-time via `getPharmacyStock()`. Falls back to "غير متاح بيانات المخزون" offline. | | |
| TASK-015 | Wire allergy check into prescription flow: every time a doctor selects a drug, trigger `CheckAllergiesUseCase` before the drug is added to the prescription list. Block if CRITICAL. | | |

**Why useful:** Prevents life-threatening allergic reactions. Reduces pharmacist override errors. Pharmacy stock check removes the friction of prescribing unavailable drugs.

**Completion criteria:** CRITICAL allergy blocks drug selection entirely. MAJOR shows modal requiring text acknowledgment. Mock stock API returns in/out-of-stock correctly.

---

### Implementation Phase 3 — Speech-to-Text Clinical Dictation

- **GOAL-003**: Let doctors speak their diagnosis, notes, and prescription. App auto-fills structured fields via NLP. Eliminates manual data entry friction.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-016 | Add `speech_to_text` package to `pubspec.yaml`. Add microphone permissions: `RECORD_AUDIO` (Android), `NSMicrophoneUsageDescription` (iOS). | | |
| TASK-017 | Create `lib/features/voice_input/domain/entities/clinical_dictation.dart` — raw transcript + extracted fields: `diagnosis: String?`, `medications: List<MedicationDosage>`, `chiefComplaint: String?`, `plan: String?` | | |
| TASK-018 | Create `lib/features/voice_input/domain/usecases/extract_clinical_data_usecase.dart` — takes raw transcript, calls `AiServiceRepository.extractClinicalData()`, returns `ClinicalDictation`. | | |
| TASK-019 | Create `lib/features/voice_input/presentation/widgets/dictation_fab.dart` — floating mic button. States: idle / listening (animated waveform) / processing (shimmer) / done (green check). Arabic label: "انقر للإملاء الطبي". | | |
| TASK-020 | Create `lib/features/voice_input/presentation/widgets/dictation_review_sheet.dart` — bottom sheet shows raw transcript + extracted fields side by side. Doctor taps each field to confirm or edit. "تأكيد وملء التقرير" CTA triggers auto-fill. | | |
| TASK-021 | NLP extraction prompt engineering (in `ClaudeAiDatasource`): system prompt extracts structured JSON from Arabic/English medical dictation. Fields: `diagnosis`, `icd10Code`, `medications[].name`, `medications[].dose`, `medications[].frequency`, `medications[].duration`, `plan`. | | |
| TASK-022 | Audio is transcribed in-memory. Raw audio bytes are discarded after transcription. Only the text transcript is sent to AI. Document this in privacy policy. | | |

**Why useful:** DeepScribe (USA) charges hospitals $30k+/year for this. Doctors in Jordan lose 30–40% of clinic time to manual note entry. S2T + NLP cuts documentation to seconds.

**Completion criteria:** 30-second dictation in Arabic produces correctly extracted structured fields in `ClinicalDictation` entity. Audio not persisted after session.

---

### Implementation Phase 4 — Lab Results Intelligence

- **GOAL-004**: Analyze uploaded lab results. Flag abnormal values visually. Generate smart summary for doctors and simplified plain-language explanation for patients.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-023 | Create `lib/features/lab_results/domain/entities/lab_result.dart` — fields: `testName`, `value: double`, `unit`, `referenceRange: ReferenceRange`, `status: LabStatus` (normal/low/high/critical), `trend: TrendDirection` (up/down/stable) | | |
| TASK-024 | Create `lib/features/lab_results/domain/usecases/analyze_lab_results_usecase.dart` — calls `AiServiceRepository.analyzeText()` with structured lab data. Returns `LabSummary`: risk level, trend analysis, highlighted abnormals, doctor summary (clinical), patient summary (plain AR/EN). | | |
| TASK-025 | Create `lib/features/lab_results/presentation/widgets/lab_value_tile.dart` — shows value + unit + range. Color-coded: green (normal) / amber (borderline) / red (abnormal) / red pulsing (critical). MUST also show text label + icon (not color alone — CLN-001). | | |
| TASK-026 | Create `lib/features/lab_results/presentation/widgets/lab_trend_chart.dart` — sparkline using `fl_chart`. Shows last 3–5 results for the same test. Arrow indicator (↑↓→) with color. | | |
| TASK-027 | Create `lib/features/lab_results/presentation/widgets/lab_ai_summary_card.dart` — two tabs: "للطبيب" (clinical keywords, risk flags, trend analysis) and "للمريض" (plain Arabic: what does this mean? what to do?). Both show `AiDisclaimerBanner`. | | |
| TASK-028 | Critical lab value (e.g., K+ > 6.5) triggers non-dismissable `CriticalLabAlertModal` — same pattern as drug allergy alert. Doctor must acknowledge before continuing. | | |

**Why useful:** Doctors review dozens of lab sheets per day. Smart summary with trends saves 5–10 min per patient. Patients currently have zero understanding of their own results — plain-language explanation closes this gap entirely.

**Completion criteria:** Abnormal values flagged with color + icon + text. Critical value triggers non-dismissable modal. AI summary renders in both AR and EN.

---

### Implementation Phase 5 — Patient AI Layer (Note Translation & Plain-Language Explainer)

- **GOAL-005**: Take clinical doctor notes (often blunt, jargon-heavy, or illegible) and transform them into supportive, clear, bilingual patient instructions.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-029 | Create `lib/features/patient_ai/domain/usecases/simplify_doctor_notes_usecase.dart` — input: raw doctor note (string). Output: `SimplifiedNote` entity with `originalText`, `simplifiedAr`, `simplifiedEn`, `whatThisMeans`, `whatToDoNext: List<String>`, `whenToSeekHelp: List<String>`. | | |
| TASK-030 | AI prompt engineering: system prompt transforms blunt clinical notes → warm, supportive, actionable Arabic instructions. E.g., "HTN uncontrolled, adjust meds" → "ضغطك الدم أعلى من المعدل الطبيعي. الطبيب عدّل دواءك — خذه بانتظام وتجنب الملح." | | |
| TASK-031 | Create `lib/features/patient_ai/presentation/screens/my_notes_screen.dart` — patient sees two views toggled by chip: "ملاحظات الطبيب الأصلية" (original, read-only) and "شرح مبسّط" (AI-simplified). | | |
| TASK-032 | Create `lib/features/patient_ai/presentation/widgets/medical_term_tooltip.dart` — tappable underline on any medical term. Tap → bottom sheet with: term in AR/EN, plain-language definition, why it matters. Powered by `TranslateAndSimplifyUseCase`. | | |
| TASK-033 | Create `lib/features/patient_ai/presentation/widgets/next_steps_card.dart` — "ماذا أفعل الآن؟" card. Ordered checklist of patient actions extracted from doctor plan. Each item checkable by patient. | | |
| TASK-034 | All simplified content shows `AiDisclaimerBanner` + "تمت المراجعة من قبل الطبيب" badge only after doctor confirms via `AiSuggestion.isConfirmed = true`. | | |

**Why useful:** Seha (KSA) built this and it's their most-used feature. Patients in Jordan often leave the clinic confused about their own condition. This feature directly reduces non-compliance with treatment plans.

**Completion criteria:** Given a sample clinical note in Arabic/English, the use case returns a structured `SimplifiedNote` with all fields populated. Disclaimer shows until doctor confirms.

---

### Implementation Phase 6 — Symptom Diary & AI Trend Reporting

- **GOAL-006**: Patient checks in with the app weekly. App uses NLP + sentiment analysis to detect symptom trends. Doctor receives a structured weekly summary.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-035 | Create `lib/features/symptom_diary/domain/entities/symptom_entry.dart` — fields: `timestamp`, `rawText`, `symptoms: List<DetectedSymptom>`, `painScale: int?`, `sentiment: SentimentScore`, `location: BodyLocation?` | | |
| TASK-036 | Create `lib/features/symptom_diary/domain/usecases/analyze_symptom_entry_usecase.dart` — calls `AiServiceRepository.analyzeSentiment()`. Extracts symptoms, pain intensity, location, emotional tone from free-text patient input. | | |
| TASK-037 | Create `lib/features/symptom_diary/domain/usecases/generate_weekly_report_usecase.dart` — aggregates 7 days of `SymptomEntry`. Produces `WeeklyReport`: top symptoms by frequency, trend lines (% change), sentiment trajectory, notable deterioration flags. | | |
| TASK-038 | Create `lib/features/symptom_diary/presentation/screens/diary_checkin_screen.dart` — conversational UI (chat-like). Patient types or speaks how they feel. App responds with empathetic prompt: "هل الألم في نفس المكان؟ كيف تقيّمه من 1–10؟" (guided NLP conversation). | | |
| TASK-039 | Create `lib/features/symptom_diary/presentation/widgets/weekly_report_card.dart` — shown to doctor. Displays: top 3 symptoms with trend arrows, pain scale line chart (`fl_chart`), sentiment indicator, notable quotes from patient entries. | | |
| TASK-040 | Schedule local notification (using `flutter_local_notifications`) twice weekly to prompt diary check-in. Patient can adjust frequency in Settings. | | |

**Why useful:** Patients forget symptoms between appointments — clinically proven to cause underreporting. "20% increase in back pain over 2 weeks" is actionable data a doctor cannot get from a 10-minute consultation. Reduces missed diagnoses.

**Completion criteria:** 3 diary entries over 3 days produce a `WeeklyReport` with detectable trends. Notification triggers at configured interval.

---

### Implementation Phase 7 — Hakeem AI Assistant ("Siri for Healthcare")

- **GOAL-007**: Conversational AI personal assistant. Answers patient questions based on their own health data. Designed for elderly users — large text, voice input, simple answers.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-041 | Create `lib/features/ai_assistant/domain/entities/assistant_message.dart` — role: `user|assistant`, content, timestamp, `isVoiceInput: bool`, `sourceDataType: AssistantDataSource` (medications/appointments/labs/general). | | |
| TASK-042 | Create `lib/features/ai_assistant/domain/usecases/ask_assistant_usecase.dart` — builds context from patient's active medications, upcoming appointments, last lab results. Sends to Claude with strict system prompt: "Answer only from provided patient data. Never diagnose. Always suggest seeing doctor for clinical questions." | | |
| TASK-043 | Create `lib/features/ai_assistant/presentation/screens/assistant_screen.dart` — chat UI. RTL, large 18sp text. Voice input button (mic FAB). Suggested prompts as chips: "متى موعدي القادم؟" / "ما هو دواء الصباح؟" / "ماذا تعني نتيجة الكوليسترول؟" | | |
| TASK-044 | Elderly mode flag in settings (`isElderlyMode: bool`). When enabled: font size +4sp globally, touch targets 56px, simplified vocabulary in AI responses (no medical jargon), voice-first UI. | | |
| TASK-045 | Hard guardrail in system prompt: assistant must never suggest a diagnosis, never advise stopping medication, always end responses that touch on symptoms with "راجع طبيبك". Log all conversations. | | |

**Why useful:** Elderly patients are the highest-burden group in any healthcare system and the least able to navigate complex apps. A "medication at 8am" reminder that responds to voice ("هل أخذت دوائك؟") directly improves medication adherence — a major public health problem.

**Completion criteria:** Assistant correctly answers "ما هو دواء المساء؟" from patient medication data. Response time < 3s. Safety guardrail fires for symptom-related questions.

---

### Implementation Phase 8 — Offline Emergency Card

- **GOAL-008**: A QR code or lock-screen widget showing blood type, allergies, and chronic conditions — accessible with zero network, zero unlock.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-046 | Create `lib/features/emergency_card/domain/entities/emergency_card.dart` — fields: `bloodType`, `allergies: List<String>`, `chronicConditions: List<String>`, `emergencyContact`, `lastUpdated`. Minimal — only life-critical data. | | |
| TASK-047 | Add `qr_flutter` package. Create `lib/features/emergency_card/presentation/widgets/emergency_qr.dart` — generates QR from AES-256 encrypted JSON payload. Public header (unencrypted): blood type only. Full payload requires authorized scan. | | |
| TASK-048 | Create `lib/features/emergency_card/presentation/screens/emergency_card_screen.dart` — displays blood type, allergies, chronic conditions in large readable text (no login required). Accessible from app's first screen or notification shade shortcut. Fully cached — no network. | | |
| TASK-049 | Add `home_widget` package. Create Android home screen widget and iOS widget extension showing blood type + top 2 allergies. Rendered from `flutter_secure_storage` — no network call ever. | | |
| TASK-050 | Add "اضف للشاشة الرئيسية" prompt in Emergency Card screen — walks user through adding the widget to their lock screen / home screen. | | |
| TASK-051 | Data encrypted using `flutter_secure_storage` + AES key derived from patient ID + device ID. QR contains encrypted payload — only hospital scanners with shared key can decrypt full record. Blood type always visible unencrypted (emergency-critical, not sensitive). | | |

**Why useful:** If a patient arrives unconscious — no phone PIN, no internet, no time — a first responder needs blood type and allergies in 10 seconds. This feature can literally save lives. No competitor in Jordan currently has this.

**Completion criteria:** Emergency card screen accessible without login. Widget renders from cached storage with no network. QR decodes correctly in test scanner. Full data inaccessible without authorized key.

---

### Implementation Phase 9 — Guardian Mode & Genetic Risk Flags

- **GOAL-009**: Allow a designated guardian (parent/caregiver) to monitor an elderly/dependent patient. Surface hereditary disease risks based on family history.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-052 | Create `lib/features/guardian/domain/entities/guardian_link.dart` — `guardianId`, `patientId`, `accessLevel: GuardianAccessLevel` (read-only/alerts-only/full), `consentGrantedAt`, `consentRevokedAt?`. Patient can revoke at any time. | | |
| TASK-053 | Create `lib/features/guardian/domain/usecases/generate_weekly_family_report_usecase.dart` — aggregates: medication adherence (taken/missed), appointment attendance, lab result flags, symptom diary summary. Output: `FamilyWeeklyReport` entity. | | |
| TASK-054 | Create `lib/features/guardian/presentation/screens/guardian_dashboard_screen.dart` — shows linked patients as cards. Each card: name, last active, medication compliance %, next appointment, red flags. AI-generated summary sentence per patient. | | |
| TASK-055 | Create `lib/features/genetic_flags/domain/entities/genetic_risk_flag.dart` — `condition`, `inheritancePattern`, `familyMembersAffected: int`, `relativeRisk: RiskLevel` (low/moderate/high), `recommendation`. | | |
| TASK-056 | Create `lib/features/genetic_flags/domain/usecases/compute_genetic_risk_usecase.dart` — input: family history (parent/sibling conditions). Output: list of `GeneticRiskFlag` for conditions with known hereditary patterns (T2DM, HTN, CAD, CRC, Breast CA). Uses rule-based logic + AI narrative generation. | | |
| TASK-057 | Create `lib/features/genetic_flags/presentation/widgets/genetic_risk_card.dart` — shows condition, risk level badge, "ما المقصود؟" expandable explanation. Footer: "هذا ليس تشخيصاً — استشر طبيبك" — mandatory disclaimer. | | |
| TASK-058 | Push notifications to guardian via `firebase_messaging`: medication missed (>2h late), critical lab result received, upcoming appointment in 24h. Guardian cannot modify any data — read-only access enforced server-side. | | |

**Why useful:** In Jordan and the Arab world, family-based care is the cultural norm. A daughter managing her elderly mother's health needs a weekly summary, not raw medical data she can't interpret. Genetic flags for T2DM/HTN address the region's highest disease burden.

**Completion criteria:** Guardian sees patient summary with no edit capability. Genetic risk card shows correct risk level for a family history of T2DM. Consent revocation immediately removes guardian access.

---

## 3. Alternatives

- **ALT-001**: On-device AI (e.g., Gemini Nano) instead of Claude API — rejected for Phase 1 because model quality for Arabic clinical NLP is insufficient. Revisit when on-device AR models mature.
- **ALT-002**: Third-party STT service (Google Cloud Speech, Azure Cognitive) instead of `speech_to_text` package — deferred; `speech_to_text` uses on-device recognition which avoids sending audio to a third party, preserving patient privacy (SEC-003).
- **ALT-003**: Separate AI apps per user role (doctor app / patient app) — rejected. Single app with role-based views reduces maintenance overhead and keeps the codebase coherent.
- **ALT-004**: Drug interaction database (DrugBank, RxNorm) direct integration — deferred pending API licensing. Phase 1 uses curated local JSON; real-time integration is Phase 2 backend work.
- **ALT-005**: NFC instead of QR for emergency card — rejected because NFC requires unlock on modern iOS. QR works on any camera, locked or unlocked.
- **ALT-006**: Separate guardian app — rejected. Guardian mode as a role within the same app simplifies identity management and reduces user friction.

---

## 4. Dependencies

- **DEP-001**: `anthropic` Dart SDK (or `dio`-based wrapper) — Claude API for all AI features (Phases 1–9)
- **DEP-002**: `speech_to_text` — on-device voice recognition (Phase 3)
- **DEP-003**: `qr_flutter` — QR code generation for emergency card (Phase 8)
- **DEP-004**: `home_widget` — lock screen / home screen widget for emergency card (Phase 8)
- **DEP-005**: `flutter_local_notifications` — symptom diary reminders, medication alerts (Phase 6, 7)
- **DEP-006**: `firebase_messaging` — guardian push alerts (Phase 9)
- **DEP-007**: `encrypt` (AES-256) — emergency card payload encryption (Phase 8)
- **DEP-008**: `flutter_dotenv` — API key management; `ANTHROPIC_API_KEY` never hardcoded (Phase 1)
- **DEP-009**: Hospital pharmacy inventory API — real-time stock check (Phase 2, CON-001 governs fallback)
- **DEP-010**: Jordan Ministry of Health drug/allergy database or DrugBank license (Phase 2)

---

## 5. Files

- **FILE-001**: `lib/core/ai/` — new shared AI infrastructure directory (Phase 1)
- **FILE-002**: `lib/features/drug_safety/` — new feature directory (Phase 2)
- **FILE-003**: `lib/features/voice_input/` — new feature directory (Phase 3)
- **FILE-004**: `lib/features/lab_results/` — new/expanded feature directory (Phase 4)
- **FILE-005**: `lib/features/patient_ai/` — new feature directory (Phase 5)
- **FILE-006**: `lib/features/symptom_diary/` — new feature directory (Phase 6)
- **FILE-007**: `lib/features/ai_assistant/` — new feature directory (Phase 7)
- **FILE-008**: `lib/features/emergency_card/` — new feature directory (Phase 8)
- **FILE-009**: `lib/features/guardian/` + `lib/features/genetic_flags/` — new feature directories (Phase 9)
- **FILE-010**: `lib/core/router/app_router.dart` — 9 new routes to register
- **FILE-011**: `lib/core/l10n/` — new localization keys for all 9 feature clusters
- **FILE-012**: `pubspec.yaml` — 7 new dependencies (DEP-001 through DEP-008)
- **FILE-013**: `android/app/src/main/AndroidManifest.xml` — `RECORD_AUDIO`, `BLUETOOTH_SCAN`, `RECEIVE_BOOT_COMPLETED` permissions
- **FILE-014**: `ios/Runner/Info.plist` — `NSMicrophoneUsageDescription`, `NSBluetoothAlwaysUsageDescription`
- **FILE-015**: `plan/feature-ai-clinical-roadmap-1.md` — this document

---

## 6. Testing

- **TEST-001**: `test/core/ai/claude_ai_datasource_test.dart` — mock HTTP client returns bilingual response; verify `AiResponse` parsed correctly.
- **TEST-002**: `test/features/drug_safety/check_allergies_usecase_test.dart` — CRITICAL allergy returns `AllergySeverity.critical`; MAJOR returns acknowledgment required; no allergy returns empty alternatives list.
- **TEST-003**: `test/features/drug_safety/check_interactions_usecase_test.dart` — Warfarin + Aspirin returns CRITICAL; Metformin + Lisinopril returns no interaction.
- **TEST-004**: `test/features/voice_input/extract_clinical_data_usecase_test.dart` — given Arabic transcript fixture, verify extracted `ClinicalDictation` contains correct diagnosis, medication name, dose, frequency.
- **TEST-005**: `test/features/lab_results/analyze_lab_results_usecase_test.dart` — K+ = 7.0 mmol/L returns `LabStatus.critical`; Hb = 13.5 g/dL returns `LabStatus.normal`.
- **TEST-006**: `test/features/patient_ai/simplify_doctor_notes_usecase_test.dart` — given fixture note "HTN uncontrolled, add amlodipine 5mg OD", verify `SimplifiedNote.simplifiedAr` is non-empty and contains no medical abbreviations.
- **TEST-007**: `test/features/symptom_diary/generate_weekly_report_usecase_test.dart` — 7 entries with increasing pain scale values produce `WeeklyReport` with upward trend for pain.
- **TEST-008**: `test/features/emergency_card/emergency_card_test.dart` — `EmergencyCard` serializes to JSON, encrypts, decrypts correctly. Blood type field is present unencrypted.
- **TEST-009**: `test/features/guardian/generate_family_report_usecase_test.dart` — patient with 2 missed medications in 7 days produces report with `medicationCompliancePercent < 100`.
- **TEST-010**: `test/features/genetic_flags/compute_genetic_risk_usecase_test.dart` — both parents with T2DM returns `RiskLevel.high` for T2DM flag.
- **TEST-011**: Widget test — `AllergyAlertModal` — `barrierDismissible` is `false`; tapping outside does not dismiss.
- **TEST-012**: Widget test — `AiDisclaimerBanner` — visible when `isConfirmed = false`; hidden when `isConfirmed = true`.

---

## 7. Risks & Assumptions

- **RISK-001**: Claude API latency may exceed 3s for complex prompts — mitigation: stream responses using `Stream<String>` and show progressive rendering with shimmer placeholder.
- **RISK-002**: Arabic NLP quality — Claude performs well in Arabic but clinical Arabic varies by region. Mitigation: include Jordanian Arabic examples in system prompts; add feedback loop for doctors to flag incorrect extractions.
- **RISK-003**: Pharmacy inventory API may not exist at partner hospitals — mitigation: Phase 2 ships with mock data and an adapter pattern. Real integration is a backend contract, not a Flutter blocker.
- **RISK-004**: `home_widget` on iOS requires a Widget Extension target — adds Xcode configuration complexity. Mitigation: iOS widget is Phase 8 stretch goal; Android widget ships first.
- **RISK-005**: Genetic risk flags may be misread as diagnoses by users — mitigation: mandatory, non-skippable disclaimer on first view; legal review required before ship.
- **RISK-006**: `speech_to_text` on-device Arabic recognition varies by device — Pixel/Samsung quality good; budget devices may fail. Mitigation: always show raw transcript for doctor review before auto-fill (TASK-020).
- **ASSUMPTION-001**: Backend provides patient allergy list, active medications, lab results, family history via REST API at `https://api.hakeem.jo`. Flutter app is frontend-only for Phase 1.
- **ASSUMPTION-002**: Doctor role and patient role are determined server-side via JWT claims. UI role-switching is not implemented — the API enforces access control.
- **ASSUMPTION-003**: Hospital pharmacy inventory endpoint will be provided by IT department of partner hospitals. Hakeem team does not own this API.
- **ASSUMPTION-004**: `flutter analyze` must report 0 issues at completion of every phase — this is a hard project rule per CLAUDE.md.

---

## 8. Related Specifications / Further Reading

- [Seha App (KSA) — Patient note explanation feature](https://www.seha.sa/)
- [DeepScribe — Medical Speech-to-Text (USA)](https://www.deepscribe.ai/)
- [Ada Health — Symptom Checker (Germany)](https://ada.com/)
- [MedCheck — Drug Interaction Checker](https://www.medscape.com/druginteractionchecker)
- [NEWS2 Clinical Scoring System](https://www.rcplondon.ac.uk/projects/outputs/national-early-warning-score-news-2)
- [WCAG 2.1 AA — Healthcare Accessibility Standard](https://www.w3.org/TR/WCAG21/)
- [Jordan Essential Medicines List — Ministry of Health](http://www.moh.gov.jo/)
- [ICD-10 WHO Reference](https://icd.who.int/browse10/)
- `lib/core/theme/app_theme.dart` — HakimColorScheme, design tokens
- `lib/core/router/app_router.dart` — route registration reference
- `CLAUDE.md` — project conventions (clean architecture, Riverpod pattern, linter rules)
