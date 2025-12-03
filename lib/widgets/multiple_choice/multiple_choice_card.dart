import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/multiple_choice_model.dart';

class MultipleChoiceCard extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final void Function(bool isCorrect)?
  onAnswerSubmitted; // Callback for parent to track score

  const MultipleChoiceCard({
    super.key,
    required this.question,
    this.onAnswerSubmitted,
  });

  @override
  State<MultipleChoiceCard> createState() => _MultipleChoiceCardState();
}

class _MultipleChoiceCardState extends State<MultipleChoiceCard> {
  late List<String> shuffledOptions;

  // STATE 1: The user's choice
  String? _selectedOption;

  // STATE 2: The lock status
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    shuffledOptions = List<String>.from(widget.question.getOptionsList());
    shuffledOptions.shuffle(Random());
  }

  void _handleSelection(String? value) {
    if (value == null) return;

    setState(() {
      _selectedOption = value;
      _isLocked = true; // LOCK the interface immediately
    });

    // Notify parent if needed (e.g., to update a score counter)
    if (widget.onAnswerSubmitted != null) {
      bool isCorrect = value == widget.question.optionCorrect;
      widget.onAnswerSubmitted!(isCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // MAIN COLUMN
          children: [
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // --- THE RADIO GROUP ---
            RadioGroup<String>(
              groupValue: _selectedOption,

              // LOGIC: If locked, pass null to disable interaction.
              // If not locked, pass the function.
              onChanged: _isLocked ? (String? _) {} : _handleSelection,

              child: Column(
                children: shuffledOptions.map((option) {
                  // Visual Logic: Determine color based on answer status
                  Color? textColor;
                  if (_isLocked) {
                    if (option == widget.question.optionCorrect) {
                      textColor = Colors.green; // Highlight correct answer
                    } else if (option == _selectedOption) {
                      textColor = Colors.red; // Highlight wrong selection
                    }
                  }

                  // Build each option row
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        // Note: Radio inherits disabled state from RadioGroup's onChanged being null
                      ),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: textColor != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      // Optional: Add a checkmark icon for the correct answer when locked
                      if (_isLocked && option == widget.question.optionCorrect)
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
