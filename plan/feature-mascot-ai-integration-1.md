---
goal: Integrate Mascot-based "Hakim" identity with new AI Assistant
version: 1.0
date_created: 2026-05-30
last_updated: 2026-05-30
owner: Gemini
status: 'Completed'
tags: [feature, ai_assistant, mascot, fab, redesign]
---

# Introduction

![Status: Completed](https://img.shields.io/badge/status-Completed-brightgreen)

The Hakeem app utilizes a "Mascot" identity for its AI. This plan pivots the AI Assistant from a dedicated navigation tab to a **persistent Mascot-based Floating Action Button (FAB)** that triggers a high-fidelity AI experience. The mascot acts as a dynamic indicator of the AI's state and is accessible from every primary screen.

## 1. Requirements & Constraints

- **REQ-001**: Remove the "AI Assistant" tab from the bottom navigation.
- **REQ-002**: Implement a global `MascotFab` that persists across `Dashboard`, `Smart Health`, `Home`, and `Family Hub`.
- **REQ-003**: Tap on Mascot FAB opens the `AiAssistantOverlay` (a full-screen or large bottom-sheet chat experience).
- **REQ-004**: Long Press on Mascot FAB triggers "Direct Voice Mode" immediately.
- **REQ-005**: Synchronize `MascotState` (moods) with the `AssistantProvider` (thinking, listening, idle).
- **REQ-006**: Utilize the high-fidelity chat widgets (bubbles, input) built in Phase 2 within the new overlay.
- **CON-001**: Use `Hero` animations to transition the Mascot from the FAB into the AI interface.

## 2. Implementation Steps

### Phase 2.6: State & Architecture Pivot

- GOAL-2.6: Prepare the provider and navigation for a global FAB.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.6.1 | Update `AssistantProvider` to manage the global `MascotMood` and expose it to the FAB. | ✅ | 2026-05-30 |
| TASK-2.6.2 | Revert `CustomBottomNavBar` to 4 items (Dashboard, Home, Smart Health, Family Hub). | ✅ | 2026-05-30 |
| TASK-2.6.3 | Update `MainLayoutScreen` to remove the `AiAssistantScreen` from the `PageView`. | ✅ | 2026-05-30 |

### Phase 2.7: The Global Mascot FAB

- GOAL-2.7: Build the personality-driven floating entry point.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.7.1 | Create `lib/features/ai_assistant/presentation/widgets/global_mascot_fab.dart` (Animated Mascot with state-sync). | ✅ | 2026-05-30 |
| TASK-2.7.2 | Integrate `GlobalMascotFab` into the `Scaffold` of `MainLayoutScreen`. | ✅ | 2026-05-30 |

### Phase 2.8: AI Assistant Overlay implementation

- GOAL-2.8: Transform the screen into an immersive overlay.

| Task | Description | Completed | Date |
|------|-------------|-----------|------|
| TASK-2.8.1 | Create `lib/features/ai_assistant/presentation/widgets/ai_assistant_overlay.dart` (Immersive overlay chat). | ✅ | 2026-05-30 |
| TASK-2.8.2 | Implement transition logic (FAB tap -> overlay entry). | ✅ | 2026-05-30 |
| TASK-2.8.3 | Finalize "Direct Voice" logic (Mascot Long Press -> Open Overlay -> Start Mic). | ✅ | 2026-05-30 |
