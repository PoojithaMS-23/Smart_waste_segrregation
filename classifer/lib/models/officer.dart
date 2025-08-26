class Officer {
  final int id;
  final String name;
  final String empId;

  Officer({required this.id, required this.name, required this.empId});

  // Convert a map from the DB into Officer
  factory Officer.fromMap(Map<String, dynamic> map) {
    return Officer(
      id: map['id'],
      name: map['name'],
      empId: map['empId'],
    );
  }

  // Convert Officer into a map to insert into DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'empId': empId,
    };
  }
}
