import 'package:flutter/material.dart';
import 'package:visit_tracker_app/core/models/visit_model.dart';
import 'package:visit_tracker_app/features/salesperson/screens/visit_details_screen.dart';

class VisitListItem extends StatelessWidget {
  final VisitModel visit;
  const VisitListItem({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final isDone = visit.status == 'done';
    final statusColor = isDone ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => VisitDetailsScreen(visit: visit)));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(visit.clientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Chip(
                    label: Text(visit.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                    backgroundColor: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ],
              ),
              const SizedBox(height: 8),

                  // --- NEW ---
              // Displaying the contact person's name
              Text(
                'Contact: ${visit.contactPersonName}',
                style: TextStyle(color: Colors.grey[800], fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              // --- END NEW ---

              Text(visit.clientAddress, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(visit.clientPhone, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}