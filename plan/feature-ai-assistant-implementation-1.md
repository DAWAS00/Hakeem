---
goal: Implement حكيم AI Assistant (Phase 2)
version: 1.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: Gemini
status: 'Completed'
tags: [feature, ai_assistant, nlp, voice, redesign]
---

# Introduction

![Status: Completed](https://img.shields.io/badge/status-Completed-brightgreen)

Phase 2 replaces the low-utility `AppointmentsScreen` with "**حكيم AI**", a conversational assistant that provides patients with quick answers about their health, appointments, and medications. Existing appointment booking functionality is preserved as a suggested action within this new interface.

## 1. Requirements & Constraints

- **REQ-001**: Clean Architecture (Domain, Data, Presentation).
- **REQ-002**: RTL Chat UI with distinct bubbles for User and AI.
- **REQ-003**: Suggested Action Chips (e.g., "متى موعدي القادم؟").
- **REQ-004**: Voice Input Support (Mic button) for elderly accessibility.
- **REQ-005**: Source Tagging: AI responses must indicate data source (e.g., `[من مواعيدك]`).
- **REQ-006**: Safety Guardrails: Automated footer for symptom-related queries.
- **REQ-007**: Elderly Mode: Support for larger fonts and tap targets.
- **CON-001**: Use `speech_to_text` for voice and `flutter_animate` for AI shimmers.

## 2. Implementation Steps

### Phase 2.1: Research & Core Domain

- GOAL-2.1: Research optimal packages and define assistant models.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.1.0 | Research packages for NLP/Chat UI (e.g., `flutter_chat_ui` vs custom) and Voice (`speech_to_text`). Findings: Use custom UI for full design system control; `speech_to_text` for native voice performance. | ✅ | 2026-05-30 |
| TASK-2.1.1 | Create directory structure `lib/features/ai_assistant/{domain/models,data/repositories,presentation/{providers,screens,widgets}}` | ✅ | 2026-05-30 |
| TASK-2.1.2 | Create `lib/features/ai_assistant/domain/models/chat_message.dart` (Model for message, role, and source tags). | ✅ | 2026-05-30 |
| TASK-2.1.3 | Create `lib/features/ai_assistant/domain/repositories/assistant_repository.dart` (Abstract interface for sending queries). | ✅ | 2026-05-30 |

### Phase 2.2: Data Layer & Migration

- GOAL-2.2: Implement mock repository and migrate legacy triage logic.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.2.1 | Create `lib/features/ai_assistant/data/repositories/mock_assistant_repository.dart` (Returns streamed mock responses). | ✅ | 2026-05-30 |
| TASK-2.2.2 | Migrate `_showTriageModal()` logic from `AppointmentsScreen` to `lib/features/ai_assistant/presentation/widgets/triage_modal.dart`. | ✅ | 2026-05-30 |

### Phase 2.3: State Management

- GOAL-2.3: Implement the assistant state notifier.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.3.1 | Create `lib/features/ai_assistant/presentation/providers/assistant_provider.dart` (Manages chat list, loading, and voice states). | ✅ | 2026-05-30 |

### Phase 2.4: Presentation Layer (Widgets)

- GOAL-2.4: Build modular UI components for the chat interface.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.4.1 | Create `lib/features/ai_assistant/presentation/widgets/chat_bubble.dart` (RTL, user vs AI styling, source tags). | ✅ | 2026-05-30 |
| TASK-2.4.2 | Create `lib/features/ai_assistant/presentation/widgets/suggestion_chips_row.dart` (Horizontal scrollable action chips). | ✅ | 2026-05-30 |
| TASK-2.4.3 | Create `lib/features/ai_assistant/presentation/widgets/voice_input_button.dart` (Mic button with pulse/shimmer animations). | ✅ | 2026-05-30 |
| TASK-2.4.4 | Create `lib/features/ai_assistant/presentation/widgets/chat_input_row.dart` (Text field + Send button). | ✅ | 2026-05-30 |

### Phase 2.5: Presentation Layer (Screen) & Integration

- GOAL-2.5: Assemble the screen and finalize navigation.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.5.1 | Create `lib/features/ai_assistant/presentation/screens/ai_assistant_screen.dart` (Assemble header + chat + input). | ✅ | 2026-05-30 |
| TASK-2.5.2 | Register `AiAssistantScreen` in `MainLayoutScreen` (replaces `AppointmentsScreen`). | ✅ | 2026-05-30 |
| TASK-2.5.3 | Update `CustomBottomNavBar` icons (index 1 to `HakimIcons.aiChat01`) and label to `'حكيم'`. | ✅ | 2026-05-30 |
| TASK-2.5.4 | Create `lib/features/ai_assistant/presentation/widgets/ai_assistant_overlay.dart` — bottom sheet variant of the assistant, callable from other screens. | ✅ | 2026-05-30 |
| TASK-2.6.1 | **Frontend Enhancement** — Add typing indicator bubble, message entrance animations, AI avatar in bubbles, timestamps, ambient empty-state glow, staggered chip animations, SafeArea in input row. | ✅ | 2026-05-30 |

## 3. Alternatives

- **ALT-001**: Using a pre-built chat UI package - Rejected to ensure full RTL control and design system alignment.

## 4. Dependencies

- **DEP-001**: `speech_to_text` for voice capabilities.
- **DEP-002**: `flutter_animate` for high-fidelity AI feedback animations.

## 5. Files

(See task list for specific file paths)

## 6. Testing

- **TEST-001**: Verify `AssistantNotifier` correctly appends messages and handles streamed responses.
- **TEST-002**: Widget test for `ChatBubble` RTL alignment and source tag visibility.
- **TEST-003**: Verify "احجز موعداً" chip correctly triggers the `TriageModal`.

## 7. Risks & Assumptions

- **RISK-001**: Complexity of voice-to-text accuracy in Arabic dialects - Mitigation: Clear "Try speaking again" feedback.
- **ASSUMPTION-001**: Users prefer a conversational interface over a static schedule list.
