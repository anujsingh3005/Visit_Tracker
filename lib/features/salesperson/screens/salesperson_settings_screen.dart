import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class SalespersonSettingsScreen extends StatelessWidget {
  const SalespersonSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const Scaffold(body: LoadingIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profileImageUrl),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(user.designation, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          const Divider(height: 40),
          _buildDetailRow(Icons.phone, 'Phone', user.phone),
          _buildDetailRow(Icons.email, 'Email', user.email),
          _buildDetailRow(Icons.location_on, 'Address', user.address),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}