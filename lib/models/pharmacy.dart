class Pharmacy {
  final String id;
  final String name;
  final String district;
  final String address;
  final String? addressLink;
  final String phone;

  Pharmacy({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    this.addressLink,
    required this.phone,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> map, String docId) {
    return Pharmacy(
      id: docId,
      name: map['name'] ?? '',
      district: map['district'] ?? '',
      address: map['address'] ?? '',
      addressLink: map['address_link'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'district': district,
      'address': address,
      'address_link': addressLink,
      'phone': phone,
    };
  }
}
