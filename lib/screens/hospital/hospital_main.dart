import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/hospital/clinic/clinic_add.dart';
import 'package:grad_project/screens/hospital/clinic/clinic_remove.dart';
import 'package:grad_project/screens/hospital/clinic/clinic_doctor_link.dart';
import 'package:grad_project/screens/hospital/doctor_add.dart';
import 'package:grad_project/screens/hospital/doctor_list.dart';
import 'package:grad_project/screens/hospital/lab_report_upload.dart';
import 'package:grad_project/services/auth_service.dart';
import 'package:grad_project/widgets/main_menu_button.dart';

class HospitalMain extends ConsumerWidget {
  final themeColor = Colors.green;
  final String username;

  const HospitalMain({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                SizedBox(height: 65.0),
                Text(
                  username,
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Material(
                  borderRadius: BorderRadius.circular(20.0),
                  elevation: 7.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: MediaQuery.of(context).size.width - 70.0,
                    height: 600.0,
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
                                  builder: (context) => DoctorAdd(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.add_doctor,
                            textColor: themeColor,
                            icon: Icons.person_add,
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
                                  builder: (context) => ClinicAdd(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.add_clinic,
                            textColor: themeColor,
                            icon: Icons.add_business,
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
                                  builder: (context) => ClinicDoctorLink(),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.match_clinic_doctor,
                            textColor: themeColor,
                            icon: Icons.link,
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
                                  builder: (context) => ClinicRemove(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.remove_clinic,
                            textColor: themeColor,
                            icon: Icons.delete,
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
                                  builder: (context) => DoctorList(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.doctor_list,
                            textColor: themeColor,
                            icon: Icons.list,
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
                                  builder: (context) => LabReportUpload(),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(context)!.upload_lab_report,
                            textColor: themeColor,
                            icon: Icons.upload_file,
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
        ],
      ),
    );
  }
}
