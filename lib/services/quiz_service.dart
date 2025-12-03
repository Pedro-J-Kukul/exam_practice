// File: lib/services/quiz_service.dart
import 'package:logger/logger.dart';
import '../models/multiple_choice_model.dart';
import '../models/quiz_attempt_model.dart';
import 'mc_question_service.dart';

/// A service class to manage quiz questions and user interactions
class QuizService {
  final MCQuestionService _questionService = MCQuestionService();
  final Logger _logger = Logger();

  final List<QuizAttempt> _attempts = []; // Track user attempts
  final List<MultipleChoiceQuestion> _questions = []; // Store quiz questions

  List<QuizAttempt> get attempts => _attempts; // Getter for attempts
  List<MultipleChoiceQuestion> get questions =>
      _questions; // Getter for questions

  /// Load questions from database
  Future<void> loadQuestions() async {
    try {
      _questions.clear();
      _attempts.clear();

      final questionsFromDb = await _questionService.getAllQuestions();
      _questions.addAll(questionsFromDb);

      _logger.i('Loaded ${_questions.length} questions for quiz');
    } catch (e) {
      _logger.e('Error loading questions for quiz: $e');
    }
  }

  /// Record an attempt for a specific question
  void recordAttempt(int questionIndex, String selectedOption) {
    if (questionIndex >= _questions.length) return;

    final question = _questions[questionIndex];
    final attempt = QuizAttempt(
      question: question,
      answeredOption: selectedOption,
      isLocked: true,
    );
    _attempts.add(attempt);
    _logger.i('Recorded attempt for question $questionIndex');
  }

  /// Reset the quiz service
  void reset() {
    _questions.clear();
    _attempts.clear();
    _logger.i('Quiz service reset');
  }
}
