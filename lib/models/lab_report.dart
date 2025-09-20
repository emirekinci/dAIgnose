import 'package:cloud_firestore/cloud_firestore.dart';

class LabReport {
  final String id;
  final String tckn;
  final String hospitalId;
  final String fileBase64;
  final Timestamp timestamp;

  LabReport({
    required this.id,
    required this.tckn,
    required this.hospitalId,
    required this.fileBase64,
    required this.timestamp,
  });

  factory LabReport.fromJson(Map<String, dynamic> json, String id) {
    return LabReport(
      id: id,
      tckn: json['tckn'],
      hospitalId: json['hospital_id'],
      fileBase64: json['fileBase64'],
      timestamp: json['uploaded_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tckn': tckn,
      'hospital_id': hospitalId,
      'fileBase64': fileBase64,
      'uploaded_at': timestamp,
    };
  }
}
