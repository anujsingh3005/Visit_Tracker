// lib/features/salesperson/widgets/feedback_dialog.dart

import 'package:flutter/material.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/star_rating.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final _notesController = TextEditingController();
  double _confidence = 50.0;
  
  final Map<String, int> _ratings = {
    'Interest Level': 0,
    'Budget Match': 0,
    'Decision Power': 0,
    'Urgency': 0,
    'Rapport': 0,
  };

  void _submitFeedback() {
    final feedbackData = {
      'ratings': _ratings,
      'confidence': _confidence.toInt(),
      'notes': _notesController.text,
    };
    Navigator.of(context).pop(feedbackData);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Give the content a bit more room by reducing the dialog's default padding
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      title: const Text('Pitch Feedback'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FIX APPLIED HERE: REPLACED COLUMN WITH WRAP ---
              // Wrap is like a Column or Row, but it automatically moves items
              // to the next line if there isn't enough space.
              Wrap(
                runSpacing: 12.0, // Adds vertical space between the lines of ratings
                children: _ratings.keys.map((category) => StarRating(
                  label: category,
                  onRatingChanged: (rating) => _ratings[category] = rating,
                )).toList(), // .toList() is necessary for the children of a Wrap
              ),
              
              const SizedBox(height: 24),
              Text('Success Confidence: ${_confidence.toInt()}%'),
              Slider(
                value: _confidence,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_confidence.round()}%',
                onChanged: (double value) {
                  setState(() {
                    _confidence = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitFeedback,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}