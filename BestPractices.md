# Best Practices — NextClass

> **AI Pre-Flight:** Read this file AND `CHANGELOG.md` and `README.md` before making ANY code changes.

## Existing Shared Utilities (DO NOT DUPLICATE)

Read `lib/core/core.dart` barrel export to see everything available:

| Utility | Location | Usage |
|---------|----------|-------|
| `AppColors.hexToColor()` | `core/theme/app_colors.dart` | Convert hex string → Color |
| `AppColors.colorToHex()` | `core/theme/app_colors.dart` | Convert Color → hex string |
| `AppColors.cardDark` | `core/theme/app_colors.dart` | Card/nav bar background (dark) |
| `AppColors.liveGreen` | `core/theme/app_colors.dart` | "NOW" badge / live indicator |
| `AppColors.navInactive` | `core/theme/app_colors.dart` | Inactive nav icon/label color |
| `AppColors.cardSurface(ctx)` | `core/theme/app_colors.dart` | Theme-aware card background |
| `AppColors.mutedText(ctx)` | `core/theme/app_colors.dart` | Theme-aware muted text color |
| `AppColors.primaryText(ctx)` | `core/theme/app_colors.dart` | Theme-aware primary text color |
| `AppColors.dividerColor(ctx)` | `core/theme/app_colors.dart` | Theme-aware divider color |
| `AppColors.cardRadius` | `core/theme/app_colors.dart` | 20px — standard card border radius |
| `AppColors.formRadius` | `core/theme/app_colors.dart` | 16px — standard form border radius |
| `AppTextStyles.sectionHeader(ctx)` | `core/theme/app_text_styles.dart` | Uppercase section labels |
| `AppTextStyles.labelUppercase(ctx)` | `core/theme/app_text_styles.dart` | Small uppercase tracking labels |
| `AppTextStyles.cardTitle(ctx)` | `core/theme/app_text_styles.dart` | Bold card title |
| `AppTextStyles.cardSubtitle(ctx)` | `core/theme/app_text_styles.dart` | Muted card subtitle |
| `AppFonts.style(...)` | `core/theme/app_fonts.dart` | Centralized font — replaces `GoogleFonts.inter()` |
| `AppFonts.textTheme(...)` | `core/theme/app_fonts.dart` | Centralized font text theme — used in AppTheme |
| `formatTime()` | `core/utils/time_utils.dart` | Minutes → "10:30 AM" |
| `formatTimeOnly()` | `core/utils/time_utils.dart` | Minutes → "10:30" |
| `formatAmPm()` | `core/utils/time_utils.dart` | Minutes → "AM"/"PM" |
| `timeProvider` | `core/providers/time_provider.dart` | Global clock stream (30s interval, emits immediately) |
| `CourseController` | `course/presentation/providers/course_provider.dart` | Course CRUD |
| `SessionController` | `schedule/presentation/providers/session_provider.dart` | Session CRUD |

## Architecture
- Feature-based clean architecture: `data/models → presentation/providers → presentation/pages|widgets`
- Keep all business logic in providers; UI layer should be pure rendering
- Every model that mutates data MUST have a dedicated Controller class — **NEVER write directly to Isar from UI code**
- Domain models (like `ScheduleItem`) belong in `data/models/`, not inside provider files

## Riverpod
- Use `StreamProvider` (not manual `FutureProvider` + polling) for reactive Isar queries
- Derive computed state from multiple providers inside a dedicated `Provider` (e.g., `dashboardScheduleProvider`)
- Wrap only time-dependent widgets in `Consumer` to avoid full-page rebuilds
- Use `ref.watch()` for reads that should trigger rebuilds; `ref.read()` only inside callbacks
- **Never `ref.invalidate(timeProvider)`** — invalidating a StreamProvider restarts the stream, causing loading delays

## Performance
- Avoid `IntrinsicHeight` in scrollable lists — use constrained layouts instead
- Timer/stream intervals should match UI granularity (30s for minute-level display)
- Batch database queries instead of N+1 patterns (fetch all, then join in-memory)
- `timeProvider` stream must `yield` immediately before entering periodic loop

## Theming & Colors
- **Never hardcode colors** (`Colors.white`, `Color(0xFF222224)`) — use `AppColors.*` constants or context-aware helpers
- All course-specific colors come from `course.colorHex` via `AppColors.hexToColor()` — never derive from course code letters
- Use `AppColors.cardSurface(context)` for card/container backgrounds
- Use `AppColors.mutedText(context)` for secondary/muted text
- Use `AppColors.dividerColor(context)` for dividers and separators
- Use `theme.colorScheme.onSurface` for primary text instead of `Colors.white`
- Use `theme.colorScheme.error` for destructive actions instead of `Colors.red`
- New color constants go in `AppColors` with semantic names
- Border radii: `AppColors.cardRadius` (20px) for cards, `AppColors.formRadius` (16px) for form inputs

## Typography
- **Never use inline `TextStyle()` or `AppFonts.style()`** in page files — use `AppTextStyles.*` named styles
- All 16 text styles live in `AppTextStyles` (`core/theme/app_text_styles.dart`) — edit there to change everywhere
- Font family is set in `AppFonts` (`core/theme/app_fonts.dart`) — change **one file** to switch the whole app's font
- Current font: **Bricolage Grotesque** (weight 200–800)
- If adding a new text role, add a named style to `AppTextStyles` — never create ad-hoc styles in pages

## Code Organization
- Color utilities and constants are in `AppColors` (`core/theme/app_colors.dart`) — NOT a separate utils file
- Time utilities are in `core/utils/time_utils.dart`
- Generated files (`.g.dart`) stay co-located with their source model
- Imports must be alphabetically sorted (`directives_ordering` lint)

## Code Quality
- `analysis_options.yaml` has strict rules — always run `flutter analyze` after changes
- `unused_import` and `duplicate_import` are **errors** (block builds)
- Use single quotes for strings
- Use `const` constructors wherever possible

## Data Persistence
- Settings persisted via `SharedPreferences` — never rely on in-memory-only state
- Isar models use UUID for cross-collection references

## Forms & Validation
- Always dispose `TextEditingController` instances in `dispose()`
- Use `TextInputFormatter` for formatting constraints (e.g., uppercase)
- Confirm destructive actions with dialogs before executing

## Project Structure
- For Android-only builds, keep only the `android` platform folder. Unused platform folders (`ios`, `web`, etc.) should be removed to keep the project lean.
- Use `flutter create --platforms android .` if you ever need to reset or restrict platform support.

## After Making Changes
- Run `flutter analyze --no-pub` — must show zero issues
- Update `CHANGELOG.md` with what changed, why, and next steps
- Update this file if new conventions were established
