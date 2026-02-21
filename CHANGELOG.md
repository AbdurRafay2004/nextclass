# Changelog

## Current Status
✅ Phase 11 Complete: Comprehensive codebase analysis & high-priority fixes

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
- **2026-02-21**: Redesigned the primary application navigation by replacing the standard `BottomNavigationBar` with a custom floating "Dynamic Island" style `DynamicNavBar`. Further refined the styling to match a sleek minimal aesthetic: removed the active pill background, updated inactive items to `#64748B` (blue-grey), active items to pure white, and utilized thicker outlined icons (`radio_button_unchecked`, `view_day`, `person`). Added 100px bottom offset padding to all scroll views to ensure the floating island does not clip content.
- **2026-02-21**: Refactored the core providers for better architectural separation of concerns. `schedule_provider` was renamed to `session_provider` to accurately reflect its domain logic, and the real-time clock `timeProvider` was extracted into an independent `time_provider.dart` under `core/providers`.
- **2026-02-21**: Adjusted the default sorting for "Class Sessions" to start with Saturday instead of Monday. Implemented custom mapping logic `(day + 1) % 7` in `sessionsByCourseProvider` to ensure the week begins on Saturday (6) followed by Sunday (7) and the rest of the weekdays.
- **2026-02-21**: Implemented an isolated, auto-updating real-time clock using Riverpod `StreamProvider` to accurately manage the Dashboard's "App Bar Time" and the "Live Status Card" progress bars. Refined the provider to synchronize its updates perfectly with the system clock minute rollover, ensuring the UI flips exactly at the start of each new minute.
- **2026-02-21**: Updated the `DashboardPage` primary header from "Today" to dynamically format the current date and time (e.g., "WEDNESDAY, OCT 24 • 10:25 AM") aligned to the typography style.
- **2026-02-21**: Scaled down the sizing and padding of fonts and icons in the `BottomNavigationBar` and `LiveStatusCard` (Happening Now) to take up significantly less vertical space (~25% of the screen), enhancing the minimalistic layout.
- **2026-02-21**: Redesigned the primary navigation mechanism (`BottomNavigationBar`) to match the minimalist pure black dark theme, exchanging the label 'Home' for 'FOCUS', removing the default Material 3 pill selection, and using heavily spaced typography with outlined minimalist icons (`circle_outlined`, `calendar_today_outlined`, `person_outline`).
- **2026-02-21**: Fixed an issue in `DashboardPage` where past classes were still appearing in the "UP NEXT TODAY" list. Ended classes are now correctly filtered out.
- **2026-02-21**: Redesigned `LiveStatusCard` (Happening Now) to match the dark, typography-focused UI aesthetics with custom "NOW" badge, large headings, and refined layout. Removed redundant header from Dashboard.
- **2026-02-21**: Redesigned `TimelineEventCard` to perfectly match the provided "Up Next Today" UI design, including color styling, border radii, and accurate layout of time, room, and course details. Updated Dashboard heading.
- **2026-02-21**: Conducted a global refactor to rename "Faculty Name" to "Faculty Acronym" across the entire codebase (Model, Provider, UI), including a final polish to UI labels ("FACULTY ACRONYM") for complete domain alignment.
- **2026-02-21**: Improved Dark Theme Contrast. Updated `DynamicNavBar`, `LiveStatusCard`, and `TimelineEventCard` to use a lighter `#222224` background color over the pure black scaffold for distinct visual hierarchy in dark mode. Refined the color indicators on status cards to be inset and fully rounded according to design specifications.
- **2026-02-21**: Fixed a bug where the `DashboardPage` required a manual refresh for upcoming classes to transition to live status. Moved the `timeProvider` subscription to an isolated `Consumer` wrapping only the schedule list body, ensuring the layout automatically recalculates live/upcoming states every minute without forcing the entire `DashboardPage` scaffolding to rebuild.
- **2026-02-21**: Dramatically simplified `time_provider.dart` to fix clock drifting. Replaced the custom manual delay logic with a standard `Stream.periodic` that polls the exact system clock (`DateTime.now()`) every 1 second. This guarantees the app clock will never fall out of sync with the phone's system time, while relying on Flutter's efficient state management to only rebuild UI when necessary. Also bound `timeProvider` invalidation to the Dashboard's pull-to-refresh.
- **2026-02-21**: Extracted the complex "Live class vs Upcoming class" time-filtering logic out of the `DashboardPage` UI code and into a dedicated `dashboardScheduleProvider`. This cleans up the UI layer to be a pure renderer, and strictly enforces the separation of concerns by placing all business logic in the Provider layer.
- **2026-02-21**: Fixed `withOpacity` deprecation warnings in `LiveStatusCard` by migrating to the new `withValues(alpha: ...)` API.
- **2026-02-21**: Performed comprehensive codebase analysis across all 21 Dart files. Identified 12 issues across inefficiency, over-engineering, file structure, and design/color consistency.
- **2026-02-21**: Extracted duplicated `_hexToColor` and `_formatTime` utilities from 5 files into shared `core/utils/color_utils.dart` and `core/utils/time_utils.dart`.
- **2026-02-21**: Fixed critical color bug in `LiveStatusCard` — was using a letter-based switch (first letter of course code → hardcoded Material color) instead of the user-chosen `course.colorHex`. Now consistent with `TimelineEventCard` and `CourseListPage`.
- **2026-02-21**: Reduced `timeProvider` polling frequency from 1 second to 30 seconds. The UI only shows minute-level granularity, so 59 of 60 emissions per minute were wasted.
- **2026-02-21**: Made `currentDayProvider` reactive by deriving from `timeProvider`. Previously was a static `DateTime.now().weekday` that never updated past midnight.
- **2026-02-21**: Created `BestPractices.md` documenting project-level architecture, Riverpod, performance, theming, and code organization conventions.

## Immediate Next Steps
1. Centralize remaining hardcoded colors (`0xFF222224`, `Colors.grey[500]`, etc.) into `AppColors` and wire through `Theme.of(context)`.
2. Create `SessionController` mirroring `CourseController` pattern.
3. Persist settings via `SharedPreferences`.
4. Test local notifications scheduling.
5. Implement Class Session Conflict detection.

## Known Issues/Notes
- Notification functionality is currently untied. Session creation lacks conflict validation.
- Renaming the database field triggered a code regeneration requirement (`build_runner`).
