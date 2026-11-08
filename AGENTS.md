# AGENTS.md - Developer & AI Agent Operations Manual for `time-android` 🤖

This document is the definitive operational guide for autonomous AI coding agents (Antigravity, Claude, Cursor, OpenAI Codex, OpenHands) operating within this repository.

---

## 🎯 1. System Overview & Core Philosophy

**⏱️ Time (ChronoCraft) — Full-Screen Brutalist Timepiece & Focus Studio**
> Time (ChronoCraft) is an open-source, minimalist full-screen time application built with Flutter. Engineered for OLED displays, desktop docks, and bedside stands, it features sharp brutalist geometry (rounding = 0), distraction-free immersion, and multi-palette switching. ┌────────────────────────────────────────────────────────┐ │                      TIME (FLUTTER)                    │

---

## 🏗️ 2. Repository Structure & Directory Map

| Path | Role & Architectural Responsibility |
| :--- | :--- |
| `.github/` | Subsystem directory (.github) |
| `android/` | Native Android Gradle project & wrapper |
| `design/` | Subsystem directory (design) |
| `docs/` | Extended documentation, architectural diagrams, guides |
| `lib/` | Flutter / Dart application components & state |
| `play-store/` | Subsystem directory (play-store) |
| `pubspec.yaml` | Flutter / Dart dependency manifest and asset declarations |
| `scripts/` | Subsystem directory (scripts) |
| `test/` | Subsystem directory (test) |
| `web/` | Frontend web application interface and assets |

---

## ⚙️ 3. Executable Verification Pipeline

Before marking any task complete, an AI agent **must** run the following verification steps sequentially:

### Tier 1: Sound Null-Safety & Static Analysis
```bash
flutter analyze || dart analyze
```

### Tier 2: Automated Unit & Widget Test Suite
```bash
flutter test
```

### Tier 3: Debug Compilation Check
```bash
flutter build apk --debug --no-pub
```

---

## 🛡️ 4. Architectural Invariants & Non-Negotiable Rules

### Strict Invariants ("Never Do" List):
1. **Strict Shell Safety:** Every shell script must declare `set -euo pipefail`. Never use `|| true` on critical installation or backup steps.
2. **Preserve Subshell Exit Codes:** Separate `local` variable declarations from command substitutions (ShellCheck SC2155).
3. **Safe Path Expansion:** Always quote variable expansions (e.g. `"$TARGET_DIR"`) to guard against whitespace and path traversal.

### Security & Environment Variables:
- All API keys and secrets must be loaded strictly from environment variables.
- Never commit `.env`, `.pem`, token files, or private credentials.

---

## 🤖 5. Autonomous Agent Operational Protocol

When dispatched to resolve an issue, implement a feature, or refactor code in this repo:

1. **Phase 1 — Explore & Plan:**
   - Read this `AGENTS.md` and relevant source files.
   - Check existing tests to establish the baseline.
2. **Phase 2 — Act (Surgical Implementation):**
   - Implement changes with minimal blast radius.
   - Adhere to the established code style and existing conventions.
3. **Phase 3 — Verify:**
   - Run the Tier 1, 2, and 3 verification commands listed above.
   - Ensure all existing and new tests pass cleanly.
4. **Phase 4 — Reflect:**
   - Review `git diff` to confirm zero unintended whitespace or collateral changes.
   - Confirm no untracked scratch files remain.

---
*Maintained by Ayyappa Pravin • Engineered for Antigravity, Claude, Cursor & Modern Autonomous AI Agents.*
