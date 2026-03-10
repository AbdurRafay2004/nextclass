# Changelog

## Current Status
✅ Phase 23 Complete: Hardened database layer against MdbxError (11) on low-end devices

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
- **2026-02-22**: Consolidated `color_utils.dart` into `AppColors` as static methods (`hexToColor`, `colorToHex`). Added semantic color constants `cardDark`, `liveGreen`, `navInactive`. Deleted standalone `color_utils.dart`. Updated all 8 affected files to use `AppColors.*`.
- **2026-02-22**: Created `SessionController` (mirroring `CourseController`) with `addSession` and `deleteSession` methods. Refactored `SessionAddPage` to use the controller instead of direct Isar database access, enforcing clean architecture separation.
- **2026-02-22**: Added `SharedPreferences` persistence to `SettingsNotifier`. Theme mode and notification preferences now survive app restarts. Settings load asynchronously on startup and persist on every change.
- **2026-02-23**: Fixed 30-second startup loading hang on FOCUS page. Root cause: `Stream.periodic` does not emit on subscribe — it waits one full interval (30s). Fixed by adding an immediate `yield DateTime.now()` before entering the periodic loop. Dashboard now loads in milliseconds.
- **2026-02-23**: Removed `ref.invalidate(timeProvider)` from pull-to-refresh handler. Invalidating a `StreamProvider` restarts the stream from zero, causing the same 30s loading freeze on every refresh.
- **2026-02-23**: Added `WidgetsBindingObserver` to `DashboardPage` with `didChangeAppLifecycleState`. When the app resumes from background, `dayScheduleProvider` is invalidated to immediately recompute the schedule.
- **2026-02-23**: Tightened `analysis_options.yaml` with 20+ strict lint rules. `unused_import` and `duplicate_import` are now treated as errors. Added rules for type safety, code quality, and style consistency.
- **2026-02-23**: Created barrel export files: `core/core.dart`, `core/theme/theme.dart`, `core/utils/utils.dart` for discoverability of shared utilities.
- **2026-02-23**: Performed project cleanup by identifying and planning the removal of unused target platforms (`ios`, `macos`, `linux`, `windows`, `web`). NextClass is now explicitly configured as an Android-only application to reduce noise and maintain a lean project structure.
- **2026-02-23**: Added Session Management feature: implemented Edit, Duplicate, and Remove actions for class sessions, accessible via a bottom sheet in `CourseDetailPage`.
- **2026-02-23**: Added Course Management feature: implemented Edit and Remove actions for courses directly from the `CourseDetailPage` AppBar.
- **2026-02-23**: Redesigned the Course Cards on the Courses page to align with the Focus page design system (dark UI, `AppColors.cardDark`, fully rounded 24px container, inset 14px color pill).
- **2026-02-23**: Complete UI consistency overhaul across all 10 page/widget files. Created `AppTextStyles` for shared typography, extended `AppColors` with context-aware helpers (`cardSurface`, `mutedText`, `primaryText`, `dividerColor`) and standardized border radius constants (20px cards, 16px forms). Extended `AppTheme` with unified `AppBarTheme`, `CardThemeData`, `InputDecorationTheme`, `DialogThemeData`, and `DividerThemeData`. Refactored every page to use theme-derived colors instead of hardcoded `Colors.white`/`Colors.grey[*]`/`Colors.black`. Standardized card styling, section headers, empty states, and form inputs across Focus, Courses, Course Detail, Add/Edit Course, Add/Edit Session, and Settings pages. All pages now support both light and dark modes consistently.
- **2026-02-23**: Removed light theme entirely — app is now permanently dark mode. Removed notification feature (toggle and persistence). Stripped `SettingsState` of themeMode/notifications, simplified `main.dart` to a dark-only `StatelessWidget`, removed `lightTheme` from `AppTheme`. Settings page now only shows Time Format, About, and version 2.0.0.
- **2026-02-23**: Font consistency fix across all 9 UI files. Replaced every direct `TextStyle()` with `GoogleFonts.inter()` to ensure Inter font is used in all labels, buttons, and standalone text that doesn't go through `theme.textTheme`. Updated `AppTextStyles` to also use `GoogleFonts.inter()` directly.
- **2026-02-23**: Centralized font configuration into `AppFonts` class (`core/theme/app_fonts.dart`). All `GoogleFonts.inter()` calls across 9 files replaced with `AppFonts.style()`. To change the app font, update the two methods in `AppFonts` — one place, whole-app change.
- **2026-02-23**: Removed the person icon from the Dashboard (FOCUS) page `AppBar` actions to simplify the UI.
- **2026-02-23**: Switched app font from Inter to **Bricolage Grotesque** (variable axes: weight 200–800, width 75–100). Updated `AppFonts` (2-file change thanks to centralization). Tuned `AppTextStyles` weights for Bricolage's axis range.
- **2026-02-23**: Fully centralized all text styles into `AppTextStyles` (16 named styles). Removed every inline `AppFonts.style()` call from all 8 page/widget files. All typography is now editable from one file (`app_text_styles.dart`).
- **2026-02-23**: Harmonized all page headers. Added `AppTextStyles.pageHeader` and updated `AppTheme` to apply it globally. Updated Focus, Courses, and Settings pages to ensure consistent typography and capitalization.
- **2026-02-23**: Added persistent dynamic font selection feature matching user preference. Users can now choose from a curated list of high-quality UI fonts in the Settings page, and the selection is saved across sessions using `shared_preferences`.
- **2026-02-23**: Updated bottom navigation inactive icon color to `#9BA1A6` for better visibility and consistency.
- **2026-02-23**: Removed unused/stub "Time Format" preference from Settings page UI to clean up redundant features.
- **2026-02-23**: Configured and generated a custom Android app launcher icon from `assets/icon.png` using the `flutter_launcher_icons` package.
- **2026-02-23**: Focus page now shows upcoming class days beyond today. The dashboard fetches the next 6 days of sessions and displays them grouped under day-name headers (e.g., "TOMORROW", "WEDNESDAY"). Empty state updated to "No classes scheduled this week." Added prominent "No classes today" message when today is empty but future classes exist. Added centralized `emptyStateMessage` text style for consistent empty state typography.
- **2026-02-23**: Appended dates to the Focus page upcoming day labels (e.g., "TOMORROW, OCT 25", "WEDNESDAY, OCT 26") to exactly match the header formatting style.
- **2026-02-24**: Fixed bug where custom fonts failed to load and apply on physical Android devices running the Release APK. Added `android.permission.INTERNET` to the main Android manifest to allow the `google_fonts` package to dynamically fetch missing font data at runtime.
- **2026-02-24**: Documented App Size Reduction build flags (`--split-per-abi`, `--obfuscate`) in `BestPractices.md` to resolve the 80MB+ fat APK issue caused by native binaries like `isar_flutter_libs`.
- **2026-02-24**: Removed the shadow effect from the floating bottom navigation bar (`DynamicNavBar`) for a cleaner, flatter aesthetic.
- **2026-02-24**: Added a subtle bottom shadow to the floating navigation bar (`DynamicNavBar`) for a premium layout feel.
- **2026-02-24**: Fixed a hard-edge clipping rendering bug on the `DynamicNavBar` shadow (caused by `spreadRadius` on Android/Impeller) by migrating to a smooth double-layered shadow effect.
- **2026-02-24**: Fixed `ListTile` InkWell ripple effect clipping over rounded container corners in `SettingsPage` by wrapping tiles in `Material` widgets and enabling `Clip.hardEdge`.
- **2026-02-24**: Added the course code identifier (e.g. "CS 101") to the top information card on the Course Details page, styled with the assigned theme color.
- **2026-02-24**: Implemented a comprehensive `ScheduleItemDetailDialog` (bottom sheet) that displays when tapping any timeline or live status card on the Focus page, showing full class, time, and room details in a styled format.
- **2026-02-24**: Added "1 hr 20 min" and "1 hr 45 min" to the session duration options, making "1 hr 20 min" the default.
- **2026-02-24**: Replaced vibrant course color palette with a softer, varied pastel selection (Blush Pink, Peach Cream, Butter Yellow, Mint Green, Sky Blue, Lavender Mist, Coral Rose, Pistachio, Powder Blue, Lilac, Apricot Glow, Soft Teal).
- **2026-02-24**: Added optional faculty fields (Full Name, Email, Phone, Department) to Course settings and elegantly integrated them into the Schedule Item Detail Dialog.
- **2026-02-24**: Implemented QR-Based Instant Schedule Sharing feature with full architecture:
  - **Domain Layer**: Created `ScheduleShareDTO` with short-key JSON format (`v`, `cs`, `n`, `c`, `ch`, `fa`, `ss`, `d`, `st`, `du`, `r`, `t`) and version field for forward compatibility.
  - **Data Layer**: Built `ShareEncoderService` (JSON → GZIP → Base64 pipeline) with full/selective export modes, `ShareDecoderService` (Base64 → GZIP → JSON), and `ShareImportService` with Replace/Merge conflict handling scoped only to imported courses.
  - **Presentation Layer - Export**: Created `ExportModeScreen` (Full vs Selective), `CourseSelectionScreen` (checkboxes, Select All toggle, live QR size indicator: Small/Medium/Large), and `ShareQrScreen` (QR display with size info).
  - **Presentation Layer - Import**: Created `ScanQrScreen` (camera-based QR scanning via `mobile_scanner`), `SharePreviewScreen` (import preview with course list, Replace/Merge action bar, confirmation dialogs, and import result summary).
  - **State Management**: Created `sharing_provider.dart` with `ShareEncoderService`, `ShareDecoderService`, `ShareImportService` providers, `CourseSelectionNotifier` for selection state, and `estimatedSizeProvider` for live byte-size estimation.
  - **Integration**: Added `qr_flutter` and `mobile_scanner` dependencies. Added "Share Schedule" entry point in Settings page under new "SHARING" section.
  - **Safety**: QR size threshold guard at 2500 bytes with user-friendly dialog when exceeded. GZIP compression reduces payload by ~40-60%.
- **2026-02-26**: Fixed Skeptic report issues: Added CAMERA permission for QR scanner, synchronized app versioning to 2.0.0, optimized N+1 queries in session_provider, added input validation to controllers, and fixed early return bug on Dashboard.
- **2026-02-28**: Fixed Isar `MdbxError (11) "Try again"` database lock issue by implementing a centralized `_withRetry` mechanism in `CourseController` and `SessionController` to gracefully handle transient storage contention.
- **2026-02-28**: Improved user flow by automatically redirecting to the "Add Session" page immediately after successfully creating a new course.
- **2026-02-28**: Updated app version to 5.4.2 across the configuration and Settings page UI.
- **2026-03-03**: Created `DatabaseWriteSerializer` (`core/database/database_write_serializer.dart`) with a zero-dependency async Mutex (future-chaining queue pattern) and exponential-backoff retry (5 attempts, 100ms base) targeting `MdbxError (11): Try again`. All Isar write paths now use `safeWrite()` for serialization + retry.
- **2026-03-03**: Refactored `CourseController` and `SessionController` to remove duplicated `_withRetry` methods (20 lines each) in favor of the shared `DatabaseWriteSerializer.safeWrite()`.
- **2026-03-03**: Added retry protection to `ShareImportService` — previously ran bare `writeTxn()` with no retry or serialization, making it the most vulnerable code path on low-end devices.
- **2026-03-03**: Reduced `deleteCourse` transaction scope — reads (course lookup + session ID fetch) now happen outside `writeTxn`, minimizing MDBX lock hold time.
- **2026-03-03**: Tuned `Isar.open` config: `maxSizeMiB: 64` (was default 1024) to reduce mmap pressure on 32-bit devices, `compactOnLaunch` to reclaim wasted space.
- **2026-03-03**: Fixed fragile error detection — replaced `e.toString().contains('11')` with targeted `msg.contains('MdbxError') && msg.contains('Try again')` check.
- **2026-03-03**: Reverted `compactOnLaunch` and `maxSizeMiB` Isar config — these extended startup time on slow eMMC (Vivo Y15S), widening the window for stale MDBX lock files on force-kill, causing permanent black screens.
- **2026-03-03**: Increased retry budget to 8 attempts with 150ms exponential backoff (~19s total window) to accommodate extremely slow eMMC I/O on low-end 32-bit devices.
- **2026-03-03**: Created `DatabaseErrorWidget` (`core/widgets/database_error_widget.dart`) — reusable error recovery widget with a "Retry" button that detects MdbxError and shows a user-friendly "Temporary Issue" message.
- **2026-03-03**: Wired `DatabaseErrorWidget` into all 4 pages that display database-fetched data: `DashboardPage`, `CourseListPage`, `CourseDetailPage`, `CourseSelectionScreen`. Users can now tap "Retry" to recover from transient database errors instead of seeing raw error text.

## Immediate Next Steps
1. Visual QA: test QR sharing flow end-to-end on physical device.
2. Implement Class Session Conflict detection.
3. Add camera permission handling for QR scanner.
4. Refine animations and micro-interactions.
5. Run `dart run build_runner build --delete-conflicting-outputs` to regenerate Isar database files.

## Known Issues/Notes
- Notification functionality is currently untied. Session creation lacks conflict validation.
- Renaming the database field triggered a code regeneration requirement (`build_runner`).
- QR scanner requires camera permission — `mobile_scanner` handles the permission request automatically on Android, but a graceful fallback UI may be needed.
- Very large schedules (>2500 bytes after compression) will show a size limit dialog and suggest selective export.
