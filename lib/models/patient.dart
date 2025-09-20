class Patient {
  final String id;
  final String email;
  final String gender;
  final String dob;
  final String firstName;
  final String lastName;
  final String phone;
  final int tckn;
  final int weight;
  final int height;

  Patient({
    required this.id,
    required this.email,
    required this.gender,
    required this.dob,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.tckn,
    required this.weight,
    required this.height,
  });

  factory Patient.fromMap(Map<String, dynamic> map, String docId) {
    return Patient(
      id: docId,
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['date_of_birth'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phone: map['phone'] ?? '',
      tckn: int.tryParse(map['tckn']?.toString() ?? '') ?? 0,
      weight: int.tryParse(map['weight']?.toString() ?? '') ?? 0,
      height: int.tryParse(map['height']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'gender': gender,
      'dob': dob,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'tckn': tckn,
      'weight': weight,
      'height': height,
    };
  }
}
