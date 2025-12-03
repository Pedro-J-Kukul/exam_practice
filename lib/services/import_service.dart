// File: lib/services/import_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:logger/logger.dart';
import '../models/multiple_choice_model.dart';

/// Service to handle importing questions from CSV and JSON files
class ImportService {
  final Logger _logger = Logger();

  /// Import questions from a JSON file
  ///
  /// Expected JSON format:
  /// [
  ///   {
  ///     "question": "What is the capital of France?",
  ///     "optionCorrect": "Paris",
  ///     "optionA": "London",
  ///     "optionB": "Berlin",
  ///     "optionC": "Madrid",
  ///     "explanation": "Paris is the capital of France." (optional)
  ///   },
  ///   ...
  /// ]
  Future<List<MultipleChoiceQuestion>> importFromJson(File file) async {
    try {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);

      final questions = jsonList.map((json) {
        return MultipleChoiceQuestion.fromJson(json as Map<String, dynamic>);
      }).toList();

      _logger.i(
        'Successfully imported ${questions.length} questions from JSON',
      );
      return questions;
    } catch (e) {
      _logger.e('Error importing from JSON: $e');
      throw Exception('Failed to import JSON file: $e');
    }
  }

  /// Import questions from a CSV file
  ///
  /// Expected CSV format (with header):
  /// question,optionCorrect,optionA,optionB,optionC,explanation
  /// "What is 2+2?","4","3","5","6","Basic arithmetic"
  ///
  /// The explanation column is optional and can be empty
  Future<List<MultipleChoiceQuestion>> importFromCsv(File file) async {
    try {
      final contents = await file.readAsString();
      final List<List<dynamic>> rows = const CsvToListConverter().convert(
        contents,
        eol: '\n',
      );

      if (rows.isEmpty) {
        throw Exception('CSV file is empty');
      }

      // Check if first row is a header
      final hasHeader = _isHeaderRow(rows.first);
      final dataRows = hasHeader ? rows.skip(1) : rows;

      final questions = <MultipleChoiceQuestion>[];

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows.elementAt(i);

        if (row.length < 5) {
          _logger.w('Row ${i + 1} has insufficient columns, skipping');
          continue;
        }

        try {
          final question = MultipleChoiceQuestion(
            question: row[0].toString().trim(),
            optionCorrect: row[1].toString().trim(),
            optionA: row[2].toString().trim(),
            optionB: row[3].toString().trim(),
            optionC: row[4].toString().trim(),
            explanation: row.length > 5 && row[5].toString().isNotEmpty
                ? row[5].toString().trim()
                : null,
            createdAt: DateTime.now(),
          );
          questions.add(question);
        } catch (e) {
          _logger.w('Error parsing row ${i + 1}: $e');
        }
      }

      _logger.i('Successfully imported ${questions.length} questions from CSV');
      return questions;
    } catch (e) {
      _logger.e('Error importing from CSV: $e');
      throw Exception('Failed to import CSV file: $e');
    }
  }

  /// Check if a row is likely a header row
  bool _isHeaderRow(List<dynamic> row) {
    if (row.isEmpty) return false;

    final firstCell = row.first.toString().toLowerCase();
    return firstCell.contains('question') ||
        firstCell.contains('correct') ||
        firstCell.contains('option');
  }

  /// Get sample JSON format as a string for documentation
  String getSampleJsonFormat() {
    return '''
[
  {
    "question": "What is the capital of France?",
    "optionCorrect": "Paris",
    "optionA": "London",
    "optionB": "Berlin",
    "optionC": "Madrid",
    "explanation": "Paris is the capital and most populous city of France."
  },
  {
    "question": "Which planet is known as the Red Planet?",
    "optionCorrect": "Mars",
    "optionA": "Venus",
    "optionB": "Jupiter",
    "optionC": "Saturn",
    "explanation": "Mars appears red due to iron oxide on its surface."
  }
]
''';
  }

  /// Get sample CSV format as a string for documentation
  String getSampleCsvFormat() {
    return '''question,optionCorrect,optionA,optionB,optionC,explanation
"What is 2+2?","4","3","5","6","Basic arithmetic"
"What is the capital of Japan?","Tokyo","Osaka","Kyoto","Hiroshima","Tokyo is Japan's capital city"
"Who painted the Mona Lisa?","Leonardo da Vinci","Michelangelo","Raphael","Donatello",""
''';
  }
}
