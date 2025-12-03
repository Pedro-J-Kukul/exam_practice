// File: lib/providers/quiz_provider.dart

import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/multiple_choice_model.dart';
import '../models/quiz_attempt_model.dart';

enum FeedbackMode { immediate, endOfQuiz }

/// Provider to manage quiz state and quiz attempts
class QuizProvider extends ChangeNotifier {
  List<MultipleChoiceQuestion> _quizQuestions = [];
  List<QuizAttempt> _attempts = [];
  int _currentQuestionIndex = 0;
  FeedbackMode _feedbackMode = FeedbackMode.immediate;
  bool _quizCompleted = false;

  // Getters
  List<MultipleChoiceQuestion> get quizQuestions => _quizQuestions;
  List<QuizAttempt> get attempts => _attempts;
  int get currentQuestionIndex => _currentQuestionIndex;
  FeedbackMode get feedbackMode => _feedbackMode;
  bool get quizCompleted => _quizCompleted;

  int get totalQuestions => _quizQuestions.length;
  int get correctCount =>
      _attempts.where((attempt) => attempt.isCorrect).length;
  int get incorrectCount =>
      _attempts.where((attempt) => !attempt.isCorrect).length;
  double get scorePercentage =>
      totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;

  bool get isFirstQuestion => _currentQuestionIndex == 0;
  bool get isLastQuestion => _currentQuestionIndex == _quizQuestions.length - 1;

  MultipleChoiceQuestion? get currentQuestion =>
      _quizQuestions.isNotEmpty ? _quizQuestions[_currentQuestionIndex] : null;

  QuizAttempt? get currentAttempt {
    if (_currentQuestionIndex < _attempts.length) {
      return _attempts[_currentQuestionIndex];
    }
    return null;
  }

  /// Initialize a new quiz
  void startQuiz({
    required List<MultipleChoiceQuestion> questions,
    required FeedbackMode feedbackMode,
    bool shuffle = true,
  }) {
    _quizQuestions = List.from(questions);

    if (shuffle) {
      _quizQuestions.shuffle(Random());
    }

    // Initialize attempts for all questions
    _attempts = _quizQuestions.map((q) => QuizAttempt(question: q)).toList();

    _currentQuestionIndex = 0;
    _feedbackMode = feedbackMode;
    _quizCompleted = false;

    notifyListeners();
  }

  /// Set feedback mode
  void setFeedbackMode(FeedbackMode mode) {
    _feedbackMode = mode;
    notifyListeners();
  }

  /// Submit an answer for the current question
  void submitAnswer(String selectedOption) {
    if (_currentQuestionIndex >= _attempts.length) return;

    final attempt = _attempts[_currentQuestionIndex];

    // Update the attempt
    attempt.answeredOption = selectedOption;
    attempt.isLocked = true;

    notifyListeners();
  }

  /// Navigate to next question
  void nextQuestion() {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  /// Navigate to previous question
  void previousQuestion() {
    if (!isFirstQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  /// Go to a specific question index
  void goToQuestion(int index) {
    if (index >= 0 && index < _quizQuestions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  /// Complete the quiz
  void completeQuiz() {
    _quizCompleted = true;
    notifyListeners();
  }

  /// Reset the quiz
  void resetQuiz() {
    _quizQuestions = [];
    _attempts = [];
    _currentQuestionIndex = 0;
    _quizCompleted = false;
    notifyListeners();
  }

  /// Check if all questions have been answered
  bool get allQuestionsAnswered {
    return _attempts.every((attempt) => attempt.answeredOption != null);
  }

  /// Get unanswered question count
  int get unansweredCount {
    return _attempts.where((attempt) => attempt.answeredOption == null).length;
  }
}
