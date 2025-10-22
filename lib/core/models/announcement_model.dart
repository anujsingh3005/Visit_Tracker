class AnnouncementModel {
  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;

  AnnouncementModel({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });
}