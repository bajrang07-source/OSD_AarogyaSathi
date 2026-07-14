# ArogyaSathi AI

> **Offline-first rural health assistant for India**
> Built with Flutter · Works without internet · Supports English, Hindi & Marathi

---

## Project Status

| Phase | Feature | Status |
|-------|---------|--------|
| **0** | Architecture & Project Skeleton | ✅ Complete |
| 1 | Local Database & Static Content | 🔜 Next |
| 2 | Offline First-Aid Knowledge Base | 🔜 Planned |
| 3 | Rule-Based Symptom Triage | 🔜 Planned |
| 4 | On-Device NLP | 🔜 Planned |
| 5 | Smart Hospital Recommendation | 🔜 Planned |
| 6 | Emergency Transport Directory | 🔜 Planned |
| 7 | Offline Voice Assistant | 🔜 Planned |
| 8 | Offline Maps & Routing | 🔜 Planned |
| 9 | Prescription OCR | 🔜 Planned |
| 10 | Medication Reminders | 🔜 Planned |
| 11 | Encrypted Health Card | 🔜 Planned |
| 12 | Localization (hi/mr/en) | 🔜 Planned |
| 13 | Optional Cloud Sync | 🔜 Planned |
| 14 | Hardening & Packaging | 🔜 Planned |

---

## Setup

### Prerequisites

- Flutter SDK ≥ 3.3.0 — [Install Flutter](https://docs.flutter.dev/get-started/install/windows)
- Android SDK (API 21+) / Android Studio
- A physical Android device or emulator

### Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on connected device or emulator
flutter run

# 3. Analyse code
flutter analyze

# 4. Run tests
flutter test
```

---

## Architecture

```
lib/
├── core/
│   ├── constants/    # AppRoutes, AppStrings
│   ├── router/       # go_router configuration
│   └── theme/        # Material 3 light + dark theme, AppColors
├── data/
│   ├── local_db/     # sqflite migrations (Phase 1+)
│   ├── models/       # Dart model classes
│   └── repositories/ # Repository pattern (Phase 1+)
├── features/
│   ├── home/
│   ├── symptom_checker/
│   ├── first_aid/
│   ├── hospitals/
│   ├── health_card/
│   └── transport/
└── services/
    ├── ai/           # On-device NLP (Phase 4)
    ├── db/           # DatabaseService singleton
    ├── location/     # GPS (Phase 5)
    ├── ocr/          # Prescription OCR (Phase 9)
    └── tts_stt/      # Voice (Phase 7)
```

## Key Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State management | `flutter_riverpod` | Compile-safe, testable, scales well |
| Navigation | `go_router` | Flutter-team recommended, deep-link ready |
| Local DB | `sqflite` | Battle-tested, no FFI issues |
| Typography | Noto Sans | Supports Latin + Devanagari (Hindi/Marathi) |
| Design | Material 3 | Accessible, consistent, responsive |

## Offline-First Guarantee

Every feature (Phases 1–12) is designed to work **100% without network access**.
The only network-dependent feature (Phase 13 — cloud sync) is opt-in and additive.

## Known Limitations (Phase 0)

- All data shown is mock/placeholder — real DB seeding in Phase 1
- GPS, camera, microphone permissions are declared but not yet used
- No actual AI model loaded — Phase 4
- Localization strings are hardcoded — Phase 12 will add ARB files

---

*Target platform: Android (API 21+). iOS support planned as stretch goal.*
