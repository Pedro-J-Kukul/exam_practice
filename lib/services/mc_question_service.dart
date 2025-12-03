// File: lib/services/mc_question_service.dart

import 'package:logger/logger.dart';
import '../models/multiple_choice_model.dart';
import 'database_service.dart';

/// Service class to handle CRUD operations for Multiple Choice Questions
class MCQuestionService {
  final DatabaseService _dbService = DatabaseService();
  final Logger _logger = Logger();

  // Get all questions from the database
  Future<List<MultipleChoiceQuestion>> getAllQuestions() async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'multiple_choice_questions',
      );

      _logger.i('Retrieved ${maps.length} questions from database');

      return List.generate(maps.length, (i) {
        return MultipleChoiceQuestion.fromMap(maps[i]);
      });
    } catch (e) {
      _logger.e('Error getting all questions: $e');
      return [];
    }
  }

  // Get a question by ID
  Future<MultipleChoiceQuestion?> getQuestionById(int id) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'multiple_choice_questions',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        _logger.w('Question with id $id not found');
        return null;
      }

      return MultipleChoiceQuestion.fromMap(maps.first);
    } catch (e) {
      _logger.e('Error getting question by id $id: $e');
      return null;
    }
  }

  // Insert a new question
  Future<int> insertQuestion(MultipleChoiceQuestion question) async {
    try {
      final db = await _dbService.database;
      final id = await db.insert('multiple_choice_questions', question.toMap());
      _logger.i('Inserted question with id: $id');
      return id;
    } catch (e) {
      _logger.e('Error inserting question: $e');
      return -1;
    }
  }

  // Update an existing question
  Future<int> updateQuestion(MultipleChoiceQuestion question) async {
    try {
      final db = await _dbService.database;
      final count = await db.update(
        'multiple_choice_questions',
        question.toMap(),
        where: 'id = ?',
        whereArgs: [question.id],
      );
      _logger.i('Updated $count question(s)');
      return count;
    } catch (e) {
      _logger.e('Error updating question: $e');
      return 0;
    }
  }

  // Delete a question by ID
  Future<int> deleteQuestion(int id) async {
    try {
      final db = await _dbService.database;
      final count = await db.delete(
        'multiple_choice_questions',
        where: 'id = ?',
        whereArgs: [id],
      );
      _logger.i('Deleted $count question(s)');
      return count;
    } catch (e) {
      _logger.e('Error deleting question: $e');
      return 0;
    }
  }

  // Delete all questions
  Future<int> deleteAllQuestions() async {
    try {
      final db = await _dbService.database;
      final count = await db.delete('multiple_choice_questions');
      _logger.i('Deleted all questions ($count total)');
      return count;
    } catch (e) {
      _logger.e('Error deleting all questions: $e');
      return 0;
    }
  }

  // Get the count of questions in the database
  Future<int> getQuestionCount() async {
    try {
      final db = await _dbService.database;
      final count = await db.rawQuery(
        'SELECT COUNT(*) as count FROM multiple_choice_questions',
      );
      final total = count.first['count'] as int;
      _logger.i('Total questions in database: $total');
      return total;
    } catch (e) {
      _logger.e('Error getting question count: $e');
      return 0;
    }
  }

  // Bulk insert questions (useful for importing)
  Future<int> bulkInsertQuestions(
    List<MultipleChoiceQuestion> questions,
  ) async {
    try {
      final db = await _dbService.database;
      int successCount = 0;

      // Use a transaction for better performance
      await db.transaction((txn) async {
        for (var question in questions) {
          try {
            await txn.insert('multiple_choice_questions', question.toMap());
            successCount++;
          } catch (e) {
            _logger.w('Failed to insert question: $e');
          }
        }
      });

      _logger.i(
        'Bulk inserted $successCount out of ${questions.length} questions',
      );
      return successCount;
    } catch (e) {
      _logger.e('Error in bulk insert: $e');
      return 0;
    }
  }

  // Search questions by keyword
  Future<List<MultipleChoiceQuestion>> searchQuestions(String keyword) async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'multiple_choice_questions',
        where: 'question LIKE ?',
        whereArgs: ['%$keyword%'],
      );

      _logger.i('Found ${maps.length} questions matching "$keyword"');

      return List.generate(maps.length, (i) {
        return MultipleChoiceQuestion.fromMap(maps[i]);
      });
    } catch (e) {
      _logger.e('Error searching questions: $e');
      return [];
    }
  }
}
