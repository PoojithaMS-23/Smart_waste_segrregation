class Member {
  int? id;
  String ownerName;
  String doorNumber;
  String area;
  String district;
  String pid;
  String sasId;
  int points;
  double taxAmount;
  double taxAfterConcession;

  String? username;
  String? password; // stored as hashed string or null
  String? houseType;

  Member({
    this.id,
    required this.ownerName,
    required this.doorNumber,
    required this.area,
    required this.district,
    required this.pid,
    required this.sasId,
    this.points = 0,
    this.taxAmount = 0.0,
    this.taxAfterConcession = 0.0,
    this.username,
    this.password,
    this.houseType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_name': ownerName,
      'door_number': doorNumber,
      'area': area,
      'district': district,
      'pid': pid,
      'sas_id': sasId,
      'points': points,
      'tax_amount': taxAmount,
      'tax_after_concession': taxAfterConcession,
      'username': username,
      'password': password,
      'house_type': houseType,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
      ownerName: map['owner_name'] ?? '',
      doorNumber: map['door_number'] ?? '',
      area: map['area'] ?? '',
      district: map['district'] ?? '',
      pid: map['pid'] ?? '',
      sasId: map['sas_id'] ?? '',
      points: map['points'] ?? 0,
      taxAmount: (map['tax_amount'] is num) ? (map['tax_amount'] as num).toDouble() : 0.0,
      taxAfterConcession: (map['tax_after_concession'] is num) ? (map['tax_after_concession'] as num).toDouble() : 0.0,
      username: map['username'],
      password: map['password'],
      houseType: map['house_type'],
    );
  }
}
