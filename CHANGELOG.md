# Changelog

## Current Status
✅ Phase 10 Complete: Global refactor of "Faculty Name" to "Faculty Acronym"

## ChangeLog
- **2026-02-21**: Analyzed NextClass design workflows. Selected Flutter, Riverpod, and Isar tech stack. Bootstrapped clean architecture plan.
- **2026-02-21**: Added pubspec dependencies (Riverpod, Isar). Created Google Fonts theme, brand color palettes. Generated initial `Course` and `ClassSession` Isar models.
- **2026-02-21**: Setup offline Isar Database initialization and provided it globally via Riverpod `databaseProvider`.
- **2026-02-21**: Built Dashboard page with `TimelineEventCard` and `LiveStatusCard` integration for schedule rendering.
- **2026-02-21**: Developed Course Management UI (List, Add, Detail screens) and wired Isar CRUD logic.
- **2026-02-21**: Developed Class Session Setup UI (Day selector, time picker, duration) and connected it to Course pages.
- **2026-02-21**: Added App Settings provider to reactively manage `ThemeMode` globally. Fixed dart compilation issues with relative imports. 
- **2026-02-21**: Fixed Android build compatibility issues (`isar_flutter_libs` namespace and `compileSdkVersion`, `coreLibraryDesugaring` for notifications).
- **2026-02-21**: Removed the "Calendar" placeholder section from the Dashboard to streamline the navigation.
- **2026-02-21**: Fixed the "Add a class" button on the Dashboard (Focus) screen to correctly navigate to the "Add Course" screen.
- **2026-02-21**: Implemented an isolated, auto-updating real-time clock using Riverpod `StreamProvider` to accurately manage the Dashboard's "App Bar Time" and the "Live Status Card" progress bars. Refined the provider to synchronize its updates perfectly with the system clock minute rollover, ensuring the UI flips exactly at the start of each new minute.
- **2026-02-21**: Updated the `DashboardPage` primary header from "Today" to dynamically format the current date and time (e.g., "WEDNESDAY, OCT 24 • 10:25 AM") aligned to the typography style.
- **2026-02-21**: Scaled down the sizing and padding of fonts and icons in the `BottomNavigationBar` and `LiveStatusCard` (Happening Now) to take up significantly less vertical space (~25% of the screen), enhancing the minimalistic layout.
- **2026-02-21**: Redesigned the primary navigation mechanism (`BottomNavigationBar`) to match the minimalist pure black dark theme, exchanging the label 'Home' for 'FOCUS', removing the default Material 3 pill selection, and using heavily spaced typography with outlined minimalist icons (`circle_outlined`, `calendar_today_outlined`, `person_outline`).
- **2026-02-21**: Fixed an issue in `DashboardPage` where past classes were still appearing in the "UP NEXT TODAY" list. Ended classes are now correctly filtered out.
- **2026-02-21**: Redesigned `LiveStatusCard` (Happening Now) to match the dark, typography-focused UI aesthetics with custom "NOW" badge, large headings, and refined layout. Removed redundant header from Dashboard.
- **2026-02-21**: Redesigned `TimelineEventCard` to perfectly match the provided "Up Next Today" UI design, including color styling, border radii, and accurate layout of time, room, and course details. Updated Dashboard heading.
- **2026-02-21**: Conducted a global refactor to rename "Faculty Name" to "Faculty Acronym" across the entire codebase (Model, Provider, UI), including a final polish to UI labels ("FACULTY ACRONYM") for complete domain alignment.

## Immediate Next Steps
1. Test local notifications scheduling.
2. Implement Class Session Conflict detection.
3. Refine animations and padding tweaks.

## Known Issues/Notes
- `withOpacity` deprecated warnings from Flutter SDK are visible during `dart analyze`, recommending migration to `withAlpha`.
- Notification functionality is currently untied. Session creation lacks conflict validation.
- Renaming the database field triggered a code regeneration requirement (`build_runner`).
