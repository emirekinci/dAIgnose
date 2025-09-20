import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/models/lab_report.dart';
import 'package:grad_project/models/lab_report_with_hospital.dart';
import 'package:grad_project/models/patient.dart';

class PatientService {
  final db = FirebaseFirestore.instance;

  Future<void> register(
    String tckn,
    String email,
    String password,
    String firstName,
    String lastName,
    String phone,
    String dateOfBirth,
    String height,
    String weight,
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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await db.collection('patient').doc(uid).set({
        'tckn': tckn,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'date_of_birth': dateOfBirth,
        'height': height,
        'weight': weight,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseAuth.instance.signOut();
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

  Future<String> getPatientName(String patientId) async {
    final doc = await db.collection('patient').doc(patientId).get();

    final data = doc.data();
    final firstName = data?['first_name'] ?? '';
    final lastName = data?['last_name'] ?? '';
    return '$firstName $lastName'.trim().isEmpty
        ? 'Bilinmiyor'
        : '$firstName $lastName';
  }

  Future<Patient?> getPatientByEmail(String email) async {
    try {
      final querySnapshot =
          await db
              .collection('patient')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Patient.fromMap(doc.data(), doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Patient?> getPatientByTckn(String tckn) async {
    try {
      final querySnapshot =
          await db
              .collection('patient')
              .where('tckn', isEqualTo: tckn)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Patient.fromMap(doc.data(), doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LabReport>> getLabReportsForPatient(int tckn) async {
    final querySnapshot =
        await db
            .collection('lab_report')
            .where('tckn', isEqualTo: tckn.toString())
            .orderBy('uploaded_at', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => LabReport.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<List<LabReportWithHospital>> getLabReportsWithHospitals(
    int tckn,
  ) async {
    final labReports = await getLabReportsForPatient(tckn);
    final hospitalIds = labReports.map((a) => a.hospitalId).toSet().toList();

    Map<String, Hospital> hospitalMap = {};

    for (var i = 0; i < hospitalIds.length; i += 10) {
      final batch = hospitalIds.skip(i).take(10).toList();

      final hospitalsSnapshot =
          await db
              .collection('hospital')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

      for (var doc in hospitalsSnapshot.docs) {
        final hospital = Hospital.fromJson(doc.data(), doc.id);
        hospitalMap[doc.id] = hospital;
      }
    }

    return labReports.map((lab) {
      final hospital = hospitalMap[lab.hospitalId];
      return LabReportWithHospital(labReport: lab, hospital: hospital);
    }).toList();
  }
}
