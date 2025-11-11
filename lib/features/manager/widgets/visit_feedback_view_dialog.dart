import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- 1. IMPORT intl
import 'package:visit_tracker_app/core/models/visit_model.dart'; // <-- 2. IMPORT VisitModel

class VisitFeedbackViewDialog extends StatelessWidget {
  // --- 3. CHANGE FROM FeedbackModel to VisitModel ---
  final VisitModel visit;
  const VisitFeedbackViewDialog({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    // 4. Access feedback from the visit model
    final feedback = visit.feedback;
    if (feedback == null) {
      return const AlertDialog(
        title: Text('Error'),
        content: Text('No feedback found for this visit.'),
      );
    }

    return AlertDialog(
      title: const Text('Submitted Feedback'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 5. ADDED NEW SECTION FOR DATE ---
              Text('Visit Completed On', style: TextStyle(color: Colors.grey[600])),
              Text(
                visit.endTime != null
                    ? DateFormat.yMd().add_jm().format(visit.endTime!)
                    : 'Date not recorded',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 32),
              // -------------------------------------

              // Display Ratings
              ...feedback.ratings.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Row(
                        children: List.generate(5, (index) => Icon(
                          index < entry.value ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        )),
                      )
                    ],
                  ),
                );
              }),
              
              const Divider(height: 32),
              
              // Display Confidence
              Text('Success Confidence', style: TextStyle(color: Colors.grey[600])),
              Text('${feedback.confidence}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              
              const SizedBox(height: 16),
              
              // Display Notes
              Text('Salesperson Notes', style: TextStyle(color: Colors.grey[600])),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(feedback.notes.isEmpty ? '(No notes submitted)' : feedback.notes),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        )
      ],
    );
  }
}