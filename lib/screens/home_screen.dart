// File: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questions_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/app_footer.dart';
import 'questions/questions_list_screen.dart';
import 'quiz/quiz_settings_screen.dart';

/// Main home screen with navigation to Quiz and View Questions
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questionsProvider = Provider.of<QuestionsProvider>(
      context,
      listen: false,
    );

    await questionsProvider.loadQuestions();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Practice')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Loading questions...')
                : Consumer<QuestionsProvider>(
                    builder: (context, questionsProvider, child) {
                      final questionCount = questionsProvider.questionCount;

                      return Center(
                        child: SingleChildScrollView(
                          padding: AppConstants.paddingAllL,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: AppConstants.iconXL * 3,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: AppConstants.spacingXL),
                              Text(
                                'Exam Practice',
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppConstants.spacingS),
                              Text(
                                questionCount > 0
                                    ? '$questionCount question${questionCount != 1 ? 's' : ''} available'
                                    : 'No questions available',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppConstants.spacingXXL),
                              if (questionCount > 0) ...[
                                CustomButton(
                                  text: 'Start Quiz',
                                  icon: Icons.play_arrow,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const QuizSettingsScreen(),
                                      ),
                                    );
                                  },
                                  fullWidth: true,
                                ),
                                const SizedBox(height: AppConstants.spacingM),
                              ],
                              CustomButton(
                                text: 'View Questions',
                                icon: Icons.list_alt,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const QuestionsListScreen(),
                                    ),
                                  );
                                },
                                variant: questionCount > 0
                                    ? CustomButtonVariant.outlined
                                    : CustomButtonVariant.primary,
                                fullWidth: true,
                              ),
                              if (questionCount == 0) ...[
                                const SizedBox(height: AppConstants.spacingXXL),
                                Text(
                                  'Add questions manually or import from a CSV/JSON file to get started.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}
