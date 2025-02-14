# Chat App

A modern chat application built with Flutter.

## Getting Started

Follow these steps to run the app:

1. Clone the repository:
```bash
git clone [repository-url]
cd chat_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Setup your development environment:
   - For iOS: Make sure you have Xcode installed (Mac only)
   - For Android: Make sure you have Android Studio and an emulator set up

5. Run the app:
```bash
flutter run
```

## Important Notes

- Minimum requirements:
  - Android: SDK 21 or later
  - iOS: iOS 11.0 or later
  - Flutter: 3.0.0 or later

- Test Account:
  - Any valid Indian mobile number (10 digits starting with 6-9)
  - OTP will be shown in a snackbar (for testing purposes)

## Features

- Phone number authentication with OTP
- Persistent login state
- Real-time chat simulation
- Online/Offline status
- Message notifications
- Dark/Light theme support
- Message history
- Unread message counters
- Mock data for testing

## Troubleshooting

If you encounter any issues:

1. Clean the project:
```bash
flutter clean
```

2. Get dependencies again:
```bash
flutter pub get
```

3. Rebuild Hive adapters:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. For iOS, also run:
```bash
cd ios
pod install
cd ..
```

## Dependencies

All dependencies are listed in `pubspec.yaml`:
- hive_flutter: For local storage
- provider: For state management
- workmanager: For background tasks
- shared_preferences: For simple data persistence
- flutter_local_notifications: For push notifications

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # Business logic
├── theme/         # Theme configuration
├── widgets/       # Reusable widgets
└── main.dart      # Entry point
