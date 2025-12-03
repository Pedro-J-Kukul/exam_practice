// File: lib/widgets/multiple_choice/quiz_question_card.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/multiple_choice_model.dart';
import '../../models/quiz_attempt_model.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/app_constants.dart';

/// Card widget for displaying a question during quiz
class QuizQuestionCard extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final QuizAttempt attempt;
  final Function(String) onAnswerSelected;
  final FeedbackMode feedbackMode;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.attempt,
    required this.onAnswerSelected,
    required this.feedbackMode,
  });

  @override
  State<QuizQuestionCard> createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  late List<String> shuffledOptions;

  @override
  void initState() {
    super.initState();
    shuffledOptions = List<String>.from(widget.question.getOptionsList());
    shuffledOptions.shuffle(Random());
  }

  bool get showFeedback {
    return widget.feedbackMode == FeedbackMode.immediate &&
        widget.attempt.isLocked;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppConstants.paddingAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question card
          Card(
            child: Padding(
              padding: AppConstants.paddingAllL,
              child: Text(
                widget.question.question,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),

          // Options
          Text(
            'Select your answer:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppConstants.spacingM),

          ...shuffledOptions.map((option) {
            final isSelected = widget.attempt.answeredOption == option;
            final isCorrect = option == widget.question.optionCorrect;
            final isWrong = isSelected && !isCorrect;

            Color? backgroundColor;
            Color? borderColor;
            Color? textColor;

            if (showFeedback) {
              if (isCorrect) {
                backgroundColor = Colors.green.withAlpha(10);
                borderColor = Colors.green;
                textColor = Colors.green[800];
              } else if (isWrong) {
                backgroundColor = Colors.red.withAlpha(10);
                borderColor = Colors.red;
                textColor = Colors.red[800];
              }
            } else if (isSelected) {
              backgroundColor = Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1);
              borderColor = Theme.of(context).colorScheme.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
              child: InkWell(
                onTap: widget.attempt.isLocked
                    ? null
                    : () {
                        widget.onAnswerSelected(option);
                      },
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                child: Container(
                  padding: AppConstants.paddingAll,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                      color:
                          borderColor ??
                          (isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300]!),
                      width: isSelected || borderColor != null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Row(
                    children: [
                      // Radio indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                borderColor ??
                                (isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[400]!),
                            width: 2,
                          ),
                          color: isSelected
                              ? (borderColor ??
                                    Theme.of(context).colorScheme.primary)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.circle,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: AppConstants.spacingM),

                      // Option text
                      Expanded(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: textColor,
                                fontWeight:
                                    (isSelected || showFeedback && isCorrect)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                      ),

                      // Feedback icon
                      if (showFeedback && (isCorrect || isWrong))
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.cancel,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Feedback section (immediate mode only)
          if (showFeedback) ...[
            const SizedBox(height: AppConstants.spacingL),
            Card(
              color: widget.attempt.isCorrect
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              child: Padding(
                padding: AppConstants.paddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.attempt.isCorrect
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.attempt.isCorrect
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Text(
                          widget.attempt.isCorrect ? 'Correct!' : 'Incorrect',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: widget.attempt.isCorrect
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    if (widget.question.explanation != null) ...[
                      const SizedBox(height: AppConstants.spacingS),
                      const Divider(),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Explanation:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppConstants.spacingXS),
                      Text(
                        widget.question.explanation!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],

          // Locked indicator (end of quiz mode)
          if (widget.feedbackMode == FeedbackMode.endOfQuiz &&
              widget.attempt.isLocked) ...[
            const SizedBox(height: AppConstants.spacingM),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: AppConstants.paddingAll,
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Expanded(
                      child: Text(
                        'Answer locked. Results will be shown at the end.',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
