import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/models/appointment.dart';
import 'package:grad_project/models/appointment_with_hospital.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/models/patient.dart';
import 'package:grad_project/services/patient_service.dart';

class AppointmentService {
  final db = FirebaseFirestore.instance;

  Future<int> getAvailableDaysCount(
    String doctorId, {
    int daysAhead = 7,
  }) async {
    final now = DateTime.now();
    int availableDays = 0;
    int checkedWeekdays = 0;
    int dayCounter = 0;

    const totalSlotsPerDay = 16;

    while (checkedWeekdays != 7) {
      final day = now.add(Duration(days: dayCounter));

      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        dayCounter++;
        continue;
      }

      final dayStart = DateTime(day.year, day.month, day.day, 0, 0, 0);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

      final snapshot =
          await db
              .collection('appointment')
              .where('doctor_id', isEqualTo: doctorId)
              .where('appointment_date', isGreaterThanOrEqualTo: dayStart)
              .where('appointment_date', isLessThanOrEqualTo: dayEnd)
              .get();

      final bookedSlots = snapshot.docs.length;

      if (bookedSlots < totalSlotsPerDay) {
        availableDays++;
      }
      checkedWeekdays++;
    }

    return availableDays;
  }

  Future<List<DateTime>> fetchBookedAppointments(String doctorId) async {
    final snapshot =
        await db
            .collection('appointment')
            .where('doctor_id', isEqualTo: doctorId)
            .get();

    final bookedAppointments =
        snapshot.docs.map((doc) {
          final timestamp = doc['date'] as Timestamp;
          return timestamp.toDate();
        }).toList();

    return bookedAppointments;
  }

  Future<bool> hasAnotherInSameClinic(
    String patientId,
    String clinicType,
  ) async {
    final now = DateTime.now();

    final snapshot =
        await db
            .collection('appointment')
            .where('patient_id', isEqualTo: patientId)
            .where('clinic_type', isEqualTo: clinicType)
            .where('date', isGreaterThan: Timestamp.fromDate(now))
            .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> bookAppointment({
    bool hasAnotherAppointment = false,
    required String patientId,
    required String clinicType,
    required String doctorId,
    required String doctorName,
    required String hospitalId,
    required DateTime date,
  }) async {
    try {
      final batch = db.batch();

      if (hasAnotherAppointment) {
        final now = DateTime.now();

        final existingAppointments =
            await db
                .collection('appointment')
                .where('patient_id', isEqualTo: patientId)
                .where('clinic_type', isEqualTo: clinicType)
                .where('date', isGreaterThan: Timestamp.fromDate(now))
                .limit(1)
                .get();

        if (existingAppointments.docs.isNotEmpty) {
          final existingDoc = existingAppointments.docs.first;
          batch.delete(existingDoc.reference);
        }
      }

      final patientName = await PatientService().getPatientName(patientId);

      final newDocRef = db.collection('appointment').doc();
      batch.set(newDocRef, {
        'patient_id': patientId,
        'patient_name': patientName,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'hospital_id': hospitalId,
        'clinic_type': clinicType,
        'date': Timestamp.fromDate(date),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Randevu alınırken hata oluştu: $e');
    }
  }

  Future<List<Appointment>> getUpcomingAppointmentsForDoctor(
    String doctorId,
  ) async {
    final now = Timestamp.now();

    final querySnapshot =
        await db
            .collection('appointment')
            .where('doctor_id', isEqualTo: doctorId)
            .where('date', isGreaterThanOrEqualTo: now)
            .orderBy('date')
            .get();

    return querySnapshot.docs
        .map((doc) => Appointment.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<List<Appointment>> getAppointmentsForPatient(String patientId) async {
    final querySnapshot =
        await db
            .collection('appointment')
            .where('patient_id', isEqualTo: patientId)
            .orderBy('date', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => Appointment.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<List<AppointmentWithHospital>> getAppointmentsWithHospitalsForPatient(
    String patientId,
  ) async {
    final appointments = await getAppointmentsForPatient(patientId);
    final hospitalIds = appointments.map((a) => a.hospitalId).toSet().toList();

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

    return appointments.map((a) {
      final hospital = hospitalMap[a.hospitalId];
      return AppointmentWithHospital(appointment: a, hospital: hospital);
    }).toList();
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await db.collection('appointment').doc(appointmentId).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> hasAppointmentWithPatient(String tckn, String doctorId) async {
    try {
      Patient? patient = await PatientService().getPatientByTckn(tckn);

      if (patient == null) {
        return false;
      }

      final querySnapshot =
          await db
              .collection('appointment')
              .where('doctor_id', isEqualTo: doctorId)
              .where('patient_id', isEqualTo: patient.id)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      throw Exception('Kontrol esnasında hata oluştu: $e');
    }
  }
}
