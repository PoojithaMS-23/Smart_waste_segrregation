class WasteItem {
  int? id;
  String userId;
  String imagePath;
  String classification; // biodegradable, recyclable, hazardous
  DateTime uploadDate;
  bool isCorrectlySegregated;
  int? pointsEarned;
  String? workerFeedback;

  WasteItem({
    this.id,
    required this.userId,
    required this.imagePath,
    required this.classification,
    required this.uploadDate,
    this.isCorrectlySegregated = false,
    this.pointsEarned,
    this.workerFeedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'image_path': imagePath,
      'classification': classification,
      'upload_date': uploadDate.toIso8601String(),
      'is_correctly_segregated': isCorrectlySegregated ? 1 : 0,
      'points_earned': pointsEarned,
      'worker_feedback': workerFeedback,
    };
  }

  factory WasteItem.fromMap(Map<String, dynamic> map) {
    return WasteItem(
      id: map['id'],
      userId: map['user_id'],
      imagePath: map['image_path'],
      classification: map['classification'],
      uploadDate: DateTime.parse(map['upload_date']),
      isCorrectlySegregated: map['is_correctly_segregated'] == 1,
      pointsEarned: map['points_earned'],
      workerFeedback: map['worker_feedback'],
    );
  }
}
