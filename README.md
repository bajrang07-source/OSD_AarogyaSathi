# 🏥 AarogyaSathi AI — Offline Rural Health Assistant

> An **offline-first** AI health assistant for rural India — works without internet, supports English, Hindi & Marathi, built for Palghar District, Maharashtra.

---

## 🚀 Quick Start — Run on Any Laptop (No Flutter Needed!)

### Prerequisites
Only **Python** is required. It is pre-installed on macOS/Linux. For Windows, download from [python.org](https://www.python.org/downloads/) and check **"Add Python to PATH"** during install.

---

### ▶️ Windows
1. Clone / download this repository
2. **Double-click `start.bat`**
3. The app opens automatically at **http://localhost:3000**

```
AarogyaSathi/
└── start.bat   ← Double-click this!
```

---

### ▶️ macOS / Linux
1. Clone / download this repository
2. Open Terminal in the project folder
3. Run:
```bash
chmod +x start.sh
./start.sh
```
4. The app opens at **http://localhost:3000**

---

### ▶️ Manual (Any OS with Python)
```bash
python -m http.server 3000 --directory build/web
# Then open: http://localhost:3000
```

---

## ✨ Features (Phases Completed)

| Phase | Feature | Status |
|-------|---------|--------|
| 1 | Offline Hospital Finder (Palghar District) | ✅ Done |
| 2 | Offline First Aid Guide (8 conditions) | ✅ Done |
| 3 | Rule-Based Symptom Triage Engine | ✅ Done |
| 4 | Voice Input + NLP Keyword Extraction | ✅ Done |
| 5 | Emergency Transport & Volunteers | ✅ Done |
| 6 | OCR Prescription Scanner | 🔜 Coming |
| 7 | Offline TTS (Text-to-Speech) | 🔜 Coming |
| 8 | Offline STT (Whisper.cpp) | 🔜 Coming |

---

## 📱 Screens

### 🏠 Home
- SOS emergency button
- Quick access to all health features
- Offline status indicator

### 🩺 Symptom Checker
- Select symptoms from categorised tags
- Instant offline triage (Critical / High / Moderate / Low)
- Voice input — speak your symptoms and they auto-fill
- All processing happens **100% on device**

### 🏥 First Aid Guide
- Step-by-step offline guides for 8 emergencies:
  Snake Bite, Burns, Cuts, Fractures, Heat Stroke, Fainting, Severe Bleeding, Choking
- Searchable, works without internet

### 📍 Hospital Finder
- 20 real hospitals and PHCs in Palghar District
- Filter by Emergency Capable / Type
- One-tap directions and calling

### 🚗 Emergency Transport
- 10 local transport contacts (Ambulances, Autos, Drivers, ASHA Volunteers)
- Filter by type (Ambulance / Auto / Driver / Volunteer)
- 24×7 badge for round-the-clock availability
- One-tap calling

### 🪪 Health Card
- Store personal health info, blood group, allergies, emergency contacts
- Fully offline, stored locally on device

---

## 🛠️ Developer Setup (With Flutter)

If you want to **modify the code** and rebuild:

### Requirements
- [Flutter SDK 3.44+](https://docs.flutter.dev/get-started/install)
- Dart 3.12+

### Install & Run
```bash
# Clone
git clone https://github.com/bajrang07-source/OSD_AarogyaSathi.git
cd OSD_AarogyaSathi

# Install dependencies
flutter pub get

# Run in browser (web)
flutter run -d chrome

# Build optimized web release
flutter build web --release

# Run optimized build
python -m http.server 3000 --directory build/web
```

### Build Android APK
```bash
flutter build apk --release
# APK is at: build/app/outputs/apk/release/app-release.apk
# Install on any Android phone — works fully offline!
```

---

## 🏗️ Architecture

```
lib/
├── core/           # Theme, router, constants
├── data/           # Models, repositories, SQLite seeder
│   ├── local_db/   # DatabaseSeeder (hospitals, first aid, transport)
│   ├── models/     # Hospital, FirstAidTopic, TransportContact, TriageResult
│   └── repositories/
├── features/       # UI feature modules
│   ├── home/
│   ├── symptom_checker/
│   ├── first_aid/
│   ├── hospitals/
│   ├── transport/
│   └── health_card/
└── services/       # AI, DB, Location, OCR, TTS/STT
    ├── ai/         # TriageEngine (rule-based), AiService (NLP)
    ├── db/         # DatabaseService (SQLite/WASM)
    └── tts_stt/    # TtsSttService (speech_to_text)
```

**Tech Stack:** Flutter 3.44 · Dart 3.12 · Riverpod · go_router · sqflite · speech_to_text

---

## 🌍 Language Support
- 🇬🇧 English
- 🇮🇳 Hindi
- 🇮🇳 Marathi

*(Multi-language ARB localisation in Phase 12)*

---

## 📍 Target Region
Designed for **Palghar District, Maharashtra** — seeded with real hospitals, PHCs, and local transport contacts. Adaptable to any district by updating `lib/data/local_db/database_seeder.dart`.

---

## 🤝 Contributing
Pull requests welcome! See open phases above for what's coming next.

---

## 📄 License
MIT License — Free to use, modify, and distribute.
