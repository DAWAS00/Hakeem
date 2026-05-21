# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Analyze (must stay clean — 0 issues)
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/core/utils/validators_test.dart

# Install / sync dependencies
flutter pub get

# Code generation (freezed models, Riverpod providers with @riverpod annotation)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code gen during development
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

Clean architecture with three layers per feature: **domain → data → presentation**. Dependencies only flow inward (presentation may use domain; data implements domain; nothing imports from presentation).

```
lib/
├── core/                        # Shared across all features
│   ├── constants/               # HakimColors, HakimSpacing (design tokens)
│   ├── theme/                   # AppTheme.dark (Material3, Cairo font)
│   ├── router/                  # GoRouter — add new routes here
│   └── utils/                   # Validators (static methods, unit-tested)
└── features/<feature>/
    ├── domain/
    │   ├── enums/               # Shared enums (e.g. LoginMethod)
    │   ├── entities/            # Pure Dart classes, no framework deps
    │   ├── repositories/        # abstract interface — data implements these
    │   └── usecases/            # One class per use case, takes repository
    ├── data/
    │   ├── models/              # Extend entities, add fromJson/toJson
    │   ├── datasources/         # abstract interface + impl (Dio calls)
    │   ├── repositories/        # Implements domain repository interface
    │   └── providers/           # Riverpod DI: dio → datasource → repo → usecase
    └── presentation/
        ├── providers/           # Notifier + State classes (no AsyncNotifier yet)
        ├── screens/             # ConsumerStatefulWidget; one per route
        └── widgets/             # Small, single-responsibility StatelessWidgets
```

## State Management

Riverpod without code generation (`NotifierProvider<Notifier, State>` pattern). Each feature's state is a plain immutable class with a `copyWith` that accepts a `clearError: bool` flag.

The `LoginNotifier` wires everything together: checks connectivity before API calls, maps `DioException` codes to Arabic error strings, and checks biometric support on `build()`.

DI chain lives in `data/providers/`: `dioProvider → authDatasourceProvider → authRepositoryProvider → loginUseCaseProvider`. Override these in tests instead of mocking the notifier.

## Key Conventions

- **App-level RTL**: `Directionality(rtl)` is set in `main.dart`'s `builder`. Do not add per-widget `Directionality` unless a specific sub-tree needs LTR (e.g. phone number input).
- **Design tokens**: Always use `HakimColors.*` and `HakimSpacing.*`. No hardcoded hex values or pixel values.
- **Input fields**: All `TextFormField` decoration goes through `InputDecorationFactory.build(...)`. Do not construct `InputDecoration` directly in widget files.
- **Animations**: Use `flutter_animate` (`.animate().fadeIn()`, `.slideY()`, `.shake()`). In tests, call `await tester.pump(const Duration(milliseconds: 600))` after `pumpWidget` to advance past animations instead of `pumpAndSettle`.
- **Linter**: `prefer_single_quotes`, `require_trailing_commas`, `avoid_print` are enforced. Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from analysis.

## Adding a New Feature

1. Create `lib/features/<name>/domain/` — entities, repository interface, use cases.
2. Create `lib/features/<name>/data/` — models, datasource impl, repository impl, Riverpod providers.
3. Create `lib/features/<name>/presentation/` — State class, Notifier, screen, widgets.
4. Register the new route in `lib/core/router/app_router.dart`.
5. Add unit tests for the use case and state class under `test/features/<name>/`.

## Platform Notes

- **`local_auth`** requires `USE_BIOMETRIC` permission in `android/app/src/main/AndroidManifest.xml` and `NSFaceIDUsageDescription` in `ios/Runner/Info.plist` to work at runtime (not wired yet).
- **`flutter_secure_storage`** requires `minSdkVersion 18` on Android.
- API base URL is `https://api.hakeem.jo` — set in `dioProvider` inside `auth_providers.dart`.
