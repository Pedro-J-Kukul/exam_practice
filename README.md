# Exam Practice App

A Flutter-based offline exam preparation application for practicing multiple-choice questions. Built with SQLite for complete offline functionality and easy distribution via APK.

## ✨ Current Features

### Multiple Choice Questions (MCQ)
- **Question Structure**: 1 correct answer + 3 incorrect options
- **Import Support**: CSV and JSON file formats with format examples built into the app
- **Full CRUD**: Add, edit, delete, and search questions
- **Quiz Modes**:
  - **Immediate Feedback**: See correct/incorrect answers right away with explanations
  - **End of Quiz Feedback**: Review all answers after completing the quiz
- **Carousel Navigation**: Swipe or navigate through questions with Previous/Next buttons
- **Progress Tracking**: Visual progress bar and question counter
- **Results Review**: Complete summary with score, percentage, and detailed answer review

### Offline First
- ✅ All data stored locally in SQLite database
- ✅ No internet required for any functionality
- ✅ Data persists across app sessions
- ✅ Works independently on each device

### User Interface
- Clean, consistent design with custom widget library
- Empty states with helpful prompts
- Search functionality for questions
- Swipe-to-delete with confirmation
- Form validation on all inputs

## 📋 Import File Formats

### CSV Format
```csv
question,optionCorrect,optionA,optionB,optionC,explanation
"What is 2+2?","4","3","5","6","Basic arithmetic"
"Capital of Japan?","Tokyo","Osaka","Kyoto","Hiroshima","Tokyo is Japan's capital city"
```

- **optionCorrect**: The correct answer
- **optionA, optionB, optionC**: The three incorrect options
- **explanation**: Optional explanation field

### JSON Format
```json
[
  {
    "question": "What is 2 + 2?",
    "optionCorrect": "4",
    "optionA": "3",
    "optionB": "5",
    "optionC": "6",
    "explanation": "Basic arithmetic"
  }
]
```

**Sample files** included: `sample_questions.csv` and `sample_questions.json`

## 🏗️ Architecture

### Technology Stack
- **Framework**: Flutter (Dart)
- **Database**: SQLite (via `sqflite`)
- **State Management**: Provider
- **File Handling**: `file_picker` for imports
- **CSV Parsing**: `csv` package

### Project Structure
```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── multiple_choice_model.dart     # MCQ data model
│   └── quiz_attempt_model.dart        # Quiz attempt tracking
├── services/
│   ├── database_service.dart          # SQLite management
│   ├── mc_question_service.dart       # CRUD operations
│   ├── import_service.dart            # CSV/JSON import
│   └── quiz_service.dart              # Quiz logic
├── providers/
│   ├── questions_provider.dart        # Question state
│   └── quiz_provider.dart             # Quiz state
├── screens/
│   ├── home_screen.dart               # Main landing
│   ├── questions/
│   │   ├── questions_list_screen.dart # Question management
│   │   ├── question_form_screen.dart  # Add/Edit form
│   │   └── import_questions_screen.dart # Import interface
│   └── quiz/
│       ├── quiz_settings_screen.dart  # Quiz configuration
│       ├── quiz_screen.dart           # Quiz with carousel
│       └── quiz_results_screen.dart   # Results & review
├── widgets/
│   ├── common/                        # Reusable widgets
│   └── multiple_choice/               # MCQ-specific widgets
└── utils/
    ├── app_theme.dart                 # Theme configuration
    └── app_constants.dart             # App constants
```

### Database Schema

```sql
CREATE TABLE multiple_choice_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT NOT NULL,
  option_correct TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  explanation TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2+)
- Android Studio / VS Code
- Android device or emulator

### Installation
```bash
# Clone the repository
git clone <repo-url>

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.4.2
  provider: ^6.1.1
  file_picker: ^10.3.7
  csv: ^6.0.0
  logger: ^2.6.2
  path: ^1.9.1
```

## 📖 Usage Guide

### Adding Questions Manually
1. Home → "View Questions"
2. Tap the + (FAB) button
3. Fill in:
   - Question text
   - Correct answer
   - Three incorrect options (A, B, C)
   - Optional explanation
4. Tap "Add Question"

### Importing Questions
1. Home → "View Questions" → Menu (⋮) → "Import from File"
2. Tap "Select File (CSV or JSON)"
3. Choose your file
4. Preview questions
5. Tap "Import X Questions"
6. Use the format help (?) button to see examples

### Taking a Quiz
1. Home → "Start Quiz"
2. Choose feedback mode:
   - **Immediate**: See answers right away
   - **End of Quiz**: See all results at the end
3. Toggle "Shuffle Questions" if desired
4. Tap "Start Quiz"
5. Select answers by tapping options
6. Navigate with Previous/Next buttons
7. Complete quiz to see results

### Managing Questions
- **Search**: Type in the search bar
- **Edit**: Tap any question in the list
- **Delete**: Swipe left on a question
- **Delete All**: Menu (⋮) → "Delete All"

## 📦 Building & Distribution

### Build Release APK
```bash
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Sharing with Friends
1. Locate the APK file (typically ~48MB)
2. Share via:
   - Google Drive / Dropbox
   - Direct file transfer
   - Firebase App Distribution
3. Friends will need to enable "Install from Unknown Sources" on Android

## 🔮 Planned Features

### New Question Types
- [ ] **Matching Questions**
  - Match terms with definitions
  - Drag-and-drop or selection interface
  - Import via CSV with term-definition pairs
  - Randomized presentation order

- [ ] **Fill-in-the-Blank Questions**
  - Text input for answers
  - Flexible answer validation (accept multiple correct variations)
  - Import via CSV with answer patterns
  - Case-insensitive matching option

### Additional Enhancements
- [ ] Categories/Tags for questions
- [ ] Timed quiz mode
- [ ] Statistics dashboard (accuracy per category, time spent, etc.)
- [ ] Spaced repetition algorithm
- [ ] Dark mode
- [ ] Export questions as CSV/JSON
- [ ] Question randomization within quiz

### Architecture Readiness
The current architecture is designed to support future question types:
- Base question model can be extended
- Polymorphic quiz state handling
- Widget factory pattern for different question renderers
- Database schema easily extensible with new tables

## 🛠️ Important Notes

### Package Info
- **carousel_slider** is listed in `pubspec.yaml` but **NOT used** - you can safely remove it. The app uses Flutter's native `PageView` for carousel functionality through custom implementation.

### Offline Functionality
- All data stored locally in SQLite
- No cloud sync (intentional for privacy and offline use)
- Each device has independent data
- Backup by exporting questions to CSV/JSON

### Performance
- Tested with 200+ questions
- Smooth scrolling and navigation
- Efficient database queries
- Minimal memory footprint

## 📄 License
MIT License - Free to use and modify

---

**Built with Flutter 💙**

## Features

### Question Types
1. **Multiple Choice Questions (MCQ)**
   - 1 question with 4 possible answers
   - Single correct answer
   - Import via JSON or CSV

2. **Matching Questions**
   - Match terms with definitions/descriptions
   - Import via CSV with question-answer pairs
   - Randomized presentation

3. **Fill-in-the-Blank (Structured Questions)**
   - Text-based questions with blank spaces
   - Manual input or CSV import
   - Flexible answer validation

### Core Features
- ✅ **Offline-first**: All data stored locally in SQLite
- ✅ **Import/Export**: CSV and JSON support for easy question management
- ✅ **Question Bank Management**: Add, edit, delete questions easily
- ✅ **Practice Modes**: Study by question type or mixed
- ✅ **Progress Tracking**: Track correct/incorrect answers
- ✅ **Review Wrong Answers**: Focus on mistakes
- ✅ **Shareable**: Easy distribution to friends via APK

## Architecture

### Technology Stack
- **Framework**: Flutter (Dart)
- **Database**: SQLite (via `sqflite` package)
- **State Management**: Provider or Riverpod (recommended)
- **File Handling**: `file_picker` for imports
- **CSV Parsing**: `csv` package
- **JSON**: Built-in Dart support

### Project Structure
```
lib/
├── main.dart
├── models/
│   ├── question.dart
│   ├── mcq_question.dart
│   ├── matching_question.dart
│   └── fill_blank_question.dart
├── services/
│   ├── database_service.dart
│   ├── import_service.dart
│   └── export_service.dart
├── screens/
│   ├── home_screen.dart
│   ├── question_bank_screen.dart
│   ├── practice_screen.dart
│   ├── results_screen.dart
│   └── import_screen.dart
├── widgets/
│   ├── mcq_widget.dart
│   ├── matching_widget.dart
│   └── fill_blank_widget.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

## Data Models

### Multiple Choice (JSON Format)
```json
[
  {
    "id": 1,
    "question": "Which is a public key algorithm?",
    "options": ["DES", "AES", "SHA", "RSA"],
    "correctAnswer": 3,
    "explanation": "RSA is a public key algorithm"
  }
]
```

### Multiple Choice (CSV Format)
```csv
question,option1,option2,option3,option4,correctAnswer,explanation
"Which is a public key algorithm?","DES","AES","SHA","RSA",4,"RSA is a public key algorithm"
```

### Matching Questions (CSV Format)
```csv
term,definition
"Risk","The probability a weakness will be exploited"
"Attack","Steps taken to achieve unauthorized result"
"Threat","The potential for violation of security"
```

### Fill-in-the-Blank (CSV Format)
```csv
question,answer,acceptableAnswers
"The ___ triad consists of Confidentiality, Integrity, and Availability","CIA","CIA|C.I.A.|C I A"
"___ attacks involve sending packets to intermediaries with spoofed source addresses","Amplification","Amplification|amplification"
```

## Database Schema

### MCQ Table
```sql
CREATE TABLE mcq_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT NOT NULL,
  option1 TEXT NOT NULL,
  option2 TEXT NOT NULL,
  option3 TEXT NOT NULL,
  option4 TEXT NOT NULL,
  correct_answer INTEGER NOT NULL,
  explanation TEXT,
  category TEXT,
  difficulty TEXT,
  times_attempted INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0
);
```

### Matching Table
```sql
CREATE TABLE matching_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  set_name TEXT,
  category TEXT,
  times_attempted INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0
);

CREATE TABLE matching_pairs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question_id INTEGER,
  term TEXT NOT NULL,
  definition TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES matching_questions(id)
);
```

### Fill-in-the-Blank Table
```sql
CREATE TABLE fill_blank_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  acceptable_answers TEXT,
  category TEXT,
  difficulty TEXT,
  times_attempted INTEGER DEFAULT 0,
  times_correct INTEGER DEFAULT 0
);
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Android device or emulator

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

### Required Packages
Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
  provider: ^6.1.1
  file_picker: ^6.1.1
  csv: ^5.1.1
  path_provider: ^2.1.1
```

## Usage Guide

### Importing Questions
1. Navigate to "Import Questions"
2. Select file type (CSV/JSON)
3. Choose question type
4. Select file from device
5. Review and confirm import

### Practicing
1. Select question type or "Mixed Practice"
2. Answer questions
3. Get immediate feedback
4. Review at the end

### Managing Questions
1. Go to "Question Bank"
2. View all questions by type
3. Edit or delete questions
4. Add new questions manually

## Distribution

### Building APK
```bash
flutter build apk --release
```

The APK will be in `build/app/outputs/flutter-apk/app-release.apk`

### Sharing with Friends
- Upload APK to Google Drive, Dropbox, etc.
- Share direct download link
- Or use Firebase App Distribution for beta testing

## Future Enhancements
- [ ] Uploading Questions
- [ ] Timed practice sessions
- [ ] Study statistics dashboard
- [ ] Spaced repetition algorithm
- [ ] Question sharing via QR codes
- [ ] Dark mode
- [ ] Cloud sync (optional)
- [ ] Export progress reports

## Contributing
Feel free to fork and submit pull requests!

## License
MIT License - Free to use and modify

---

**Note**: This app stores all data locally. Make sure to backup your question banks regularly by exporting them.