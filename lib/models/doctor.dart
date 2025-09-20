class Doctor {
  final String id;
  final String email;
  final String gender;
  final String hospitalId;
  final String name;

  Doctor({
    required this.id,
    required this.email,
    required this.gender,
    required this.hospitalId,
    required this.name,
  });

  factory Doctor.fromMap(Map<String, dynamic> map, String docId) {
    return Doctor(
      id: docId,
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      hospitalId: map['hospital_id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'gender': gender,
      'hospital_id': hospitalId,
      'name': name,
    };
  }
}
