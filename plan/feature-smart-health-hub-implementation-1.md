---
goal: Implement Smart Health Hub (Phase 1)
version: 1.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: Gemini
status: 'Completed'
tags: [feature, smart_health, ai, redesign]
---

# Introduction

![Status: Completed](https://img.shields.io/badge/status-Completed-brightgreen)

This plan covers the implementation of the "صحتي" (Smart Health Hub) feature, replacing the current Records screen. It follows Clean Architecture and uses Riverpod for state management.

## 1. Requirements & Constraints

- **REQ-001**: Clean Architecture (Domain, Data, Presentation layers).
- **REQ-002**: Use `Manual NotifierProvider` / `AsyncNotifierProvider` as per existing patterns.
- **REQ-003**: Arabic-first UI (RTL).
- **REQ-004**: Use `HakimColorScheme` and `HakimSpacing` tokens.
- **REQ-005**: Implementation must be modular (one file per widget/class).
- **REQ-006**: Include `AiDisclaimerBanner` for all AI-generated content.

## 2. Implementation Steps

### Phase 1.1: Research & Core Domain

- GOAL-1.1: Research optimal packages and define models/repositories.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-1.1.0 | Research packages for chart visualization (e.g., `fl_chart`), trend analysis, and PDF/file sharing. Findings: Use `fl_chart` for now; consider Syncfusion for clinical ranges later. Use `encrypt` for secure storage. | ✅ | 2026-05-30 |
| TASK-1.1.1 | Create directory structure `lib/features/smart_health/{domain/models,data/repositories,presentation/{providers,screens,widgets}}` | ✅ | 2026-05-30 |
| TASK-1.1.2 | Create `lib/features/smart_health/domain/models/lab_flag.dart` (Model for individual lab results) | ✅ | 2026-05-30 |
| TASK-1.1.3 | Create `lib/features/smart_health/domain/models/health_summary.dart` (Main model for the screen) | ✅ | 2026-05-30 |
| TASK-1.1.4 | Create `lib/features/smart_health/domain/models/doctor_note.dart` (Model for notes with raw/simplified text) | ✅ | 2026-05-30 |
| TASK-1.1.5 | Create `lib/features/smart_health/data/repositories/smart_health_repository.dart` (Abstract repository interface) | ✅ | 2026-05-30 |
| TASK-1.1.6 | Create `lib/features/smart_health/data/repositories/mock_smart_health_repository.dart` (Mock implementation) | ✅ | 2026-05-30 |

### Phase 1.2: State Management & Shared Widgets

- GOAL-1.2: Implement the state notifier and necessary shared widgets.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-1.2.1 | Create `lib/shared/widgets/ai_disclaimer_banner.dart` (Shared component for AI transparency) | ✅ | 2026-05-30 |
| TASK-1.2.2 | Create `lib/features/smart_health/presentation/providers/smart_health_provider.dart` (Notifier for health state) | ✅ | 2026-05-30 |

### Phase 1.3: Presentation Layer (Widgets)

- GOAL-1.3: Build the individual widgets for the Smart Health screen.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-1.3.1 | Create `lib/features/smart_health/presentation/widgets/health_summary_ai_card.dart` | ✅ | 2026-05-30 |
| TASK-1.3.2 | Create `lib/features/smart_health/presentation/widgets/symptom_checkin_card.dart` | ✅ | 2026-05-30 |
| TASK-1.3.3 | Create `lib/features/smart_health/presentation/widgets/lab_result_tile.dart` | ✅ | 2026-05-30 |
| TASK-1.3.4 | Create `lib/features/smart_health/presentation/widgets/doctor_notes_card.dart` | ✅ | 2026-05-30 |
| TASK-1.3.5 | Create `lib/features/smart_health/presentation/widgets/smart_health_record_tile.dart` (Migrated logic) | ✅ | 2026-05-30 |

### Phase 1.4: Presentation Layer (Screen) & Integration

- GOAL-1.4: Assemble the screen and integrate it into the app layout.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-1.4.1 | Create `lib/features/smart_health/presentation/screens/smart_health_screen.dart` | ✅ | 2026-05-30 |
| TASK-1.4.2 | Register `SmartHealthScreen` in `MainLayoutScreen` (replaces `RecordsScreen`) | ✅ | 2026-05-30 |
| TASK-1.4.3 | Update `CustomBottomNavBar` icons and labels | ✅ | 2026-05-30 |

## 3. Alternatives

- **ALT-001**: Using code generation (Freezed/Riverpod Generator) - Deferred to match current project style (manual).

## 4. Dependencies

- **DEP-001**: `HakimColorScheme` and `HakimSpacing` for UI consistency.
- **DEP-002**: `MainLayoutScreen` and `CustomBottomNavBar` for integration.

## 5. Files

(See task list for specific file paths)

## 6. Testing

- **TEST-001**: Verify `MockSmartHealthRepository` returns consistent mock data.
- **TEST-002**: Verify `SmartHealthScreen` renders all sections correctly in RTL.
- **TEST-003**: Verify `AiDisclaimerBanner` visibility based on confirmation status.

## 7. Risks & Assumptions

- **RISK-001**: Breaking existing navigation - Mitigation: Test PageView indices carefully.
- **ASSUMPTION-001**: All AI content should be displayed with a disclaimer by default.
