import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Dummy Visit Data for Client History
class _DummyClientVisit {
  final String salespersonName;
  final DateTime visitTime;
  final String status;
  _DummyClientVisit(this.salespersonName, this.visitTime, this.status);
}

class ClientDetailsScreen extends StatelessWidget {
  final String clientName;
  final String clientLocation;

  // --- FIX 1: REMOVED 'const' from the constructor ---
  ClientDetailsScreen({
    super.key,
    required this.clientName,
    required this.clientLocation,
  });

  // --- FIX 2: REMOVED 'const' from the list initialization ---
  final List<_DummyClientVisit> _visitHistory = [
    _DummyClientVisit('Anuj Sharma', DateTime(2025, 10, 21, 14, 30), 'Done'),
    _DummyClientVisit('Deepika Padukone', DateTime(2025, 10, 15, 11, 00), 'Done'),
    _DummyClientVisit('Anuj Sharma', DateTime(2025, 10, 5, 16, 15), 'Cancelled'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(clientName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Basic Client Info
          ListTile(
            leading: const Icon(Icons.business_outlined, size: 40),
            title: Text(clientName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(clientLocation),
          ),
          const Divider(height: 32),

          // Visit History Section
          const Text('Visit History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_visitHistory.isEmpty)
            const Text('No visits recorded for this client.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _visitHistory.length,
              itemBuilder: (context, index) {
                final visit = _visitHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text('Visited by: ${visit.salespersonName}'),
                    subtitle: Text(DateFormat.yMd().add_jm().format(visit.visitTime)),
                    trailing: Chip(
                      label: Text(visit.status.toUpperCase()),
                      backgroundColor: visit.status == 'Done' ? Colors.green[100] : (visit.status == 'Cancelled' ? Colors.red[100] : Colors.orange[100]),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}