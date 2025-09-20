import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String hospitalId;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String patientName;
  final DateTime date;
  final String clinicType;

  Appointment({
    required this.id,
    required this.hospitalId,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.clinicType,
  });

  factory Appointment.fromJson(Map<String, dynamic> json, String id) {
    return Appointment(
      id: id,
      hospitalId: json['hospital_id'],
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      date: (json['date'] as Timestamp).toDate(),
      clinicType: json['clinic_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospital_id': hospitalId,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'patient_id': patientId,
      'patient_name': patientName,
      'date': date.toIso8601String(),
      'clinic_type': clinicType,
    };
  }
}
