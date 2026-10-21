# ⏱️ Time (ChronoCraft) — Full-Screen Brutalist Timepiece & Focus Studio

[![Build & Release Time Android APK](https://github.com/apravint/time-android/actions/workflows/build-apk.yml/badge.svg)](https://github.com/apravint/time-android/actions/workflows/build-apk.yml)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-purple.svg)](https://flutter.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.41%2B%20%7C%20Dart-02569B.svg?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Design](https://img.shields.io/badge/Design-FigCraft%20%7C%20Sharp%20Brutalist-cyan.svg)](design/)

**Time (ChronoCraft)** is an open-source, minimalist full-screen time application built with **Flutter**. Engineered for OLED displays, desktop docks, and bedside stands, it features **sharp brutalist geometry** (`rounding = 0`), distraction-free immersion, and multi-palette switching.

---

## 🏛️ 3 Integrated Modes

```
┌────────────────────────────────────────────────────────┐
│                      TIME (FLUTTER)                    │
└───────────────────────────┬────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
   [CLOCK MODE]      [COUNTDOWN MODE]     [TIMER & STOPWATCH]
   • Giant HH:MM     • 4-Box Days/H/M/S   • Focus Pomodoro
   • Seconds badge   • Horizon progress   • Lap Stopwatch
   • Day % elapsed   • Custom targets     • Tactile Controls
```

### 1. Clock Mode (Ambient & Desk Clock)
* **Giant Monospace Digits**: Ultra-large digital clock (`HH:MM`).
* **Seconds & Meridian**: Dedicated badge displaying `:SS` and `AM/PM`.
* **Day Elapsed Progress Bar**: Tracks percentage of the 24-hour day elapsed in real time.
* **12h / 24h Toggle**: Tap the time box to toggle formats instantly.
* **Date & Zone Badges**: Displays full day of the week, date, and local timezone.

### 2. Countdown Mode (Target Horizon)
* **Custom Event Targets**: Tap the title to name your event (e.g., *Product Launch*, *Vacation*, *Exam*).
* **4-Box Split Grid**: High-contrast, sharp brutalist boxes for **DAYS**, **HOURS**, **MINUTES**, and **SECONDS**.
* **Horizon Completion Bar**: Visual indicator displaying percentage of total time elapsed from creation to target date.
* **Quick Presets**: Instant `+7 Days`, `+30 Days`, and date-picker dialogs.

### 3. Focus Timer & Precision Stopwatch
* **Countdown Timer**:
  - Focus presets: **Pomodoro (25m)**, **Short Break (5m)**, **Deep Work (45m)**, and **Power Nap (20m)**.
  - Giant digital countdown with tactile **START / PAUSE / RESET** buttons.
  - System bell chime and haptic feedback on completion.
* **Precision Stopwatch**:
  - Millisecond precision (`MM:SS.ms`).
  - Lap times recording with scrollable delta list.

---

## 📳 Immersion & Orientation

* **Tap-to-Hide Immersion**: Tap anywhere on the background to hide the top bar, theme selector, and navigation bar—leaving only the pure glowing clock numbers against OLED black.
* **Adaptive Landscape Dock**: Rotating your device horizontally automatically transforms the layout into a widescreen bedside / desk stand clock with time on the left and focus telemetry on the right.

---

## 🎨 FigCraft UI/UX Design System

The vector UI wireframes and design token definitions are bundled in [`design/`](design/):

* **[`clock_screen.svg`](design/clock_screen.svg)** — Portrait Clock Screen (`412 × 915`).
* **[`countdown_screen.svg`](design/countdown_screen.svg)** — Portrait Countdown Screen (`412 × 915`).
* **[`timer_screen.svg`](design/timer_screen.svg)** — Portrait Focus Timer Screen (`412 × 915`).
* **[`landscape_clock.svg`](design/landscape_clock.svg)** — Landscape Desk Stand Mode (`915 × 412`).
* **[`design_tokens.json`](design/design_tokens.json)** — Color palette, typography, and `0px` border radius tokens.

---

## 🤖 GitHub Actions Automated APK CI/CD

Every commit or version tag (`v*`) triggers [`.github/workflows/build-apk.yml`](.github/workflows/build-apk.yml):

1. Sets up **Java 17 (Temurin)** and **Flutter SDK (Stable)** with caching.
2. Runs code validation (`flutter analyze` and `flutter test`).
3. Compiles production release APKs:
   - **`Time-Universal.apk`** (Universal APK for all Android devices)
   - **`Time-arm64-v8a.apk`** (Optimized 64-bit ARM)
   - **`Time-armeabi-v7a.apk`** (32-bit ARM legacy support)
4. Uploads APKs to **GitHub Actions Artifacts** (retained for 30 days).
5. Automatically publishes APK binaries as assets on **GitHub Releases** whenever a release tag (e.g. `v3.0.0`) is pushed!

---

## 🚀 Building & Running Locally

### Prerequisites
* Flutter SDK (3.22+)
* Android SDK (API 34+) or an active Android device / emulator

```bash
# 1. Clone repository
git clone https://github.com/apravint/time-android.git
cd time-android

# 2. Fetch Flutter packages
flutter pub get

# 3. Run on connected device or emulator
flutter run

# 4. Build release APK
flutter build apk --release
```

---

## 📜 License
MIT License. Created by [Pravin](https://github.com/apravint).
