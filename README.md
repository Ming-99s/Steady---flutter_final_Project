# Steady 🔥

A habit tracking mobile app built with Flutter. Steady helps you build consistency by tracking your hobbies and daily tasks — complete your schedule every day to keep your streak alive.

---

## What is Steady?

Steady is designed around one idea: **show up every day**. You assign tasks to your habits, follow your daily schedule, and the app rewards your consistency with a streak. Miss a day and the streak resets to zero.

---

## Features

- **Create habits** — add any hobby or goal you want to track
- **Assign tasks** — break each habit into daily tasks
- **Daily schedule** — see what needs to be done today
- **Streak tracking** — streak grows every day you complete your tasks on time
- **Day-by-day history** — view your progress over time
- **Streak reset** — miss your schedule and the streak resets to zero
- **Dark mode** — toggle between light and dark theme

---

## Tech Stack

- **Flutter** — cross-platform mobile UI framework
- **Dart** — programming language
- **Provider** — state management for dark/light theme switching
- **Stateful Widgets** — used for all app logic and UI state (no external database)

> All data is managed in-memory using Flutter's built-in state management. No Firebase or local database is used.

---

## Getting Started

### Prerequisites

- Flutter SDK — [flutter.dev](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- A connected device or emulator

### 1. Clone the repository

```bash
git clone https://github.com/Ming-99s/Steady---flutter_final_Project.git
cd Steady---flutter_final_Project
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

---

## Project Structure

```
lib/
├── main.dart              — app entry point, Provider setup
├── screens/               — all app screens
├── widgets/               — reusable UI components
└── provider/
    └── theme_provider.dart — dark / light mode logic
```

---

## How It Works

```
User creates a habit
        ↓
Assigns tasks to the habit
        ↓
App generates a daily schedule
        ↓
User completes tasks each day
        ↓
Streak increases ✅  /  Miss a day → streak resets 🔄
```

---

## State Management

| What | How |
|---|---|
| Habit & task logic | `StatefulWidget` |
| Streak tracking | `StatefulWidget` |
| Dark / light theme | `Provider` |

---


## License

MIT — free to use and modify.
