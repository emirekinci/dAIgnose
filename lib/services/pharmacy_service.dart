import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/models/pharmacy.dart';

class PharmacyService {
  final db = FirebaseFirestore.instance;

  Future<Pharmacy?> addPharmacy(
    String name,
    String? district,
    String address,
    String? addressLink,
    String phone,
  ) async {
    try {
      await db.collection('pharmacy').doc().set({
        'name': name,
        'address': address,
        'address_link': addressLink,
        'district': district,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  Future<List<Pharmacy>> getPharmacies() async {
    final snapshot = await db.collection('pharmacy').get();

    return snapshot.docs.map((doc) {
      return Pharmacy.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<void> updatePharmacy(
    String pharmacyId,
    Pharmacy updatedPharmacy,
  ) async {
    try {
      await db.collection('pharmacy').doc(pharmacyId).update({
        'name': updatedPharmacy.name,
        'address': updatedPharmacy.address,
        'address_link': updatedPharmacy.addressLink,
        'phone': updatedPharmacy.phone,
        'district': updatedPharmacy.district,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deletePharmacy(String pharmacyId) async {
    try {
      await db.collection('pharmacy').doc(pharmacyId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
