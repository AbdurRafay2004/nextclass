---
description: Pre-flight checklist for any NextClass codebase work. Read this BEFORE making any code changes.
---

# NextClass Pre-Flight Checklist

// turbo-all

Before making ANY code changes to the NextClass Flutter codebase, complete this checklist:

## 1. Read Key Project Files
Read these files to understand the current state and conventions:
- `CHANGELOG.md` — current status, recent changes, and immediate next steps
- `BestPractices.md` — architecture, Riverpod, theming, and code organization rules
- `README.md` — project structure and tech stack overview

## 2. Understand the Architecture
- **State management:** Riverpod (StreamProvider for reactive Isar queries, Notifier for mutations)
- **Database:** Isar (offline-first)
- **Architecture:** Feature-based Clean Architecture (`core/` + `features/`)
- **Mutations:** Always use Controller classes (CourseController, SessionController) — NEVER write directly to Isar from UI

## 3. Check Existing Utilities Before Creating New Ones
Read the barrel export `lib/core/core.dart` to see ALL shared utilities available:
- `AppColors` — ALL color constants AND `hexToColor()`/`colorToHex()` utility methods
- `time_utils.dart` — `formatTime()`, `formatTimeOnly()`, `formatAmPm()`
- `time_provider.dart` — global time stream (emits immediately, then every 30s)
- `database_manager.dart` — Isar instance provider
- `dynamic_nav_bar.dart` — custom navigation bar widget

**CRITICAL: Do NOT create duplicate utility functions.** Search the codebase first.

## 4. Follow Color Conventions
- **Never hardcode colors** — use `AppColors.*` semantic constants
- Course-specific colors come from `course.colorHex` via `AppColors.hexToColor()`
- Card backgrounds: `AppColors.cardDark`
- Live indicator: `AppColors.liveGreen`
- Nav inactive: `AppColors.navInactive`
- All other UI colors should use `Theme.of(context).colorScheme.*`

## 5. Follow Code Quality Rules
- `analysis_options.yaml` has strict rules — always run `flutter analyze` after changes
- `unused_import` and `duplicate_import` are treated as **errors**
- Import ordering must be alphabetical (enforced by `directives_ordering`)
- Use single quotes for strings
- Use `const` constructors wherever possible

## 6. After Making Changes
- Run `flutter analyze --no-pub` to verify zero issues
- Update `CHANGELOG.md` with what changed and why
- Update `BestPractices.md` if new conventions were established
