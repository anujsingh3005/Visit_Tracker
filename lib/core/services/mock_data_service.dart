import 'package:visit_tracker_app/core/models/user_model.dart';
import 'package:visit_tracker_app/core/models/visit_model.dart';
import 'package:visit_tracker_app/core/models/feedback_model.dart';
import 'package:visit_tracker_app/core/models/announcement_model.dart';

// --- New Model for Leaderboard ---
class LeaderboardEntry {
  final String name;
  final String imageUrl;
  final String value;
  LeaderboardEntry({required this.name, required this.imageUrl, required this.value});
}

// --- New Model for Live Activity ---
class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  ActivityItem({required this.id, required this.title, required this.subtitle, required this.timestamp});
}

class MockDataService {
  // --- Updated Salespeople Data ---
  final List<UserModel> _salespeople = [
    UserModel(
      uid: 'sales123',
      email: 'sales@test.com',
      name: 'Anuj Sharma',
      role: 'salesperson',
      phone: '+91 98765 43210',
      address: '123, Marine Drive, Mumbai',
      designation: 'Sales Executive',
      profileImageUrl: 'https://placehold.co/100x100/E6E6E6/000000?text=AS',
    ),
    UserModel(
      uid: 'sales456',
      email: 'deepika@test.com',
      name: 'Deepika Padukone',
      role: 'salesperson',
      phone: '+91 91234 56789',
      address: '456, Juhu, Mumbai',
      designation: 'Senior Executive',
      profileImageUrl: 'https://placehold.co/100x100/A9C27A/000000?text=DP',
    ),
    UserModel(
      uid: 'sales789',
      email: 'shahrukh@test.com',
      name: 'Shah Rukh Khan',
      role: 'salesperson',
      phone: '+91 99887 76655',
      address: '789, Bandra, Mumbai',
      designation: 'Area Manager',
      profileImageUrl: 'https://placehold.co/100x100/7A9EC2/000000?text=SRK',
    ),
  ];

  // --- New Mock Feedback ---
  final FeedbackModel _mockFeedback = FeedbackModel(
    ratings: {'Interest Level': 5, 'Budget Match': 3, 'Decision Power': 4, 'Urgency': 2, 'Rapport': 5},
    confidence: 75,
    notes: "Client was very interested in the new diagnostic tool. Budget is a slight concern, but the decision-maker seems convinced. Follow up next week with a quote.",
  );

  // --- Updated Mock Visits (with endTime) ---
  late final List<VisitModel> _visits = [
    VisitModel(
      id: 'v1',
      salespersonId: 'sales123',
      clientName: 'Apollo Clinic',
      contactPersonName: 'Dr. Mehra',
      clientPhone: '022 2345 6789',
      clientAddress: 'Andheri West, Mumbai',
      clientDetails: 'The Apollo Clinic in Andheri is a key potential client...',
      startTime: DateTime.now().subtract(const Duration(hours: 4)),
      endTime: null, // Pending visit
      status: 'pending',
    ),
    VisitModel(
      id: 'v2',
      salespersonId: 'sales123',
      clientName: 'Max Healthcare',
      contactPersonName: 'Ms. Gupta',
      clientPhone: '022 2876 5432',
      clientAddress: 'Bandra, Mumbai',
      clientDetails: 'Max Healthcare is a large hospital chain...',
      startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 1)), // Completed visit
      status: 'done',
      feedback: _mockFeedback,
    ),
    VisitModel(
      id: 'v3',
      salespersonId: 'sales123',
      clientName: 'Fortis Hospital',
      contactPersonName: 'Mr. Singh',
      clientPhone: '022 2987 1234',
      clientAddress: 'Mulund, Mumbai',
      clientDetails: 'A high-priority target...',
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      endTime: null, // Pending visit
      status: 'pending',
    ),
    VisitModel(
      id: 'v4',
      salespersonId: 'sales456',
      clientName: 'Global Hospital',
      contactPersonName: 'Mr. Advani',
      clientPhone: '022 2123 4567',
      clientAddress: 'Parel, Mumbai',
      clientDetails: 'New lead, first meeting.',
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      endTime: null, // Pending visit
      status: 'pending',
    ),
  ];

  // --- Mock Announcements List ---
  final List<AnnouncementModel> _announcements = [
    AnnouncementModel(
      id: 'an1',
      senderName: 'Alia Bhatt (Manager)',
      message: 'Team, please remember to submit all visit feedback by 5 PM today. It is critical for our weekly report.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AnnouncementModel(
      id: 'an2',
      senderName: 'Alia Bhatt (Manager)',
      message: 'Great work last week, everyone! We hit 95% of our visit targets. Let\'s keep up the momentum!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
  
  // --- Mock Data Methods ---
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      LeaderboardEntry(name: 'Anuj Sharma', imageUrl: 'https://placehold.co/100x100/E6E6E6/000000?text=AS', value: '\$12,500'),
      LeaderboardEntry(name: 'Deepika Padukone', imageUrl: 'https://placehold.co/100x100/A9C27A/000000?text=DP', value: '\$10,200'),
      LeaderboardEntry(name: 'Shah Rukh Khan', imageUrl: 'https://placehold.co/100x100/7A9EC2/000000?text=SRK', value: '\$8,750'),
    ];
  }

  Future<List<ActivityItem>> getLiveActivity() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      ActivityItem(id: 'a1', title: 'Anuj Sharma submitted feedback', subtitle: 'for Apollo Clinic (75% confidence)', timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
      ActivityItem(id: 'a2', title: 'Deepika Padukone started a pitch', subtitle: 'at Fortis Hospital', timestamp: DateTime.now().subtract(const Duration(minutes: 12))),
      ActivityItem(id: 'a3', title: 'New Visit "Global Health" created', subtitle: 'Assigned to Anuj Sharma', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
    ];
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _announcements.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return _announcements;
  }

  Future<void> sendAnnouncement({required String message, required String senderName}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final newAnnouncement = AnnouncementModel(
      id: 'an${_announcements.length + 1}',
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
    );
    _announcements.add(newAnnouncement);
  }

  Future<List<UserModel>> getSalespeople() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _salespeople;
  }

  Future<List<VisitModel>> getVisitsForSalesperson(String salespersonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _visits.where((visit) => visit.salespersonId == salespersonId).toList();
  }

  Future<Map<String, int>> getVisitSummary(String salespersonId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final visits = _visits.where((v) => v.salespersonId == salespersonId).toList();
    return {
      'planned': visits.where((v) => v.status == 'pending').length,
      'completed': visits.where((v) => v.status == 'done').length,
    };
  }
}