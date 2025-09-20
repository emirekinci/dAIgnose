import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:grad_project/models/diagnose_result.dart';

class DiagnoseService {
  final db = FirebaseFirestore.instance;

  String generateImageHash(String base64String) {
    final bytes = utf8.encode(base64String);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> isDuplicateDiagnose(String patientId, String imageBase64) async {
    final snapshot =
        await db
            .collection('diagnose_result')
            .where('patient_id', isEqualTo: patientId)
            .where('image_hash', isEqualTo: generateImageHash(imageBase64))
            .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> addDiagnose(
    String patientId,
    String imageBase64,
    String result,
    double confidence,
    String category,
  ) async {
    await db.collection('diagnose_result').doc().set({
      'patient_id': patientId,
      'image_base64': imageBase64,
      'image_hash': generateImageHash(imageBase64),
      'result': result,
      'confidence': confidence,
      'type': category,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<List<DiagnoseResult>> getDiagnoseResults(String patientId) async {
    final querySnapshot =
        await db
            .collection('diagnose_result')
            .where('patient_id', isEqualTo: patientId)
            .orderBy('created_at', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => DiagnoseResult.fromJson(doc.data(), doc.id))
        .toList();
  }
}
