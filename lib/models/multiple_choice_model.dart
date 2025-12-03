// File: lib/models/multiple_choice_model.dart

import 'package:logger/logger.dart';

// A model class representing a multiple-choice question
class MultipleChoiceQuestion {
  final int? id;
  final String question;
  final String optionCorrect;
  final String optionA;
  final String optionB;
  final String optionC;
  final String? explanation;
  final DateTime? createdAt;

  MultipleChoiceQuestion({
    this.id,
    required this.question,
    required this.optionCorrect,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    this.explanation,
    this.createdAt,
  });

  // Convert a MultipleChoiceQuestion object into a Map
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'question': question,
      'option_correct': optionCorrect,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'explanation': explanation,
      'created_at': createdAt?.toIso8601String(),
    };
    Logger().i('Converted MultipleChoiceQuestion to Map: $map');
    return map;
  }

  // From Map to MultipleChoiceQuestion object
  factory MultipleChoiceQuestion.fromMap(Map<String, dynamic> map) {
    Logger().i('Converting Map to MultipleChoiceQuestion: $map');
    return MultipleChoiceQuestion(
      id: map['id'],
      question: map['question'],
      optionCorrect: map['option_correct'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      explanation: map['explanation'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  // Get List of multiple choice questions
  List<String> getOptionsList() {
    return [optionCorrect, optionA, optionB, optionC];
  }

  // Update fields of MultipleChoiceQuestion
  MultipleChoiceQuestion copyWith({
    int? id,
    String? question,
    String? optionCorrect,
    String? optionA,
    String? optionB,
    String? optionC,
    String? explanation,
    DateTime? createdAt,
  }) {
    return MultipleChoiceQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      optionCorrect: optionCorrect ?? this.optionCorrect,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      explanation: explanation ?? this.explanation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // From JSON to MultipleChoiceQuestion object
  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    Logger().i('Converting JSON to MultipleChoiceQuestion: $json');
    return MultipleChoiceQuestion(
      id: json['id'],
      question: json['question'],
      optionCorrect: json['optionCorrect'] ?? json['option_correct'],
      optionA: json['optionA'] ?? json['option_a'],
      optionB: json['optionB'] ?? json['option_b'],
      optionC: json['optionC'] ?? json['option_c'],
      explanation: json['explanation'],
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.parse(json['createdAt'] ?? json['created_at'])
          : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'optionCorrect': optionCorrect,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'explanation': explanation,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
