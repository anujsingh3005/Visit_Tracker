import 'package:flutter/material.dart';
import 'package:visit_tracker_app/core/services/mock_data_service.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/bar_chart_widget.dart';
import 'package:visit_tracker_app/features/salesperson/widgets/pie_chart_widget.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';
import 'package:timeago/timeago.dart' as timeago; // Make sure this import is here

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MockDataService dataService = MockDataService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Live Activity Feed
          _buildSectionTitle('Live Activity Feed'),
          Card(
            elevation: 2,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<ActivityItem>>(
                future: dataService.getLiveActivity(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LoadingIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      // Added timeago logic back
                      final String timeAgo = timeago.format(item.timestamp);
                      return ListTile(
                        leading: const Icon(Icons.flash_on, color: Colors.amber),
                        title: Text(item.title),
                        subtitle: Text(item.subtitle),
                        trailing: Text(
                          timeAgo,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Aggregated Team Dashboard
          _buildSectionTitle('Team Performance'),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("Team Visit Outcomes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // --- FIX: Added spacing ---
                  const SizedBox(height: 16),
                  const PieChartWidget(),
                  const SizedBox(height: 24),
                  const Text("Team Daily Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // --- FIX: Added spacing ---
                  const SizedBox(height: 16),
                  const BarChartWidget(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. Salesperson Leaderboard
          // --- FIX: Updated title ---
          _buildSectionTitle('Sales Leaderboard (Revenue)'),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<LeaderboardEntry>>(
                future: dataService.getLeaderboard(), // This will now fetch revenue
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const LoadingIndicator();
                  return Column(
                    children: snapshot.data!.map((entry) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(entry.imageUrl),
                      ),
                      title: Text(entry.name),
                      // --- FIX: Updated styling for revenue ---
                      trailing: Text(
                        entry.value, // This will be "$12,500" etc.
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                      ),
                    )).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}