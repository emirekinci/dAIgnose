import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/appointment.dart';
import 'package:grad_project/models/appointment_with_hospital.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/services/appointment_service.dart';
import 'package:grad_project/utils/util.dart';

class PatientAppointmentList extends StatefulWidget {
  const PatientAppointmentList({super.key});

  @override
  State<PatientAppointmentList> createState() => _PatientAppointmentListState();
}

class _PatientAppointmentListState extends State<PatientAppointmentList> {
  List<AppointmentWithHospital> _appointmentsWithHospitals = [];
  bool isLoading = true;

  static const themeColor = Colors.red;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  void fetchAppointments() async {
    final appointmentWithHospitals = await AppointmentService()
        .getAppointmentsWithHospitalsForPatient(
          FirebaseAuth.instance.currentUser!.uid,
        );

    if (!mounted) return;

    setState(() {
      _appointmentsWithHospitals = appointmentWithHospitals;
      isLoading = false;
    });
  }

  void _showAppointmentDetails(
    BuildContext context,
    Appointment appointment,
    Hospital? hospital,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hospital?.name ?? AppLocalizations.of(context)!.unknown,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${AppLocalizations.of(context)!.clinic}: ${appointment.clinicType.localizeClinicType(context)}",
              ),
              const SizedBox(height: 8),
              Text(
                "${AppLocalizations.of(context)!.date}: ${appointment.date.day.toString().padLeft(2, '0')}.${appointment.date.month.toString().padLeft(2, '0')}.${appointment.date.year} - ${appointment.date.hour.toString().padLeft(2, '0')}.${appointment.date.minute.toString().padLeft(2, '0')}",
              ),
              const SizedBox(height: 16),
              if (appointment.date.isAfter(DateTime.now()))
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _confirmAndCancelAppointment(appointment.id);
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: Text(
                    AppLocalizations.of(context)!.cancel_the_appointment,
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmAndCancelAppointment(String appointmentId) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.cancel_the_appointment),
            content: Text(
              AppLocalizations.of(context)!.cancel_the_appointment_text,
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.no,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.yes,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (result == true && mounted) {
      try {
        await AppointmentService().cancelAppointment(appointmentId);

        if (!mounted) return;

        setState(() {
          _appointmentsWithHospitals.removeWhere(
            (item) => item.appointment.id == appointmentId,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.info_appointment_cancel_succesful,
            ),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${AppLocalizations.of(context)!.info_appointment_cancel_failed} $e",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 65.0),
                  Expanded(
                    child:
                        _appointmentsWithHospitals.isEmpty
                            ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: themeColor),
                                  SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.no_appointment_found,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _appointmentsWithHospitals.length,
                              itemBuilder: (context, index) {
                                final item = _appointmentsWithHospitals[index];
                                final appointment = item.appointment;
                                final hospital = item.hospital;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color:
                                      appointment.date.isAfter(DateTime.now())
                                          ? Colors.red
                                          : Colors.red.shade300,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    onTap:
                                        () => _showAppointmentDetails(
                                          context,
                                          appointment,
                                          hospital,
                                        ),
                                    title: Text(
                                      appointment.doctorName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${hospital?.name ?? AppLocalizations.of(context)!.unknown} - ${appointment.clinicType.localizeClinicType(context)}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Text(
                                      "${appointment.date.day.toString().padLeft(2, '0')}.${appointment.date.month.toString().padLeft(2, '0')}.${appointment.date.year} - ${appointment.date.hour.toString().padLeft(2, '0')}.${appointment.date.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: themeColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
