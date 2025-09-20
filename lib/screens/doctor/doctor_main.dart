import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/doctor/diagnose_query.dart';
import 'package:grad_project/screens/doctor/lab_report_query.dart';
import 'package:grad_project/screens/doctor/upcoming_appointment_list.dart';
import 'package:grad_project/services/auth_service.dart';
import 'package:grad_project/services/clinic_service.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/util.dart';
import 'package:grad_project/widgets/main_menu_button.dart';

class DoctorMain extends ConsumerStatefulWidget {
  final String username;

  const DoctorMain({super.key, required this.username});

  @override
  ConsumerState<DoctorMain> createState() => _DoctorMainState();
}

class _DoctorMainState extends ConsumerState<DoctorMain> {
  final themeColor = Colors.orange;
  late Doctor doctor;
  late Hospital hospital;
  Clinic? clinic;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctorData();
  }

  Future<void> fetchDoctorData() async {
    final doctorResult = await HospitalService().getDoctorByEmail(
      FirebaseAuth.instance.currentUser!.email!,
    );
    final hospitalResult = await HospitalService().getHospitalById(
      doctorResult!.hospitalId,
    );
    final clinicResult = await ClinicService().getClinicByDoctorId(
      doctorResult.id,
    );

    if (!mounted) return;

    setState(() {
      doctor = doctorResult;
      hospital = hospitalResult!;
      clinic = clinicResult;
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
                doctor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(hospital.name),
              const SizedBox(height: 8),
              Text(clinic!.type.localizeClinicType(context)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 45,
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
          Center(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                Text(
                  AppLocalizations.of(context)!.welcome,
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Dr. ${widget.username}",
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35.0),
                Material(
                  borderRadius: BorderRadius.circular(20.0),
                  elevation: 7.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: MediaQuery.of(context).size.width - 70.0,
                    height: 350.0,
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
                                  builder:
                                      (context) => UpcomingAppointmentList(),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.upcoming_appointments,
                            textColor: themeColor,
                            icon: Icons.people,
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
                                  builder: (context) => DiagnoseQuery(),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(context)!.diagnose_results,
                            textColor: themeColor,
                            icon: Icons.article,
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
                                  builder: (context) => LabReportQuery(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.lab_reports,
                            textColor: themeColor,
                            icon: Icons.assignment,
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
          Positioned(
            top: 45,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.person, color: themeColor),
              onPressed: () {
                _showProfile(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
