// File: lib/screens/questions/questions_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/questions_provider.dart';
import '../../models/multiple_choice_model.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/custom_card.dart';
import 'question_form_screen.dart';
import 'import_questions_screen.dart';

/// Screen to view and manage all questions
class QuestionsListScreen extends StatefulWidget {
  const QuestionsListScreen({super.key});

  @override
  State<QuestionsListScreen> createState() => _QuestionsListScreenState();
}

class _QuestionsListScreenState extends State<QuestionsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Questions'),
        content: const Text(
          'Are you sure you want to delete ALL questions? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<QuestionsProvider>(
                context,
                listen: false,
              ).deleteAllQuestions();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All questions deleted')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'import') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ImportQuestionsScreen(),
                  ),
                );
              } else if (value == 'delete_all') {
                _showDeleteAllConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload_file),
                    SizedBox(width: AppConstants.spacingS),
                    Text('Import from File'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep),
                    SizedBox(width: AppConstants.spacingS),
                    Text('Delete All'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<QuestionsProvider>(
        builder: (context, questionsProvider, child) {
          if (questionsProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (questionsProvider.questionCount == 0) {
            return EmptyState(
              icon: Icons.quiz_outlined,
              title: 'No Questions',
              message: 'Add your first question to get started.',
              actionText: 'Add Question',
              onAction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QuestionFormScreen()),
                );
              },
            );
          }

          final questions = questionsProvider.questions;

          return Column(
            children: [
              // Search bar
              Padding(
                padding: AppConstants.paddingAll,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search questions...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: questionsProvider.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              questionsProvider.clearSearch();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    questionsProvider.searchQuestions(value);
                  },
                ),
              ),

              // Question count
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingM,
                  vertical: AppConstants.spacingS,
                ),
                child: Text(
                  '${questions.length} question${questions.length != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              // Questions list
              Expanded(
                child: questions.isEmpty
                    ? const Center(
                        child: Text('No questions match your search'),
                      )
                    : ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          return Dismissible(
                            key: ValueKey(question.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Theme.of(context).colorScheme.error,
                              alignment: Alignment.centerRight,
                              padding: AppConstants.paddingHorizontal,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Question'),
                                  content: const Text(
                                    'Are you sure you want to delete this question?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              questionsProvider.deleteQuestion(question.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Question deleted'),
                                ),
                              );
                            },
                            child: _QuestionListItem(
                              question: question,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        QuestionFormScreen(question: question),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const QuestionFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Individual question list item
class _QuestionListItem extends StatelessWidget {
  final MultipleChoiceQuestion question;
  final VoidCallback onTap;

  const _QuestionListItem({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.spacingS),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: AppConstants.iconS,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.spacingXS),
              Expanded(
                child: Text(
                  question.optionCorrect,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (question.explanation != null) ...[
            const SizedBox(height: AppConstants.spacingXS),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppConstants.iconS,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: AppConstants.spacingXS),
                Expanded(
                  child: Text(
                    question.explanation!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
