import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/models/visit_model.dart';
import 'package:visit_tracker_app/core/services/mock_data_service.dart';
import 'package:visit_tracker_app/features/manager/widgets/visit_feedback_view_dialog.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class SalespersonDetailsScreen extends StatelessWidget {
  final UserModel salesperson;
  const SalespersonDetailsScreen({super.key, required this.salesperson});

  void _showFeedback(BuildContext context, VisitModel visit) {
    // Only show feedback if it exists
    if (visit.feedback == null) return;

    showDialog(
      context: context,
      builder: (_) => VisitFeedbackViewDialog(visit: visit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataService = MockDataService();
    return Scaffold(
      appBar: AppBar(title: Text(salesperson.name)),
      body: FutureBuilder<List<VisitModel>>(
        future: dataService.getVisitsForSalesperson(salesperson.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingIndicator();
          final visits = snapshot.data!;
          if (visits.isEmpty) return const Center(child: Text('No visits recorded.'));
          
          return ListView.builder(
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              final isDone = visit.status == 'done';
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(visit.clientName),
                  subtitle: Text(DateFormat.yMd().add_jm().format(visit.startTime)),
                  trailing: Chip(
                    label: Text(visit.status.toUpperCase()),
                    backgroundColor: isDone ? Colors.green[100] : Colors.orange[100],
                  ),
                  // --- NEW: TAPPABLE IF DONE ---
                  onTap: isDone ? () => _showFeedback(context, visit) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}