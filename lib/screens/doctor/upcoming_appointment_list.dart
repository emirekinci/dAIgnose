import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/appointment.dart';
import 'package:grad_project/services/appointment_service.dart';

class UpcomingAppointmentList extends StatefulWidget {
  const UpcomingAppointmentList({super.key});

  @override
  State<UpcomingAppointmentList> createState() =>
      _UpcomingAppointmentListState();
}

class _UpcomingAppointmentListState extends State<UpcomingAppointmentList> {
  List<Appointment> _appointments = [];
  bool isLoading = true;

  static const themeColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    fetchDoctorsUpcomingAppoinments();
  }

  void fetchDoctorsUpcomingAppoinments() async {
    final appointments = await AppointmentService()
        .getUpcomingAppointmentsForDoctor(
          FirebaseAuth.instance.currentUser!.uid,
        );

    if (!mounted) return;

    setState(() {
      _appointments = appointments;
      isLoading = false;
    });
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
                        _appointments.isEmpty
                            ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: themeColor),
                                  SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.no_record_found,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _appointments.length,
                              itemBuilder: (context, index) {
                                final appointment = _appointments[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color: themeColor,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      appointment.patientName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
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
