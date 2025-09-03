class Complaint {
  final int? id;
  final String complainantUsername;  // who submitted
  final String message;
  final String? against; // optional - whom the complaint is against
  final String timestamp; // stored as ISO8601 string

  Complaint({
    this.id,
    required this.complainantUsername,
    required this.message,
    this.against,
    required this.timestamp,
  });

  factory Complaint.fromMap(Map<String, dynamic> json) => Complaint(
    id: json['id'] as int?,
    complainantUsername: json['complainant_username'],
    message: json['message'],
    against: json['against'],
    timestamp: json['timestamp'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'complainant_username': complainantUsername,
    'message': message,
    'against': against,
    'timestamp': timestamp,
  };
}
