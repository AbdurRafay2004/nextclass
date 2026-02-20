# NextClass

A Flutter-based class schedule application prioritizing offline-first capabilities, a timeline UI, and high-performance list rendering. 

## Current Status
✅ Phase 6 (Partial) Complete: NextClass Core UI MVP Built (Dashboard, Course Management, Session Setup, and Settings)

## ChangeLog
- **2026-02-21**: Analyzed NextClass design workflows. Selected Flutter, Riverpod, and Isar tech stack. Bootstrapped clean architecture plan.
- **2026-02-21**: Added pubspec dependencies (Riverpod, Isar). Created Google Fonts theme, brand color palettes. Generated initial `Course` and `ClassSession` Isar models.
- **2026-02-21**: Setup offline Isar Database initialization and provided it globally via Riverpod `databaseProvider`.
- **2026-02-21**: Built Dashboard page with `TimelineEventCard` and `LiveStatusCard` integration for schedule rendering.
- **2026-02-21**: Developed Course Management UI (List, Add, Detail screens) and wired Isar CRUD logic.
- **2026-02-21**: Developed Class Session Setup UI (Day selector, time picker, duration) and connected it to Course pages.
- **2026-02-21**: Added App Settings provider to reactively manage `ThemeMode` globally. Fixed dart compilation issues with relative imports. 
- **2026-02-21**: Fixed Android build compatibility issues (`isar_flutter_libs` namespace and `compileSdkVersion`, `coreLibraryDesugaring` for notifications).

## Immediate Next Steps
1. Test MVP natively on desired target (Windows/Android/iOS) to verify UI aesthetics.
2. Implement Local Notifications scheduling (reminders logic).
3. Implement Class Session Conflict detection & Duplication workflows.
4. Refine layout nuances (animations, padding tweaks based on visual feedback).

## Known Issues/Notes
- `withOpacity` deprecated warnings from Flutter SDK are visible during `dart analyze`, recommending migration to `withAlpha`.
- Notification functionality is currently untied. Session creation lacks conflict validation.
