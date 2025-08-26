class Worker {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String workerId;

  Worker({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.workerId,
  });

  // Convert a Worker into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'workerId': workerId,
    };
  }

  // Convert Map to Worker
  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      workerId: map['workerId'],
    );
  }
}
