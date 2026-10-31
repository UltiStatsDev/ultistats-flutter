# UltiStats 🥏

Mobile application for real-time Ultimate Frisbee statistics tracking.

## 🛠 Tech Stack

- **Framework:** Flutter (v3.41.6)
- **State Management:** Riverpod 3 (Notifier & Generator)
- **Navigation:** AutoRoute
- **Networking:** Retrofit & Dio

## 📦 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code
The project uses code generation for Riverpod, AutoRoute, and JSON serialization:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Build Release APK
```bash
flutter build apk --release --flavor prod --dart-define-from-file=env/env.json
```

## 🤖 CI/CD

Automated releases via GitHub Actions. Every push to the `main` branch triggers an automated build process that:
1. Extracts the version from `pubspec.yaml`.
2. Runs the build runner.
3. Generates a production APK.
4. Creates a new GitHub Release with the versioned file.

---
*Developed with ❤️ for the Ultimate Frisbee community.*
