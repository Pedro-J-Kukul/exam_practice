// File: lib/screens/questions/question_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/multiple_choice_model.dart';
import '../../providers/questions_provider.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

/// Screen to add or edit a question
class QuestionFormScreen extends StatefulWidget {
  final MultipleChoiceQuestion? question;

  const QuestionFormScreen({super.key, this.question});

  @override
  State<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _correctOptionController = TextEditingController();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _optionCController = TextEditingController();
  final _explanationController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Pre-fill form if editing an existing question
    if (widget.question != null) {
      _questionController.text = widget.question!.question;
      _correctOptionController.text = widget.question!.optionCorrect;
      _optionAController.text = widget.question!.optionA;
      _optionBController.text = widget.question!.optionB;
      _optionCController.text = widget.question!.optionC;
      _explanationController.text = widget.question!.explanation ?? '';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _correctOptionController.dispose();
    _optionAController.dispose();
    _optionBController.dispose();
    _optionCController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final questionsProvider = Provider.of<QuestionsProvider>(
      context,
      listen: false,
    );

    final question = MultipleChoiceQuestion(
      id: widget.question?.id,
      question: _questionController.text.trim(),
      optionCorrect: _correctOptionController.text.trim(),
      optionA: _optionAController.text.trim(),
      optionB: _optionBController.text.trim(),
      optionC: _optionCController.text.trim(),
      explanation: _explanationController.text.trim().isEmpty
          ? null
          : _explanationController.text.trim(),
      createdAt: widget.question?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.question == null) {
        await questionsProvider.addQuestion(question);
      } else {
        await questionsProvider.updateQuestion(question);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.question == null
                  ? 'Question added successfully'
                  : 'Question updated successfully',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  String? _validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.question != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Question' : 'Add Question')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppConstants.paddingAll,
          children: [
            // Info card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: AppConstants.paddingAll,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    Expanded(
                      child: Text(
                        'Enter the correct answer and three incorrect options.',
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
            const SizedBox(height: AppConstants.spacingL),

            // Question field
            CustomTextField(
              label: 'Question *',
              hint: 'Enter your question',
              controller: _questionController,
              validator: _validateNotEmpty,
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Correct answer
            CustomTextField(
              label: 'Correct Answer *',
              hint: 'Enter the correct answer',
              controller: _correctOptionController,
              validator: _validateNotEmpty,
              suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Wrong options
            Text(
              'Incorrect Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.spacingS),

            CustomTextField(
              label: 'Option A *',
              hint: 'Enter first incorrect option',
              controller: _optionAController,
              validator: _validateNotEmpty,
            ),
            const SizedBox(height: AppConstants.spacingM),

            CustomTextField(
              label: 'Option B *',
              hint: 'Enter second incorrect option',
              controller: _optionBController,
              validator: _validateNotEmpty,
            ),
            const SizedBox(height: AppConstants.spacingM),

            CustomTextField(
              label: 'Option C *',
              hint: 'Enter third incorrect option',
              controller: _optionCController,
              validator: _validateNotEmpty,
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Explanation (optional)
            CustomTextField(
              label: 'Explanation (Optional)',
              hint: 'Explain why the correct answer is right',
              controller: _explanationController,
              maxLines: 3,
              minLines: 1,
            ),
            const SizedBox(height: AppConstants.spacingXL),

            // Save button
            CustomButton(
              text: isEditing ? 'Update Question' : 'Add Question',
              icon: isEditing ? Icons.save : Icons.add,
              onPressed: _saveQuestion,
              isLoading: _isSaving,
              fullWidth: true,
            ),
            const SizedBox(height: AppConstants.spacingS),

            // Cancel button
            CustomButton(
              text: 'Cancel',
              variant: CustomButtonVariant.text,
              onPressed: () => Navigator.of(context).pop(),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
