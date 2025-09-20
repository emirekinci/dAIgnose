import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/models/clinic_type.dart';

class ClinicService {
  final db = FirebaseFirestore.instance;

  Future<List<ClinicType>> getClinics() async {
    final querySnapshot = await db.collection('clinic_type').get();

    return querySnapshot.docs
        .map((doc) => ClinicType.fromJson(doc.data()))
        .toList();
  }

  Future<Clinic?> getClinicByDoctorId(String doctorId) async {
    try {
      final querySnapshot =
          await db
              .collection('clinic_doctor')
              .where('doctor_id', isEqualTo: doctorId)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc =
          await db
              .collection('clinic')
              .doc(querySnapshot.docs.first['clinic_id'])
              .get();

      if (doc.exists) {
        return Clinic.fromFirestore(doc);
      }

      throw (Exception("Klinik bulunamadı."));
    } catch (e) {
      throw Exception('Kliniği çekerken hata oluştu: $e');
    }
  }
}
