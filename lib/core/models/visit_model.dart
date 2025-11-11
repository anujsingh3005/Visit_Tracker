import 'package:visit_tracker_app/core/models/feedback_model.dart';

class VisitModel {
  final String id;
  final String salespersonId;
  final String clientName;
  final String contactPersonName;
  final String clientPhone;
  final String clientAddress;
  final String clientDetails;
  final DateTime startTime;
  final DateTime? endTime; // <-- ADD THIS LINE
  final String status; // 'pending', 'done'
  final FeedbackModel? feedback;

  VisitModel({
    required this.id,
    required this.salespersonId,
    required this.clientName,
    required this.contactPersonName,
    required this.clientPhone,
    required this.clientAddress,
    required this.clientDetails,
    required this.startTime,
    this.endTime, // <-- ADD THIS LINE TO CONSTRUCTOR
    required this.status,
    this.feedback,
  });
}