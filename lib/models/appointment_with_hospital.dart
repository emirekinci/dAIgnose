import 'appointment.dart';
import 'hospital.dart';

class AppointmentWithHospital {
  final Appointment appointment;
  final Hospital? hospital;

  AppointmentWithHospital({required this.appointment, this.hospital});
}
