import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:visit_tracker_app/core/models/announcement_model.dart';
import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/services/mock_data_service.dart';
import 'package:visit_tracker_app/shared/widgets/loading_indicator.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final MockDataService _dataService = MockDataService();
  final _controller = TextEditingController();
  late Future<List<AnnouncementModel>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _dataService.getAnnouncements();
  }

  void _sendAnnouncement() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    final message = _controller.text;
    
    if (message.isEmpty || user == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final senderName = '${user.name} (Manager)';
    await _dataService.sendAnnouncement(message: message, senderName: senderName);

    // --- FIX 1: Add mounted check ---
    if (!mounted) return;

    // Hide loading
    Navigator.of(context).pop(); 
    _controller.clear();
    // Refresh the list
    setState(() {
      _announcementsFuture = _dataService.getAnnouncements();
    });

    // --- FIX 2: Add mounted check ---
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement Sent!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AnnouncementModel>>(
              future: _announcementsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LoadingIndicator();
                final announcements = snapshot.data!;
                return ListView.builder(
                  reverse: true, // Shows newest at the bottom, like a chat
                  padding: const EdgeInsets.all(8.0),
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    return _buildAnnouncementCard(announcement);
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel announcement) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.senderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(announcement.message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMd().add_jm().format(announcement.timestamp),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            // --- FIX 3: Replaced deprecated withOpacity ---
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write an announcement...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendAnnouncement,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}