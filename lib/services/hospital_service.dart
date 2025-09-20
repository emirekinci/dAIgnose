import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/models/hospital.dart';

class HospitalService {
  final db = FirebaseFirestore.instance;

  Future<void> addHospital(
    String name,
    String username,
    String email,
    String? district,
    String address,
    String? addressLink,
    String password,
  ) async {
    FirebaseApp? secondaryApp;

    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final tempAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      UserCredential userCredential = await tempAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      await db.collection('hospital').doc(uid).set({
        'name': name,
        'username': username,
        'address': address,
        'address_link': addressLink,
        'email': email,
        'district': district,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await tempAuth.signOut();
      await secondaryApp.delete();
    } catch (e) {
      try {
        final tempAuth = FirebaseAuth.instanceFor(app: secondaryApp!);
        final currentUser = tempAuth.currentUser;
        if (currentUser != null) {
          await currentUser.delete();
        }
      } catch (_) {}
      rethrow;
    } finally {
      if (secondaryApp != null) {
        await secondaryApp.delete();
      }
    }
  }

  Future<void> addClinic(String hospitalId, String type) async {
    try {
      final existing =
          await db
              .collection('clinic')
              .where('hospital_id', isEqualTo: hospitalId)
              .where('type', isEqualTo: type)
              .get();

      if (existing.docs.isEmpty) {
        await db.collection('clinic').add({
          'hospital_id': hospitalId,
          'type': type,
        });
      } else {
        throw Exception('Bu klinik zaten eklenmiş.');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addDoctor(
    String name,
    String username,
    String email,
    String clinicId,
    String password,
    String gender,
  ) async {
    FirebaseApp? secondaryApp;

    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final tempAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      UserCredential userCredential = await tempAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      await db.runTransaction((transaction) async {
        final doctorRef = db.collection('doctor').doc(uid);
        final clinicDoctorRef = db.collection('clinic_doctor').doc();

        transaction.set(doctorRef, {
          'name': name,
          'username': username,
          'email': email,
          'gender': gender,
          'hospital_id': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.set(clinicDoctorRef, {
          'clinic_id': clinicId,
          'doctor_id': uid,
        });
      });

      await tempAuth.signOut();
      await secondaryApp.delete();
    } catch (e) {
      try {
        final tempAuth = FirebaseAuth.instanceFor(app: secondaryApp!);
        final currentUser = tempAuth.currentUser;
        if (currentUser != null) {
          await currentUser.delete();
        }
      } catch (_) {}

      if (secondaryApp != null) {
        await secondaryApp.delete();
      }

      rethrow;
    }
  }

  Future<void> linkClinicAndHospital(
    String selectedClinicId,
    String selectedDoctorId,
  ) async {
    try {
      await db.collection('clinic_doctor').add({
        'clinic_id': selectedClinicId,
        'doctor_id': selectedDoctorId,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeClinic(String clinicId) async {
    try {
      final batch = db.batch();

      final clinicDocRef = db.collection('clinic').doc(clinicId);
      batch.delete(clinicDocRef);

      final snapshot =
          await db
              .collection('clinic_doctor')
              .where('clinic_id', isEqualTo: clinicId)
              .get();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Klinik silinirken hata oluştu: $e');
    }
  }

  Future<List<Clinic>> fetchClinicsFromHospital(String hospitalId) async {
    final querySnapshot =
        await db
            .collection('clinic')
            .where("hospital_id", isEqualTo: hospitalId)
            .get();

    return querySnapshot.docs.map((doc) => Clinic.fromFirestore(doc)).toList();
  }

  Future<List<Doctor>> fetchUnassignedDoctors(String hospitalId) async {
    // Get all doctors from specified hospital
    final doctorsSnapshot =
        await db
            .collection('doctor')
            .where('hospital_id', isEqualTo: hospitalId)
            .get();

    final doctors =
        doctorsSnapshot.docs.map((doc) {
          return Doctor.fromMap(doc.data(), doc.id);
        }).toList();

    // Get doctor ids from clinic_doctor collection
    final clinicDoctorSnapshot = await db.collection('clinic_doctor').get();

    final assignedDoctorIds =
        clinicDoctorSnapshot.docs
            .map((doc) => doc['doctor_id'] as String)
            .toSet();

    // Filter unassigned doctors
    final unassignedDoctors =
        doctors
            .where((doctor) => !assignedDoctorIds.contains(doctor.id))
            .toList();

    return unassignedDoctors;
  }

  Future<List<Hospital>> getHospitals() async {
    final snapshot = await db.collection('hospital').get();

    return snapshot.docs.map((doc) {
      return Hospital.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<void> updateHospital(
    String hospitalId,
    Hospital updatedHospital,
  ) async {
    try {
      await db.collection('hospital').doc(hospitalId).update({
        'name': updatedHospital.name,
        'district': updatedHospital.district,
        'address': updatedHospital.address,
        'address_link': updatedHospital.addressLink,
      });
    } catch (e) {
      throw Exception('Hastane güncellenirken hata oluştu: $e');
    }
  }

  Future<List<Hospital>> fetchHospitalsWithClinicType(String clinicType) async {
    final clinicSnapshot =
        await db
            .collection('clinic')
            .where('type', isEqualTo: clinicType)
            .get();

    if (clinicSnapshot.docs.isEmpty) return [];

    final hospitalIds =
        clinicSnapshot.docs
            .map((doc) => doc['hospital_id'] as String)
            .toSet()
            .toList();

    List<Hospital> hospitals = [];

    for (int i = 0; i < hospitalIds.length; i += 10) {
      final chunk = hospitalIds.sublist(
        i,
        i + 10 > hospitalIds.length ? hospitalIds.length : i + 10,
      );

      final hospitalSnapshot =
          await db
              .collection('hospital')
              .where(FieldPath.documentId, whereIn: chunk)
              .get();

      hospitals.addAll(
        hospitalSnapshot.docs
            .map((doc) => Hospital.fromJson(doc.data(), doc.id))
            .toList(),
      );
    }

    return hospitals;
  }

  Future<List<Doctor>> fetchDoctorsByClinicAndHospital(
    String clinicType,
    String? hospitalId,
  ) async {
    Query clinicsQuery = db
        .collection("clinic")
        .where("type", isEqualTo: clinicType);

    if (hospitalId != null && hospitalId.isNotEmpty) {
      clinicsQuery = clinicsQuery.where("hospital_id", isEqualTo: hospitalId);
    }

    final clinicsSnap = await clinicsQuery.get();
    final clinicIds = clinicsSnap.docs.map((doc) => doc.id).toList();
    if (clinicIds.isEmpty) return [];

    final clinicDoctorSnap =
        await FirebaseFirestore.instance
            .collection("clinic_doctor")
            .where(
              "clinic_id",
              whereIn:
                  clinicIds.length > 10 ? clinicIds.sublist(0, 10) : clinicIds,
            )
            .get();

    final doctorIds =
        clinicDoctorSnap.docs.map((doc) => doc["doctor_id"] as String).toList();
    if (doctorIds.isEmpty) return [];

    Query doctorQuery = db
        .collection("doctor")
        .where(
          FieldPath.documentId,
          whereIn: doctorIds.length > 10 ? doctorIds.sublist(0, 10) : doctorIds,
        );

    if (hospitalId != null && hospitalId.isNotEmpty) {
      doctorQuery = doctorQuery.where("hospital_id", isEqualTo: hospitalId);
    }

    final doctorSnap = await doctorQuery.get();
    return doctorSnap.docs
        .map(
          (doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<List<Hospital>> getHospitalsByIds(List<String> hospitalIds) async {
    if (hospitalIds.isEmpty) return [];

    List<Hospital> allHospitals = [];

    for (var i = 0; i < hospitalIds.length; i += 10) {
      final chunk = hospitalIds.sublist(
        i,
        i + 10 > hospitalIds.length ? hospitalIds.length : i + 10,
      );

      final snapshot =
          await FirebaseFirestore.instance
              .collection('hospital')
              .where(FieldPath.documentId, whereIn: chunk)
              .get();

      allHospitals.addAll(
        snapshot.docs
            .map((doc) => Hospital.fromJson(doc.data(), doc.id))
            .toList(),
      );
    }

    return allHospitals;
  }

  Future<List<Doctor>> fetchDoctorsByHospital(String hospitalId) async {
    try {
      final querySnapshot =
          await db
              .collection('doctor')
              .where('hospital_id', isEqualTo: hospitalId)
              .get();

      return querySnapshot.docs
          .map((doc) => Doctor.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Doktorları çekerken hata oluştu: $e');
    }
  }

  Future<Hospital?> getHospitalById(String hospitalId) async {
    try {
      final doc = await db.collection('hospital').doc(hospitalId).get();

      if (doc.exists) {
        return Hospital.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }

      throw (Exception("Hastane bulunamadı."));
    } catch (e) {
      throw Exception('Hastaneyi çekerken hata oluştu: $e');
    }
  }

  Future<Doctor?> getDoctorByEmail(String email) async {
    try {
      final querySnapshot =
          await db
              .collection('doctor')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Doctor.fromMap(doc.data(), doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Doktor verisi alırken hata oluştu: $e");
    }
  }

  Future<void> uploadLabReport({
    required File file,
    required String tckn,
  }) async {
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);

    try {
      await db.collection('lab_report').add({
        'tckn': tckn,
        'hospital_id': FirebaseAuth.instance.currentUser!.uid,
        'fileBase64': base64String,
        'uploaded_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Dosya yüklenirken bir hata oluştu: $e");
    }
  }
}
