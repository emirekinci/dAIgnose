import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/screens/patient/diagnose/diagnose_upload.dart';
import 'package:grad_project/widgets/main_menu_button.dart';

class DiagnoseMain extends StatelessWidget {
  const DiagnoseMain({super.key});

  final themeColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 100.0),
                Text(
                  AppLocalizations.of(context)!.disease_diagnose,
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
                    height: 250.0,
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
                                      (context) =>
                                          DiagnoseUpload(diagnoseType: "skin"),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.skin_disease_diagnose,
                            textColor: themeColor,
                            icon: Icons.spa,
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
                                          DiagnoseUpload(diagnoseType: "nail"),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.nail_disease_diagnose,
                            textColor: themeColor,
                            icon: Icons.back_hand,
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
                                          DiagnoseUpload(diagnoseType: "oral"),
                                ),
                              );
                            },
                            text:
                                AppLocalizations.of(
                                  context,
                                )!.oral_disease_diagnose,
                            textColor: themeColor,
                            icon: Icons.masks,
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

void navigateToNextDiagnose(BuildContext context, String diagnoseType) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DiagnoseUpload(diagnoseType: diagnoseType),
    ),
  );
}
