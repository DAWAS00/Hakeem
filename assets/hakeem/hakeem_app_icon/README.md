# Hakeem — App Icon export

Production launcher-icon assets for the **Hakeem** (حكيم) app — Heritage
direction (the حكيم wordmark with a stethoscope draped over it). Drop straight
into a Flutter project with `flutter_launcher_icons`.

Palette: `#0A6FB0 → #00538F → #013F73` gradient, cyan stethoscope `#74D8F2`,
white word. Type: **Cairo 800** (already rasterised into the PNGs — you do **not**
need the font installed to use these).

---

## Files

```
hakeem_app_icon/
├── icon_1024.png                 ← MASTER. Full-bleed square (iOS rounds it itself).
├── icon_dark_1024.png            ← iOS 18 dark-appearance variant
├── icon_tinted_1024.png          ← iOS 18 tinted / monochrome variant
├── android/
│   ├── adaptive_background.png   ← gradient layer (108dp, full-bleed)
│   ├── adaptive_foreground.png   ← word + stethoscope, inset to the safe zone, transparent
│   └── monochrome_foreground.png ← white mark only, for Android 13+ themed icons
├── web/
│   ├── maskable_512.png          ← PWA maskable icon
│   ├── favicon_512.png / 192 / 32 / 16
│   └── (favicon uses a bold stethoscope glyph — the word is dropped because it
│        is illegible below ~32px)
└── source/
    ├── icon.svg                  ← vector master (word is a <text> element, Cairo)
    ├── adaptive_foreground.svg
    └── adaptive_background.svg
```

> The square PNGs have **no rounded corners on purpose** — iOS and every Android
> launcher apply their own mask. Never pre-round a launcher source.

---

## 1. Put the files in your project

```
assets/
└── icon/
    ├── icon_1024.png
    ├── adaptive_background.png
    ├── adaptive_foreground.png
    └── monochrome_foreground.png
```

(Copy from `android/` into the same folder, or adjust the paths below.)

## 2. Generate every size with `flutter_launcher_icons`

`pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  image_path: "assets/icon/icon_1024.png"        # iOS + legacy Android
  android: "ic_launcher"
  ios: true

  # Android adaptive icon (API 26+)
  adaptive_icon_background: "assets/icon/adaptive_background.png"
  adaptive_icon_foreground: "assets/icon/adaptive_foreground.png"
  adaptive_icon_monochrome: "assets/icon/monochrome_foreground.png"

  remove_alpha_ios: true

  # Optional web favicons
  web:
    generate: true
    image_path: "assets/icon/icon_1024.png"
    background_color: "#013F73"
    theme_color: "#00538F"
```

Then run:

```bash
flutter pub get
dart run flutter_launcher_icons
```

That writes every iOS `AppIcon.appiconset` size and the Android
`mipmap-*/ic_launcher` + adaptive XML for you.

## 3. (Optional) iOS dark & tinted variants

`flutter_launcher_icons` doesn't yet wire up the iOS 18 dark/tinted slots
automatically. If you want them, open
`ios/Runner/Assets.xcassets/AppIcon.appiconset` in Xcode and drop
`icon_dark_1024.png` and `icon_tinted_1024.png` into the **Dark** and **Tinted**
appearance wells.

## 4. Web favicon

Use the files in `web/` directly (they read better at small sizes than the full
icon). In `web/index.html`:

```html
<link rel="icon" type="image/png" sizes="32x32" href="favicon_32.png">
<link rel="icon" type="image/png" sizes="16x16" href="favicon_16.png">
<link rel="apple-touch-icon" href="favicon_192.png">
```

For the PWA manifest, point `maskable_512.png` at a `"purpose": "maskable"` entry.

---

## Need a different cut?

The vector masters are in `source/`. Edit there and re-export, or ask and I can
regenerate the PNG pack with a tweaked composition, the Care/Monitor/Classic
mark instead, or a flat (non-gradient) background.
