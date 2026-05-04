# NextClass

A Flutter-based class schedule application prioritizing offline-first capabilities, a timeline UI, and high-performance list rendering.

## 🚀 Overview
NextClass is designed for students who need a fast, reliable, and visually appealing way to manage their class schedules. It features a modern timeline UI and works entirely offline by default.

## 🛠 Tech Stack
- **Framework:** [Flutter](https://flutter.dev) (Android)
- **State Management:** [Riverpod](https://riverpod.dev) (Functional & Reactive)
- **Database:** [Isar](https://isar.dev) (High-performance NoSQL Database for Flutter)
- **Typography:** [Google Fonts](https://fonts.google.com) — Bricolage Grotesque (variable weight 200–800)
- **Theme:** Dark-only, centralized design system
- **Workflows:** Build Runner for code generation.

## 📂 Project Structure
The project follows a **Feature-based Clean Architecture** to ensure scalability and maintainability:

```text
lib/
├── core/             # Shared utilities, database, and theme configuration
│   ├── database/     # Isar initialization and providers
│   ├── providers/    # Global providers (real-time clock)
│   ├── theme/        # Design system
│   │   ├── app_colors.dart       # Color palette + context helpers
│   │   ├── app_fonts.dart        # Centralized font (change here → whole app)
│   │   ├── app_text_styles.dart  # 16 named text styles (all typography)
│   │   └── app_theme.dart        # ThemeData (dark-only)
│   ├── utils/        # Shared utilities (color, time formatting)
│   └── widgets/      # Shared widgets (DynamicNavBar)
├── features/         # Domain-specific modules
│   ├── course/       # Course CRUD and management
│   ├── schedule/     # Timeline and dashboard views
│   ├── settings/     # App settings
│   └── sharing/      # QR-based schedule sharing (export/import)
└── main.dart         # Entry point and global providers setup
```

## 🏗 Key Decisions
- **Offline-First:** All data is stored locally using Isar for instant access without internet.
- **Clean Architecture:** Ensures UI, business logic, and data layers are decoupled.
- **Reactive UI:** Uses Riverpod for efficient state propagation across the app.
- **Dark-Only Theme:** Single dark theme for visual consistency and battery efficiency.
- **Centralized Design System:** Font (`AppFonts`), colors (`AppColors`), and text styles (`AppTextStyles`) are each editable from one file.
- **Isolated Real-Time Updates:** For clock-dependent UI components (e.g., current time, class active duration), a standalone `StreamProvider` emitting updates every minute is used. By wrapping specific components in `Consumer` or `ConsumerWidget`, this prevents full-app rebuilds, ensuring battery efficiency while keeping data highly accurate.
- **QR Schedule Sharing:** Fully offline QR-based sharing using compressed payloads (JSON → GZIP → Base64). Supports full and selective course export, with a 2500-byte safety threshold. Import supports Replace and Merge conflict modes scoped only to imported courses.

## 📝 Getting Started
To run the project locally, ensure you have the Flutter SDK installed.

1.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
2.  **Generate Code:** (Required for Isar and Riverpod)
    ```bash
    flutter pub run build_runner build
    ```
3.  **Run the App:**
    ```bash
    flutter run
    ```
4.  **Generate App Icon:**
    ```bash
    dart run flutter_launcher_icons
    ```

For detailed progress, refer to [CHANGELOG.md](CHANGELOG.md).

## 📄 License

This project is licensed under the **GNU General Public License v3.0**. 
See the [LICENSE](LICENSE) file for more details. 

*Note: If you plan to distribute a modified version of this app, your project must also be open-sourced under the same GPLv3 license.*
