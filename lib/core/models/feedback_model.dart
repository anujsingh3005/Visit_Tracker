class FeedbackModel {
  final Map<String, int> ratings;
  final int confidence;
  final String notes;

  FeedbackModel({
    required this.ratings,
    required this.confidence,
    required this.notes,
  });
}