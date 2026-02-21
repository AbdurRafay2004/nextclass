# NextClass

A Flutter-based class schedule application prioritizing offline-first capabilities, a timeline UI, and high-performance list rendering.

## 🚀 Overview
NextClass is designed for students who need a fast, reliable, and visually appealing way to manage their class schedules. It features a modern timeline UI and works entirely offline by default.

## 🛠 Tech Stack
- **Framework:** [Flutter](https://flutter.dev) (iOS, Android, Windows, Mac, Linux, Web)
- **State Management:** [Riverpod](https://riverpod.dev) (Functional & Reactive)
- **Database:** [Isar](https://isar.dev) (High-performance NoSQL Database for Flutter)
- **Styling:** [Google Fonts](https://fonts.google.com) (Inter/Outfit for a premium look)
- **Workflows:** Build Runner for code generation.

## 📂 Project Structure
The project follows a **Feature-based Clean Architecture** to ensure scalability and maintainability:

```text
lib/
├── core/             # Shared utilities, database, and theme configuration
│   ├── database/     # Isar initialization and providers
│   └── theme/        # Global theme data and color schemes
├── features/         # Domain-specific modules
│   ├── course/       # Course CRUD and management
│   ├── schedule/     # Timeline and dashboard views
│   └── settings/     # App settings and theme management
└── main.dart         # Entry point and global providers setup
```

## 🏗 Key Decisions
- **Offline-First:** All data is stored locally using Isar for instant access without internet.
- **Clean Architecture:** Ensures UI, business logic, and data layers are decoupled.
- **Reactive UI:** Uses Riverpod for efficient state propagation across the app.
- **Isolated Real-Time Updates:** For clock-dependent UI components (e.g., current time, class active duration), a standalone `StreamProvider` emitting updates every minute is used. By wrapping specific components in `Consumer` or `ConsumerWidget`, this prevents full-app rebuilds, ensuring battery efficiency while keeping data highly accurate.

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

For detailed progress, refer to [CHANGELOG.md](file:///y:/Antigravity%20workspace/NextClass/nextclass/CHANGELOG.md).
