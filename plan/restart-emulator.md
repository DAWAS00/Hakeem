---
goal: Restart Android Emulator and Fix Black Screen
version: 1.0
date_created: 2026-07-05
last_updated: 2026-07-05
owner: Antigravity
status: 'Completed'
tags: [emulator, troubleshooting, android, adb]
---

# Introduction

The Android emulator is currently showing a black screen and its status is `offline`. We will force-stop the running emulator/QEMU processes, reset the ADB server, and start the emulator again with a cold boot (`-no-snapshot-load`) to ensure it boots up correctly.

## 1. Requirements & Constraints

- **REQ-001**: Stop all hanging emulator and QEMU processes (`emulator.exe`, `qemu-system-x86_64.exe`).
- **REQ-002**: Restart the ADB server to clear any stale connections.
- **REQ-003**: Start the `Pixel_10_Pro_XL` emulator using a cold boot (`-no-snapshot-load`) to bypass corrupted state snapshots.
- **CON-001**: Ensure the emulator starts asynchronously and doesn't block the development flow.

## 2. Implementation Steps

### Phase 1: Clean Up Stale Processes

- GOAL-1: Kill hung emulator processes and reset ADB.

| Task | Description | Status |
|------|-------------|--------|
| TASK-1.1 | Terminate `qemu-system-x86_64` and `emulator` processes. | ✅ Completed |
| TASK-1.2 | Reset ADB connection (kill/start server). | ✅ Completed |

### Phase 2: Launch Emulator

- GOAL-2: Start the emulator cleanly.

| Task | Description | Status |
|------|-------------|--------|
| TASK-2.1 | Launch the `Pixel_10_Pro_XL` AVD with a cold boot (`-no-snapshot-load`). | ✅ Completed |
| TASK-2.2 | Verify the emulator is online via `flutter devices`. | ✅ Completed |

