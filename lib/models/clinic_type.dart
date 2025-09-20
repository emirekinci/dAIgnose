class ClinicType {
  final String type;

  ClinicType({required this.type});

  factory ClinicType.fromJson(Map<String, dynamic> json) {
    return ClinicType(type: json['type'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'type': type};
  }
}
