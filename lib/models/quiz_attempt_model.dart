// File: lib/models/quiz_attempt_model.dart
import 'multiple_choice_model.dart';

// A model class representing a quiz attempt
class QuizAttempt {
  // Declarations
  final MultipleChoiceQuestion question; // The question attempted
  String? answeredOption; // The option selected by the user
  bool isLocked; // Whether the answer was correct

  // Constructor
  QuizAttempt({
    required this.question,
    this.answeredOption,
    this.isLocked = false,
  });

  // Check if the answered option is correct
  bool get isCorrect => answeredOption == question.optionCorrect;
}
