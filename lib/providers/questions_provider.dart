// File: lib/providers/questions_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/multiple_choice_model.dart';
import '../services/mc_question_service.dart';

/// Provider to manage question list state
class QuestionsProvider extends ChangeNotifier {
  final MCQuestionService _questionService = MCQuestionService();

  List<MultipleChoiceQuestion> _questions = [];
  List<MultipleChoiceQuestion> _filteredQuestions = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<MultipleChoiceQuestion> get questions => _filteredQuestions;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int get questionCount => _questions.length;

  /// Load all questions from database
  Future<void> loadQuestions() async {
    _isLoading = true;

    // UPDATED: Wrapped in scheduleMicrotask to prevent "setState during build" error
    // This defers the notification until after the current build phase is finished.
    scheduleMicrotask(() {
      notifyListeners();
    });

    try {
      _questions = await _questionService.getAllQuestions();
      _filteredQuestions = List.from(_questions);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Add a new question
  Future<void> addQuestion(MultipleChoiceQuestion question) async {
    final id = await _questionService.insertQuestion(question);
    if (id > 0) {
      await loadQuestions(); // Reload to get the updated list
    }
  }

  /// Update an existing question
  Future<void> updateQuestion(MultipleChoiceQuestion question) async {
    final count = await _questionService.updateQuestion(question);
    if (count > 0) {
      await loadQuestions();
    }
  }

  /// Delete a question by ID
  Future<void> deleteQuestion(int id) async {
    final count = await _questionService.deleteQuestion(id);
    if (count > 0) {
      await loadQuestions();
    }
  }

  /// Delete all questions
  Future<void> deleteAllQuestions() async {
    await _questionService.deleteAllQuestions();
    await loadQuestions();
  }

  /// Bulk insert questions (for importing)
  Future<int> bulkInsertQuestions(
    List<MultipleChoiceQuestion> questions,
  ) async {
    final count = await _questionService.bulkInsertQuestions(questions);
    await loadQuestions();
    return count;
  }

  /// Search/filter questions
  void searchQuestions(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredQuestions = List.from(_questions);
    } else {
      _filteredQuestions = _questions
          .where(
            (q) =>
                q.question.toLowerCase().contains(query.toLowerCase()) ||
                q.optionCorrect.toLowerCase().contains(query.toLowerCase()) ||
                q.optionA.toLowerCase().contains(query.toLowerCase()) ||
                q.optionB.toLowerCase().contains(query.toLowerCase()) ||
                q.optionC.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredQuestions = List.from(_questions);
    notifyListeners();
  }
}
