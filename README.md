# Study App - Exam Preparation Tool

A Flutter-based mobile study application designed to help students prepare for exams using multiple choice, matching, and fill-in-the-blank questions. Built with offline-first architecture using SQLite for easy distribution and use without internet connectivity.

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