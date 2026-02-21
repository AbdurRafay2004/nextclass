# Best Practices — NextClass

## Architecture
- Follow feature-based clean architecture: `data/models → presentation/providers → presentation/pages|widgets`
- Keep all business logic in providers; UI layer should be pure rendering
- Every model that mutates data should have a dedicated Controller class (e.g., `CourseController`, `SessionController`)
- Domain models (like `ScheduleItem`) belong in `data/models/`, not inside provider files

## Riverpod
- Use `StreamProvider` (not manual `FutureProvider` + polling) for reactive Isar queries
- Derive computed state from multiple providers inside a dedicated `Provider` (e.g., `dashboardScheduleProvider`)
- Wrap only time-dependent widgets in `Consumer` to avoid full-page rebuilds
- Use `ref.watch()` for reads that should trigger rebuilds; `ref.read()` only inside callbacks

## Performance
- Avoid `IntrinsicHeight` in scrollable lists — use constrained layouts instead
- Timer/stream intervals should match UI granularity (if UI shows minutes, poll every 30s, not 1s)
- Batch database queries instead of N+1 patterns (fetch all, then join in-memory)

## Theming & Colors
- **Never hardcode colors** (`Colors.white`, `Color(0xFF222224)`) — always derive from `Theme.of(context).colorScheme` or `AppColors` semantic tokens
- All course-specific colors come from `course.colorHex` stored in the model — never derive from code letters
- Define shared text styles for recurring patterns (e.g., uppercase tracking labels)
- Register custom colors in `AppColors` and reference them by semantic name

## Code Organization
- Shared utilities (`hexToColor`, `formatTime`) go in `core/utils/`
- Constants (hardcoded hex values) go in `core/theme/app_colors.dart`
- Generated files (`.g.dart`) should stay co-located with their source model
- Use package imports (`package:nextclass/...`) for cross-feature references; relative imports within the same feature

## Data Persistence
- Settings must be persisted (SharedPreferences) — never rely on in-memory-only state for user preferences
- Isar models use UUID for cross-collection references to enable future sync

## Forms & Validation
- Always dispose `TextEditingController` instances in `dispose()`
- Use `TextInputFormatter` for formatting constraints (e.g., uppercase)
- Confirm destructive actions with dialogs before executing
