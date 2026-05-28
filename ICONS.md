# Hakeem — Icon Inventory

All icons currently used across the app. Replace each with a custom `.svg` file.
Two icon families in use: **HugeIcons** (stroke/rounded style) and **Material Icons** (outlined style).

---

## HugeIcons — 24 icons

These are the primary icon set. All use the `strokeRounded` style (thin, rounded stroke lines).

| # | Icon name | Where used | Purpose |
|---|-----------|------------|---------|
| 1 | `strokeRoundedActivity01` | Home quick actions | Health vitals / activity chart |
| 2 | `strokeRoundedAdd01` | Speed dial FAB | Add / create new item |
| 3 | `strokeRoundedAiChat01` | Home service card + quick actions | AI health chat |
| 4 | `strokeRoundedAmbulance` | Home service card + quick actions | Emergency services |
| 5 | `strokeRoundedArrowLeft01` | Signup top bar, appointment card | Back / previous |
| 6 | `strokeRoundedCalendar03` | Bottom nav, home quick actions, appointment card, identity step | Appointments / dates |
| 7 | `strokeRoundedFolder01` | Home service card + quick actions | Medical records / documents |
| 8 | `strokeRoundedHome01` | Bottom nav (Home tab) | Home |
| 9 | `strokeRoundedHospital01` | Home service card + quick actions | Clinics / hospitals |
| 10 | `strokeRoundedHospital02` | Brand header logo | App logo (main brand mark) |
| 11 | `strokeRoundedIdentityCard` | Signup identity step | National ID card field |
| 12 | `strokeRoundedInvoice01` | Home service card + quick actions | Bills / invoices |
| 13 | `strokeRoundedLockPassword` | Password field prefix | Password |
| 14 | `strokeRoundedMedicine01` | Bottom nav, home quick actions | Medications |
| 15 | `strokeRoundedMicroscope` | Home service card + quick actions | Lab results |
| 16 | `strokeRoundedMoon01` | Theme toggle button | Switch to dark mode |
| 17 | `strokeRoundedNotification03` | Home header | Notifications bell |
| 18 | `strokeRoundedSettings01` | Bottom nav (Settings tab), home quick actions | Settings |
| 19 | `strokeRoundedSmartPhone01` | Phone number field prefix | Phone / mobile |
| 20 | `strokeRoundedSun01` | Theme toggle button | Switch to light mode |
| 21 | `strokeRoundedTick01` | Signup stepper bar (completed step) | Done / completed step |
| 22 | `strokeRoundedUser` | Bottom nav (Profile tab), identity step fields | User / person |
| 23 | `strokeRoundedView` | Password field eye toggle | Show password |
| 24 | `strokeRoundedViewOffSlash` | Password field eye toggle | Hide password |

---

## Material Icons — 42 icons

Secondary icon set used in forms and contextual UI. All use the `outlined` or `rounded` variant.

| # | Icon name | Where used | Purpose |
|---|-----------|------------|---------|
| 1 | `Icons.account_balance_outlined` | Signup Sanad banner | Government / Sanad |
| 2 | `Icons.add` | Health step — add allergy/medication | Add item |
| 3 | `Icons.arrow_forward_rounded` | Signup step "Next" button | Forward / next |
| 4 | `Icons.article_outlined` | Consent step — Terms item | Terms & conditions document |
| 5 | `Icons.badge_outlined` | National ID field, Sanad button, signup step indicator | ID badge |
| 6 | `Icons.calendar_month_outlined` | Signup personal — birth date field | Date / calendar |
| 7 | `Icons.check` | Signup step indicator (done state) | Generic checkmark |
| 8 | `Icons.check_circle_outline_rounded` | Consent step — checked item | Checked / confirmed |
| 9 | `Icons.check_rounded` | Medication schedule card — taken state | Taken / done |
| 10 | `Icons.credit_card_outlined` | Signup personal — ID number field | ID card / number |
| 11 | `Icons.email_outlined` | Signup contact — email field | Email |
| 12 | `Icons.error_outline` | Error banner | Error / alert |
| 13 | `Icons.error_outline_rounded` | Home error view | Error state |
| 14 | `Icons.fact_check_outlined` | Consent step — data accuracy item | Fact check / accuracy |
| 15 | `Icons.favorite_border_rounded` | Health step — blood type field | Heart / blood type |
| 16 | `Icons.favorite_outline` | Signup step indicator (health step) | Health |
| 17 | `Icons.female_rounded` | Signup personal — gender selection | Female |
| 18 | `Icons.fingerprint` | Biometric login button | Fingerprint / biometrics |
| 19 | `Icons.gavel_outlined` | Consent step — legal terms item | Legal / law |
| 20 | `Icons.height` | Health step — height field | Height / stature |
| 21 | `Icons.home_outlined` | Signup contact — home address field | Home address |
| 22 | `Icons.info_outline` | Consent step — info note | Information |
| 23 | `Icons.info_outline_rounded` | Consent step — info note (rounded) | Information (rounded) |
| 24 | `Icons.keyboard_arrow_down_rounded` | Dropdown selectors (blood type, governorate) | Dropdown chevron |
| 25 | `Icons.location_city_outlined` | Signup contact — city field | City |
| 26 | `Icons.location_on_outlined` | Signup contact — address field | Location pin |
| 27 | `Icons.lock_outline` | Signup personal — locked ID field | Locked / read-only |
| 28 | `Icons.lock_outline_rounded` | Signup locked step row | Locked step |
| 29 | `Icons.male_rounded` | Signup personal — gender selection | Male |
| 30 | `Icons.map_outlined` | Signup contact — governorate field | Map / region |
| 31 | `Icons.medication_outlined` | Health step — medications/allergies field | Medication pill |
| 32 | `Icons.monitor_heart_outlined` | Splash screen animation | Heart monitor / ECG |
| 33 | `Icons.monitor_weight_outlined` | Health step — weight field | Weight / scale |
| 34 | `Icons.notifications_outlined` | Consent step — notification permissions | Notifications |
| 35 | `Icons.person_outline_rounded` | Signup personal — full name field | Person / name |
| 36 | `Icons.phone_outlined` | Signup contact — phone field | Phone number |
| 37 | `Icons.shield_outlined` | Trust badge (government badge) | Security / official |
| 38 | `Icons.sms_outlined` | OTP hint banner | SMS / text message |
| 39 | `Icons.verified_outlined` | Signup step indicator (consent step) | Verified |
| 40 | `Icons.verified_user_outlined` | Splash screen, consent header | Verified user / official |
| 41 | `Icons.warning_amber_outlined` | Health step — allergies warning | Warning / caution |
| 42 | `Icons.water_drop_outlined` | Health step — blood type field | Water drop / blood |

---

## Summary

| Family | Count | Style |
|--------|-------|-------|
| HugeIcons | 24 | Thin stroke, rounded corners |
| Material Icons | 42 | Outlined / rounded |
| **Total** | **66** | |

---

## Design Notes

- HugeIcons are already thin-stroke SVGs — match that weight (1.5–2px stroke at 24×24)
- Material `_outlined` icons use a 1px stroke at 24×24 viewBox
- Material `_rounded` icons have rounded line caps/joins
- The app logo uses `strokeRoundedHospital02` — this is the most important custom icon
- All icons render at sizes 12–32px; design at 24×24 with clean paths that scale down
- App color for icons: `c.info` (blue `#3B82F6` dark / `#1D4ED8` light) for active, `c.textHint` for muted
