# Doctor AI Mascot — Flutter Icon Set

Healthcare assistant mascot (the "OG Square" direction) exported as 10 emotion frames + 1 default `icon.svg`.

## What's inside

```
flutter_icons/
├── icon.svg              # Default idle icon (with blink + breathing SMIL animation)
├── static/               # ONE FRAME PER EMOTION — flutter_svg compatible
│   ├── idle.svg
│   ├── happy.svg
│   ├── thinking.svg
│   ├── listening.svg
│   ├── curious.svg
│   ├── sleepy.svg
│   ├── surprised.svg
│   ├── sad.svg
│   ├── scanning.svg
│   └── celebrating.svg
└── animated/             # SAME EMOTIONS, with SMIL animations
    └── (same 10 files, with <animate> tags)
```

## Two sets — which one do I use?

| Set | When to use | Notes |
|---|---|---|
| **`static/`** | Production Flutter app | One frame per emotion. Renders perfectly with `flutter_svg`. Animate transitions and idle motion (blink, breathing) in Flutter using `AnimationController`. |
| **`animated/`** | Web preview / motion reference / Rive import | Includes SMIL `<animate>` tags. `flutter_svg` does **not** play SMIL. Useful as a reference for the motion design or to import into Rive/Lottie. |

## Specs

- **viewBox:** `0 0 200 240` (room for the stethoscope crown above the head)
- **Strokes:** 3–4px black (`#1f1a14`)
- **Face fill:** light blue (`#cfe5f7`)
- **Pupil color:** medical blue (`#1565c0`)
- **Accent color:** medical coral (`#d94d3f`) — used on the stethoscope chest piece and "thinking ?" / sparkles
- **Secondary accent:** teal (`#2a8c8a`) — used on the scan beam and listening soundwaves
- All files are stroke-based vector — recolor by find-and-replacing the hex values, or wrap with `colorFilter` in Flutter.

## Flutter integration

### 1. Add the dependency

```yaml
dependencies:
  flutter_svg: ^2.0.10+1
```

### 2. Register the assets in `pubspec.yaml`

```yaml
flutter:
  assets:
    - assets/icons/static/
```

(Copy the `static/` folder to `assets/icons/static/` in your project.)

### 3. Drive the mascot with an enum

```dart
enum MascotMood {
  idle, happy, thinking, listening, curious,
  sleepy, surprised, sad, scanning, celebrating,
}

String mascotAsset(MascotMood m) =>
    'assets/icons/static/${m.name}.svg';
```

### 4. A reusable `DoctorFab` widget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorFab extends StatefulWidget {
  final MascotMood mood;
  final VoidCallback onTap;
  const DoctorFab({super.key, required this.mood, required this.onTap});

  @override
  State<DoctorFab> createState() => _DoctorFabState();
}

class _DoctorFabState extends State<DoctorFab>
    with TickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.03).animate(
          CurvedAnimation(parent: _breath, curve: Curves.easeInOut),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: anim,
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: SvgPicture.asset(
            mascotAsset(widget.mood),
            key: ValueKey(widget.mood),
            width: 72,
            height: 86,
          ),
        ),
      ),
    );
  }
}
```

### 5. Tap interaction (surprised → opens chat)

```dart
MascotMood _mood = MascotMood.idle;

void _onTap() async {
  setState(() => _mood = MascotMood.surprised);
  await Future.delayed(const Duration(milliseconds: 350));
  await _openChatSheet(context);
  setState(() => _mood = MascotMood.listening);
}
```

### 6. Use as a FAB

```dart
floatingActionButton: DoctorFab(
  mood: _mood,
  onTap: _onTap,
),
```

## Trigger map — when to set each mood

| Mood | Trigger |
|---|---|
| `idle` | Default. Home, dashboard, between actions. |
| `thinking` | While the AI is generating a reply. |
| `listening` | Chat sheet is open, user can speak / type. |
| `curious` | User is browsing a list or catalogue screen. |
| `scanning` | OCR / prescription scan / image diagnostic flow. |
| `happy` | Positive confirmation (appointment booked, normal results). |
| `celebrating` | Milestone (treatment complete, streak unlocked). |
| `sleepy` | After N minutes inactive, or returning from background. |
| `surprised` | Tap (one-shot ~350ms before opening chat); incoming notification. |
| `sad` | Error, cancellation, concerning lab result. |

## Beyond static SVG — full motion

For richer in-icon animation (thinking dots pulsing, scan beam moving, sparkles), you have three options:

1. **Stay with `flutter_svg` + Flutter animations.** Use a `CustomPainter` overlay to draw the animated extras on top of the static SVG. Cheapest path.
2. **Import to [Rive](https://rive.app/).** The animated SVGs in `animated/` can be opened in Inkscape / Figma / Rive to recreate motion. Rive plays smoothly in Flutter via the `rive` package.
3. **Convert to Lottie.** Open the animated SVGs in After Effects, recreate the motion, export as Lottie JSON, render with the `lottie` package.

## Recoloring

All paths use named hex colors. To match a different brand:

| Token | Default | Where it's used |
|---|---|---|
| Ink / stroke | `#1f1a14` | All outlines |
| Face fill | `#cfe5f7` | Face rectangle |
| Pupil | `#1565c0` | Eye pupils |
| Accent | `#d94d3f` | Chest piece, sparkles, "?" |
| Accent 2 | `#2a8c8a` | Scan beam, soundwaves |

Find-and-replace in the SVG source, or use `SvgPicture.asset(..., colorFilter: ColorFilter.mode(...))` if you only need a tint.
