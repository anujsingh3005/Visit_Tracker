import 'package:flutter/material.dart';
import 'package:visit_tracker_app/core/models/visit_model.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/feedback_dialog.dart';

class VisitDetailsScreen extends StatefulWidget {
  final VisitModel visit;
  const VisitDetailsScreen({super.key, required this.visit});

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  bool _isPitchInProgress = false;

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const FeedbackDialog();
      },
    ).then((feedbackData) {
      if (!mounted) return;
      setState(() {
        _isPitchInProgress = false;
      });
      if (feedbackData != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback Submitted Successfully!'), backgroundColor: Colors.green),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.visit.clientName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Map, Address, Phone, etc. remain the same
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('[ Embedded Map View ]')),
          ),
          const SizedBox(height: 24),
          Text('Address', style: TextStyle(color: Colors.grey[600])),
          Text(widget.visit.clientAddress, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text('Phone Number', style: TextStyle(color: Colors.grey[600])),
          Text(widget.visit.clientPhone, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text('Contact Person', style: TextStyle(color: Colors.grey[600])),
          Text(widget.visit.contactPersonName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('Notes', style: TextStyle(color: Colors.grey[600])),
          Text(widget.visit.clientDetails, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 40),

          // --- FIX APPLIED HERE ---
          // This entire button section will now only appear if the visit is NOT 'done'.
          if (widget.visit.status != 'done')
            if (!_isPitchInProgress)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isPitchInProgress = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pitch Started!'), backgroundColor: Colors.blue),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Start Sales Pitch'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.mic),
                    label: const Text('Pitch in Progress...'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _showFeedbackDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('End Pitch'),
                  ),
                ],
              )
        ],
      ),
    );
  }
}