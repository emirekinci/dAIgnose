class Hospital {
  final String id;
  final String username;
  final String name;
  final String district;
  final String address;
  final String? addressLink;
  final String email;

  Hospital({
    required this.id,
    required this.username,
    required this.name,
    required this.district,
    required this.address,
    this.addressLink,
    required this.email,
  });

  factory Hospital.fromJson(Map<String, dynamic> map, String docId) {
    return Hospital(
      id: docId,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      district: map['district'] ?? '',
      address: map['address'] ?? '',
      addressLink: map['address_link'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'district': district,
      'address': address,
      'address_link': addressLink,
      'email': email,
    };
  }
}
