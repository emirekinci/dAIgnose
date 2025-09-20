import 'package:cloud_firestore/cloud_firestore.dart';

class Clinic {
  final String id;
  final String type;
  final String hospitalId;

  Clinic({required this.id, required this.type, required this.hospitalId});

  factory Clinic.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Clinic(
      id: doc.id,
      type: data['type'],
      hospitalId: data['hospital_id'],
    );
  }
}
