class UserFeedback {
  int? id;
  String userId;
  String title;
  String description;
  int rating; // 1-5 stars
  DateTime submitDate;
  String? officerResponse;

  UserFeedback({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.rating,
    required this.submitDate,
    this.officerResponse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'rating': rating,
      'submit_date': submitDate.toIso8601String(),
      'officer_response': officerResponse,
    };
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      rating: map['rating'],
      submitDate: DateTime.parse(map['submit_date']),
      officerResponse: map['officer_response'],
    );
  }
}
