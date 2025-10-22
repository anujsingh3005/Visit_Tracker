import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/models/visit_model.dart';
import 'package:visit_tracker_app/core/services/mock_data_service.dart';
import 'package:visit_tracker_app/features/salesperson/screens/salesperson_settings_screen.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/visit_list_item.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class SalespersonHomeScreen extends StatefulWidget {
  const SalespersonHomeScreen({super.key});

  @override
  State<SalespersonHomeScreen> createState() => _SalespersonHomeScreenState();
}

class _SalespersonHomeScreenState extends State<SalespersonHomeScreen> {
  final MockDataService _dataService = MockDataService();
  String _filter = 'all'; // 'all', 'pending', 'done'

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const LoadingIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.name.split(' ').first}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SalespersonSettingsScreen()));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSummaryCards(user.uid),
          const SizedBox(height: 24),
          _buildVisitsHeader(),
          const SizedBox(height: 16),
          _buildVisitsList(user.uid),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(String userId) {
    return FutureBuilder<Map<String, int>>(
      future: _dataService.getVisitSummary(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingIndicator();
        final summary = snapshot.data!;
        return Row(
          children: [
            _summaryCard('Planned', '${summary['planned'] ?? 0}', Colors.orange),
            const SizedBox(width: 16),
            _summaryCard('Completed', '${summary['completed'] ?? 0}', Colors.green),
          ],
        );
      },
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Today's Visits", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        PopupMenuButton<String>(
          onSelected: (value) => setState(() => _filter = value),
          icon: const Icon(Icons.filter_list),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'all', child: Text('All')),
            const PopupMenuItem(value: 'pending', child: Text('Pending')),
            const PopupMenuItem(value: 'done', child: Text('Done')),
          ],
        ),
      ],
    );
  }

  Widget _buildVisitsList(String userId) {
    return FutureBuilder<List<VisitModel>>(
      future: _dataService.getVisitsForSalesperson(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoadingIndicator();
        
        var visits = snapshot.data!;
        if (_filter != 'all') {
          visits = visits.where((v) => v.status == _filter).toList();
        }

        if (visits.isEmpty) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No visits found for this filter.'),
          ));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visits.length,
          itemBuilder: (context, index) {
            return VisitListItem(visit: visits[index]);
          },
        );
      },
    );
  }
}