// File: lib/screens/quiz/quiz_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/questions_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import 'quiz_screen.dart';

/// Screen to configure quiz settings before starting
class QuizSettingsScreen extends StatefulWidget {
  const QuizSettingsScreen({super.key});

  @override
  State<QuizSettingsScreen> createState() => _QuizSettingsScreenState();
}

class _QuizSettingsScreenState extends State<QuizSettingsScreen> {
  FeedbackMode _feedbackMode = FeedbackMode.immediate;
  bool _shuffleQuestions = true;

  void _startQuiz() {
    final questionsProvider = Provider.of<QuestionsProvider>(
      context,
      listen: false,
    );
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    final allQuestions = questionsProvider.questions;

    if (allQuestions.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No questions available')));
      return;
    }

    // Start the quiz with selected settings
    quizProvider.startQuiz(
      questions: allQuestions,
      feedbackMode: _feedbackMode,
      shuffle: _shuffleQuestions,
    );

    // Navigate to quiz screen
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const QuizScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final questionCount = Provider.of<QuestionsProvider>(context).questionCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Settings')),
      body: SingleChildScrollView(
        padding: AppConstants.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question count info
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: AppConstants.paddingAll,
                child: Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: AppConstants.iconL,
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$questionCount Questions',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          Text(
                            'All questions will be included in this quiz',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXL),

            // Feedback mode section
            Text(
              'Feedback Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Choose when you want to see feedback for your answers',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppConstants.spacingM),

            // UPDATED: Wrapped options with RadioGroup [cite: 116, 120]
            // This provides keyboard navigation (arrow keys) and manages the group value.
            Card(
              child: RadioGroup<FeedbackMode>(
                groupValue: _feedbackMode,
                onChanged: (FeedbackMode? value) {
                  if (value != null) {
                    setState(() => _feedbackMode = value);
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<FeedbackMode>(
                      title: const Text('Immediate Feedback'),
                      subtitle: const Text(
                        'See correct/incorrect answers right after selecting',
                      ),
                      value: FeedbackMode.immediate,
                    ),
                    const Divider(height: 1),
                    RadioListTile<FeedbackMode>(
                      title: const Text('End of Quiz Feedback'),
                      subtitle: const Text(
                        'See all results only after completing the quiz',
                      ),
                      value: FeedbackMode.endOfQuiz,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXL),

            // Additional options
            Text(
              'Additional Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.spacingM),

            Card(
              child: SwitchListTile(
                title: const Text('Shuffle Questions'),
                subtitle: const Text('Randomize question order'),
                value: _shuffleQuestions,
                onChanged: (value) {
                  setState(() => _shuffleQuestions = value);
                },
              ),
            ),
            const SizedBox(height: AppConstants.spacingXXL),

            // Start quiz button
            CustomButton(
              text: 'Start Quiz',
              icon: Icons.play_arrow,
              onPressed: _startQuiz,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
