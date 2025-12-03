// File: lib/screens/questions/import_questions_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/multiple_choice_model.dart';
import '../../providers/questions_provider.dart';
import '../../services/import_service.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';

/// Screen to import questions from CSV or JSON files
class ImportQuestionsScreen extends StatefulWidget {
  const ImportQuestionsScreen({super.key});

  @override
  State<ImportQuestionsScreen> createState() => _ImportQuestionsScreenState();
}

class _ImportQuestionsScreenState extends State<ImportQuestionsScreen> {
  final ImportService _importService = ImportService();
  List<MultipleChoiceQuestion>? _previewQuestions;
  bool _isLoading = false;
  bool _isImporting = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final extension = result.files.single.extension?.toLowerCase();

        List<MultipleChoiceQuestion> questions;

        if (extension == 'json') {
          questions = await _importService.importFromJson(file);
        } else if (extension == 'csv') {
          questions = await _importService.importFromCsv(file);
        } else {
          throw Exception('Unsupported file format');
        }

        setState(() {
          _previewQuestions = questions;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _importQuestions() async {
    if (_previewQuestions == null || _previewQuestions!.isEmpty) return;

    setState(() => _isImporting = true);

    try {
      final questionsProvider = Provider.of<QuestionsProvider>(
        context,
        listen: false,
      );

      final count = await questionsProvider.bulkInsertQuestions(
        _previewQuestions!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported $count questions successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isImporting = false;
      });
    }
  }

  void _showFormatHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Format Guide'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'JSON Format:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.spacingS),
              Container(
                padding: AppConstants.paddingAllS,
                color: Colors.grey[200],
                child: SelectableText(
                  _importService.getSampleJsonFormat(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                'CSV Format:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppConstants.spacingS),
              Container(
                padding: AppConstants.paddingAllS,
                color: Colors.grey[200],
                child: SelectableText(
                  _importService.getSampleCsvFormat(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              const Text(
                'Note: The explanation field is optional and can be left empty.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showFormatHelp,
            tooltip: 'Format Guide',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading file...')
          : Padding(
              padding: AppConstants.paddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info card
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: AppConstants.paddingAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: AppConstants.spacingS),
                              Expanded(
                                child: Text(
                                  'Import questions from CSV or JSON files',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Text(
                            'Each question should have:\n'
                            '• Question text\n'
                            '• Correct answer (optionCorrect)\n'
                            '• Three incorrect options (optionA, optionB, optionC)\n'
                            '• Optional explanation',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          TextButton.icon(
                            onPressed: _showFormatHelp,
                            icon: const Icon(Icons.visibility),
                            label: const Text('View Format Examples'),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingL),

                  // Pick file button
                  CustomButton(
                    text: 'Select File (CSV or JSON)',
                    icon: Icons.file_upload,
                    onPressed: _pickFile,
                    fullWidth: true,
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppConstants.spacingM),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: AppConstants.paddingAll,
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: AppConstants.spacingS),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Preview section
                  if (_previewQuestions != null) ...[
                    const SizedBox(height: AppConstants.spacingL),
                    Text(
                      'Preview (${_previewQuestions!.length} questions)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _previewQuestions!.length > 10
                            ? 10
                            : _previewQuestions!.length,
                        itemBuilder: (context, index) {
                          final question = _previewQuestions![index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                question.question,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '✓ ${question.optionCorrect}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_previewQuestions!.length > 10) ...[
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        'Showing first 10 of ${_previewQuestions!.length} questions',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppConstants.spacingM),
                    CustomButton(
                      text: 'Import ${_previewQuestions!.length} Questions',
                      icon: Icons.download,
                      onPressed: _importQuestions,
                      isLoading: _isImporting,
                      fullWidth: true,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
