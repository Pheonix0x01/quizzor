# 🧠 Quizzor - Tech Trivia Quiz App

A modern, interactive tech trivia app built with **Flutter** that challenges users with technology-related questions. Test your knowledge across programming languages, frameworks, tools, and tech history!

## ✨ Features

### 🎯 Core Features
- **10 Random Questions** - Each quiz session presents 10 randomly selected questions from a larger question bank
- **Multiple Choice Format** - Four answer options per question with helpful hints
- **Intuitive Navigation** - Navigate using Next/Previous buttons OR swipe gestures (like Tinder!)
- **Progress Tracking** - Visual progress bar showing current question position
- **Smart Results** - Detailed score breakdown with correct/incorrect answer review
- **Retry Functionality** - Restart quiz anytime with new random questions

### 🎨 User Experience
- **Dual Theme Support** - Toggle between light and dark modes
- **Audio Experience** - Background music and button click sound effects
- **Smooth Animations** - Elegant transitions between screens
- **Responsive Design** - Clean, card-based UI that works on all screen sizes
- **Persistent Settings** - Theme and sound preferences are saved between sessions

### 🎵 Audio System
- **Background Music** - Chill ambient music during gameplay
- **Sound Effects** - Satisfying button click sounds
- **Audio Controls** - Toggle music and effects on/off anytime

### 🎮 Interactive Elements
- **Swipe Navigation** - Swipe left/right between questions
- **Hint System** - Optional hints available for each question
- **Visual Feedback** - Color-coded answer selection and results
- **Question Review** - Post-quiz review showing all correct/incorrect answers

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd quizzor
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add audio assets** (optional)
   - Place background music file at: `assets/audio/background_music.wav`
   - Place click sound file at: `assets/audio/click.wav`
   - Or use placeholder files for silent mode

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Build APK:**
```bash
flutter build apk --release
```

**Build for iOS:**
```bash
flutter build ios --release
```

The release APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   ├── providers/           # State management (Provider)
│   ├── services/            # Audio & quiz data services
│   └── theme/              # App themes (light/dark)
├── data/
│   └── models/             # Question data model
├── ui/
│   ├── screens/            # App screens (Launch, Home, Quiz, Results)
│   └── widgets/            # Reusable UI components
└── assets/
    ├── audio/              # Sound files
    └── data/               # Quiz questions (JSON)
```

## 🎯 Technical Stack

- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider
- **Local Storage:** SharedPreferences
- **Audio:** AudioPlayers
- **Fonts:** Google Fonts (Poppins)
- **Animations:** Flutter Animate

## 📱 App Flow

1. **Launch Screen** - Animated splash with app branding
2. **Home Screen** - Welcome screen with theme/audio toggles
3. **Quiz Screen** - Interactive question-answer interface
4. **Results Screen** - Score display and answer review

## 🎨 Customization

### Adding Questions
Edit `assets/data/quizzes.json` to add more questions:
```json
{
  "id": 21,
  "question": "Your question here?",
  "options": ["Option A", "Option B", "Option C", "Option D"],
  "answer_index": 0,
  "hint": "Optional hint text"
}
```

### Themes
Modify `lib/core/theme/app_theme.dart` to customize colors and styling.

### Audio
Replace audio files in `assets/audio` with your preferred sounds.

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run on device/emulator:
```bash
flutter run
```

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (with audio limitations)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🎯 Built for HNG Internship

This app was built as part of the **HNG Internship Mobile Track Stage 1** challenge, demonstrating:
- Clean app architecture
- Smooth user navigation
- Interactive UI elements
- State management
- Local data handling
- Audio integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is open source and available under the MIT License.

---

**Built with ❤️ and Flutter**

*Ready to test your tech knowledge? Download and start quizzing!* 🚀