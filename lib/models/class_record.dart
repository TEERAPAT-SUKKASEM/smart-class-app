class ClassRecord {
  String? timestamp;
  double? latitude;
  double? longitude;
  String? type; // 'check-in' or 'check-out'

  // Reflection fields
  String? prevTopic;
  String? expectedTopic;
  int? mood;
  String? learnedToday;
  String? feedback;

  ClassRecord({
    this.timestamp,
    this.latitude,
    this.longitude,
    this.type,
    this.prevTopic,
    this.expectedTopic,
    this.mood,
    this.learnedToday,
    this.feedback,
  });

  // Convert to JSON to save in Shared Preferences
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'latitude': latitude,
    'longitude': longitude,
    'type': type,
    'prevTopic': prevTopic,
    'expectedTopic': expectedTopic,
    'mood': mood,
    'learnedToday': learnedToday,
    'feedback': feedback,
  };
}
