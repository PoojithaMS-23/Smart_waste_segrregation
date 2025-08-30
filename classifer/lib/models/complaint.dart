class Complaint {
  int? id;
  String userId;
  String title;
  String description;
  String? imagePath;
  String? location;
  double? latitude;
  double? longitude;
  DateTime reportDate;
  String status; // pending, resolved, rejected
  String? officerResponse;

  Complaint({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imagePath,
    this.location,
    this.latitude,
    this.longitude,
    required this.reportDate,
    this.status = 'pending',
    this.officerResponse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'image_path': imagePath,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'report_date': reportDate.toIso8601String(),
      'status': status,
      'officer_response': officerResponse,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      imagePath: map['image_path'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      reportDate: DateTime.parse(map['report_date']),
      status: map['status'],
      officerResponse: map['officer_response'],
    );
  }
}
