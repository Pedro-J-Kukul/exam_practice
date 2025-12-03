// File: lib/screens/quiz/quiz_results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_card.dart';
import '../home_screen.dart';

/// Screen to display quiz results
class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Results'),
          automaticallyImplyLeading: false,
        ),
        body: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            final score = quizProvider.correctCount;
            final total = quizProvider.totalQuestions;
            final percentage = quizProvider.scorePercentage;

            return SingleChildScrollView(
              padding: AppConstants.paddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Score card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    elevation: AppConstants.elevationM,
                    child: Padding(
                      padding: AppConstants.paddingAllL,
                      child: Column(
                        children: [
                          Icon(
                            percentage >= 70
                                ? Icons.celebration
                                : percentage >= 50
                                ? Icons.emoji_events
                                : Icons.school,
                            size: AppConstants.iconXL * 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(height: AppConstants.spacingM),
                          Text(
                            'Your Score',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Text(
                            '$score / $total',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppConstants.spacingXS),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.check_circle,
                          label: 'Correct',
                          value: quizProvider.correctCount.toString(),
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.cancel,
                          label: 'Incorrect',
                          value: quizProvider.incorrectCount.toString(),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingXL),

                  // Review section
                  Text(
                    'Review Answers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.spacingM),

                  // List of all attempts
                  ...List.generate(quizProvider.attempts.length, (index) {
                    final attempt = quizProvider.attempts[index];
                    final question = attempt.question;
                    final isCorrect = attempt.isCorrect;
                    final wasAnswered = attempt.answeredOption != null;

                    return CustomCard(
                      color: !wasAnswered
                          ? Colors.grey[100]
                          : isCorrect
                          ? Colors.green[50]
                          : Colors.red[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: !wasAnswered
                                      ? Colors.grey
                                      : isCorrect
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question.question,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(
                                      height: AppConstants.spacingS,
                                    ),
                                    if (wasAnswered) ...[
                                      Row(
                                        children: [
                                          Icon(
                                            isCorrect
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            size: AppConstants.iconS,
                                            color: isCorrect
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          const SizedBox(
                                            width: AppConstants.spacingXS,
                                          ),
                                          Text(
                                            isCorrect ? 'Correct' : 'Incorrect',
                                            style: TextStyle(
                                              color: isCorrect
                                                  ? Colors.green[700]
                                                  : Colors.red[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppConstants.spacingS,
                                      ),
                                      if (!isCorrect) ...[
                                        Text(
                                          'Your answer: ${attempt.answeredOption}',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: AppConstants.spacingXS,
                                        ),
                                      ],
                                      Text(
                                        'Correct answer: ${question.optionCorrect}',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ] else ...[
                                      const Text(
                                        'Not answered',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                    if (question.explanation != null) ...[
                                      const SizedBox(
                                        height: AppConstants.spacingS,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: AppConstants.spacingS,
                                      ),
                                      Text(
                                        'Explanation:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: AppConstants.spacingXS,
                                      ),
                                      Text(
                                        question.explanation!,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: AppConstants.spacingXXL),

                  // Action buttons
                  CustomButton(
                    text: 'Back to Home',
                    icon: Icons.home,
                    onPressed: () {
                      // Reset quiz and navigate home
                      quizProvider.resetQuiz();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    fullWidth: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppConstants.paddingAll,
        child: Column(
          children: [
            Icon(icon, color: color, size: AppConstants.iconL),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
