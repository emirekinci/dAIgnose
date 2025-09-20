import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/login_form.dart';
import 'package:grad_project/screens/patient_register_first.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
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
                      color: Colors.white,
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
                      color: Colors.white,
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
                SizedBox(height: 55.0),
                Image.asset(
                  "assets/images/daignose_logo.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 25.0),
                Material(
                  borderRadius: BorderRadius.circular(20.0),
                  elevation: 7.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: MediaQuery.of(context).size.width - 45.0,
                    height: 180.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: LoginPageButton(
                                  text:
                                      "${AppLocalizations.of(context)!.doctor} ${AppLocalizations.of(context)!.login}",
                                  textColor: Colors.red,
                                  boxColor: Colors.white,
                                  icon: Icons.masks,
                                  iconColor: Colors.red,
                                  action: () {
                                    navigateToLogin(context, "doctor");
                                  },
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: LoginPageButton(
                                  text:
                                      "${AppLocalizations.of(context)!.patient} ${AppLocalizations.of(context)!.login}",
                                  boxColor: Colors.red,
                                  icon: Icons.person,
                                  iconColor: Colors.white,
                                  action: () {
                                    navigateToLogin(context, "patient");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: LoginPageButton(
                                  text:
                                      "${AppLocalizations.of(context)!.hospital} ${AppLocalizations.of(context)!.login}",
                                  boxColor: Colors.green,
                                  icon: Icons.local_hospital_outlined,
                                  action: () {
                                    navigateToLogin(context, "hospital");
                                  },
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: LoginPageButton(
                                  text:
                                      "${AppLocalizations.of(context)!.admin} ${AppLocalizations.of(context)!.login}",
                                  boxColor: Colors.blue,
                                  icon: Icons.admin_panel_settings_outlined,
                                  iconColor: Colors.white,
                                  action: () {
                                    navigateToLogin(context, "admin");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    elevation: 7.0,
                    child: LoginPageButton(
                      text: AppLocalizations.of(context)!.patient_register,
                      textColor: Colors.red,
                      boxColor: Colors.white,
                      icon: Icons.add_outlined,
                      iconColor: Colors.red,
                      widthRate: 2.0,
                      action: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientRegisterFirst(),
                          ),
                        );
                      },
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

class LoginPageButton extends StatelessWidget {
  const LoginPageButton({
    super.key,
    this.text = "",
    this.textColor = Colors.white,
    this.boxColor = Colors.white,
    this.icon,
    this.iconColor = Colors.white,
    this.action,
    this.widthRate = 2.4,
  });

  final String text;
  final Color textColor;
  final Color boxColor;
  final IconData? icon;
  final Color iconColor;
  final VoidCallback? action;
  final double widthRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / widthRate,
      height: 50.0,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextButton(
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 5.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToLogin(BuildContext context, String userType) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginForm(userType: userType)),
  );
}
