import 'package:flutter/material.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/services/mock_data_service.dart';
import 'package:visit_tracker_app/features/manager/screens/salesperson_details_screen.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class TeamManagementScreen extends StatefulWidget { // <-- Changed to StatefulWidget
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> { // <-- New State class
  final MockDataService _dataService = MockDataService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<UserModel>> _salespeopleFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the data once when the screen loads
    _salespeopleFuture = _dataService.getSalespeople();
    // Listen to changes in the search bar
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New Salesperson',
            onPressed: () {
              // TODO: Implement User Management
            },
          ),
        ],
      ),
      body: Column( // <-- Wrap content in a Column
        children: [
          // --- 1. ADDED SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search team members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
          // --- 2. LIST VIEW IS NOW EXPANDED ---
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _salespeopleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator(); // Show loading indicator while fetching
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No team members found.'));
                }

                // Get the salespeople list
                var salespeople = snapshot.data!;

                // --- 3. SORT ALPHABETICALLY ---
                salespeople.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                // --- 4. FILTER BASED ON SEARCH QUERY ---
                if (_searchQuery.isNotEmpty) {
                  salespeople = salespeople
                      .where((person) => person.name.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                // If filtering results in an empty list
                if (salespeople.isEmpty) {
                   return const Center(child: Text('No matching team members found.'));
                }

                // Build the list
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16.0), // Add padding at the bottom
                  itemCount: salespeople.length,
                  itemBuilder: (context, index) {
                    final salesperson = salespeople[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(salesperson.profileImageUrl),
                        ),
                        title: Text(salesperson.name),
                        subtitle: Text(salesperson.designation),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SalespersonDetailsScreen(salesperson: salesperson),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}