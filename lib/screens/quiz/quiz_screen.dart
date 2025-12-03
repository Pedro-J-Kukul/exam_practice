// File: lib/screens/quiz/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/multiple_choice/quiz_question_card.dart';
import 'quiz_results_screen.dart';

/// Main quiz screen with native PageView navigation
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // UPDATED: Used native PageController instead of CarouselController
  late PageController _pageController;

  // State to manage PopScope behavior
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    final quizProvider = context.read<QuizProvider>();
    _pageController = PageController(
      initialPage: quizProvider.currentQuestionIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles the exit confirmation logic
  Future<void> _handleExitAttempt() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      // Allow pop and trigger navigation
      if (mounted) {
        setState(() {
          _canPop = true;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
    }
  }

  void _completeQuiz() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    if (quizProvider.feedbackMode == FeedbackMode.endOfQuiz &&
        !quizProvider.allQuestionsAnswered) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unanswered Questions'),
          content: Text(
            'You have ${quizProvider.unansweredCount} unanswered question(s). '
            'Do you want to submit anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToResults();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quizProvider.completeQuiz();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const QuizResultsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Replaced WillPopScope with PopScope
    return PopScope(
      canPop: _canPop, // Disables back gestures when false [cite: 9]
      onPopInvokedWithResult: (didPop, result) {
        // If didPop is true, the system already handled the pop [cite: 20]
        if (didPop) return;

        // Handle vetoed pop attempt (system gesture or programmatic) [cite: 16, 18]
        _handleExitAttempt();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              return Text(
                'Question ${quizProvider.currentQuestionIndex + 1} / ${quizProvider.totalQuestions}',
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Programmatically attempt pop; triggers onPopInvokedWithResult if blocked [cite: 18]
              Navigator.of(context).maybePop();
            },
          ),
        ),
        body: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            return Column(
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value:
                      (quizProvider.currentQuestionIndex + 1) /
                      quizProvider.totalQuestions,
                  backgroundColor: Colors.grey[300],
                  minHeight: 4,
                ),

                // UPDATED: Replaced CarouselSlider with native PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: quizProvider.totalQuestions,
                    // Optional: Set physics to NeverScrollableScrollPhysics if you want to enforce buttons only
                    onPageChanged: (index) {
                      quizProvider.goToQuestion(index);
                    },
                    itemBuilder: (context, index) {
                      final question = quizProvider.quizQuestions[index];
                      final attempt = quizProvider.attempts[index];

                      return QuizQuestionCard(
                        question: question,
                        attempt: attempt,
                        onAnswerSelected: (selectedOption) {
                          quizProvider.submitAnswer(selectedOption);
                        },
                        feedbackMode: quizProvider.feedbackMode,
                      );
                    },
                  ),
                ),

                // Navigation buttons
                Container(
                  padding: AppConstants.paddingAll,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        offset: const Offset(0, -2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        // Previous button
                        if (!quizProvider.isFirstQuestion)
                          Expanded(
                            child: CustomButton(
                              text: 'Previous',
                              icon: Icons.arrow_back,
                              variant: CustomButtonVariant.outlined,
                              onPressed: () {
                                quizProvider.previousQuestion();
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        if (!quizProvider.isFirstQuestion)
                          const SizedBox(width: AppConstants.spacingM),

                        // Next or Complete button
                        Expanded(
                          flex: quizProvider.isFirstQuestion ? 1 : 1,
                          child: CustomButton(
                            text: quizProvider.isLastQuestion
                                ? 'Complete Quiz'
                                : 'Next',
                            icon: quizProvider.isLastQuestion
                                ? Icons.check
                                : Icons.arrow_forward,
                            onPressed: () {
                              if (quizProvider.isLastQuestion) {
                                _completeQuiz();
                              } else {
                                quizProvider.nextQuestion();
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
