import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/patient.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/patient/appointment/appointment_search.dart';
import 'package:grad_project/screens/patient/diagnose/diagnose_main.dart';
import 'package:grad_project/screens/patient/appointment/patient_appointment_list.dart';
import 'package:grad_project/screens/patient/diagnose_list.dart';
import 'package:grad_project/screens/patient/hospital_list.dart';
import 'package:grad_project/screens/patient/lab_report_list.dart';
import 'package:grad_project/screens/patient/pharmacy_list.dart';
import 'package:grad_project/services/auth_service.dart';
import 'package:grad_project/services/patient_service.dart';
import 'package:grad_project/utils/util.dart';
import 'package:grad_project/widgets/main_menu_button.dart';

class PatientMain extends ConsumerStatefulWidget {
  final String username;

  const PatientMain({super.key, required this.username});

  @override
  ConsumerState<PatientMain> createState() => _PatientMainState();
}

class _PatientMainState extends ConsumerState<PatientMain> {
  static const themeColor = Colors.red;
  Patient? patient;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatientData();
  }

  Future<void> fetchPatientData() async {
    final result = await PatientService().getPatientByEmail(
      FirebaseAuth.instance.currentUser!.email!,
    );
    setState(() {
      patient = result;
      isLoading = false;
    });
  }

  void _showProfile(BuildContext context) {
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
                "${patient!.firstName} ${patient!.lastName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${AppLocalizations.of(context)!.birthday}: ${patient!.dob}",
              ),
              const SizedBox(height: 8),
              Text("${AppLocalizations.of(context)!.phone}: ${patient!.phone}"),
              const SizedBox(height: 8),
              Text("${patient!.weight}kg - ${patient!.height}cm"),
              const SizedBox(height: 8),
              Text(getLocalizedGender(context, patient!.gender)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 65.0),
                  Text(
                    "${AppLocalizations.of(context)!.welcome}, ${widget.username}",
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 7.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      width: MediaQuery.of(context).size.width - 70.0,
                      height: 660.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiagnoseMain(),
                                  ),
                                );
                              },
                              text:
                                  AppLocalizations.of(
                                    context,
                                  )!.disease_diagnose,
                              textColor: themeColor,
                              icon: Icons.medical_information,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DiagnoseList(
                                          patientId:
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                        ),
                                  ),
                                );
                              },
                              text:
                                  AppLocalizations.of(
                                    context,
                                  )!.my_diagnose_results,
                              textColor: themeColor,
                              icon: Icons.assignment_turned_in,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            LabReportList(tckn: patient!.tckn),
                                  ),
                                );
                              },
                              text:
                                  AppLocalizations.of(context)!.my_lab_reports,
                              textColor: themeColor,
                              icon: Icons.assignment,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PatientAppointmentList(),
                                  ),
                                );
                              },
                              text:
                                  AppLocalizations.of(context)!.my_appointments,
                              textColor: themeColor,
                              icon: Icons.event_note,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppointmentSearch(),
                                  ),
                                );
                              },
                              text:
                                  AppLocalizations.of(
                                    context,
                                  )!.book_appointment,
                              textColor: themeColor,
                              icon: Icons.event_available,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PharmacyList(),
                                  ),
                                );
                              },
                              text: AppLocalizations.of(context)!.pharmacies,
                              textColor: themeColor,
                              icon: Icons.local_pharmacy,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HospitalList(),
                                  ),
                                );
                              },
                              text: AppLocalizations.of(context)!.hospitals,
                              textColor: themeColor,
                              icon: Icons.local_hospital,
                              iconColor: themeColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MainMenuButton(
                              themeColor: themeColor,
                              onTap: () => AuthService().signOut(),
                              text: AppLocalizations.of(context)!.log_out,
                              textColor: themeColor,
                              icon: Icons.logout,
                              iconColor: themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(Icons.person, color: themeColor),
              onPressed: () {
                _showProfile(context);
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('tr'));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "TR",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    ref
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('en'));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "EN",
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
