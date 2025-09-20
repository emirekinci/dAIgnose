import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/admin/hospital_add.dart';
import 'package:grad_project/screens/admin/hospital_manage.dart';
import 'package:grad_project/screens/admin/pharmacy_add.dart';
import 'package:grad_project/screens/admin/pharmacy_manage.dart';
import 'package:grad_project/services/auth_service.dart';
import 'package:grad_project/widgets/main_menu_button.dart';

class AdminMain extends ConsumerWidget {
  final themeColor = Colors.blue;
  final String username;

  const AdminMain({super.key, required this.username});

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
                SizedBox(height: 75.0),
                Text(
                  "${AppLocalizations.of(context)!.welcome}, $username",
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
                    height: 450.0,
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
                                  builder: (context) => HospitalAdd(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.add_hospital,
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
                                  builder: (context) => PharmacyAdd(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.add_pharmacy,
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
                                  builder: (context) => HospitalManage(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.manage_hospital,
                            textColor: themeColor,
                            icon: Icons.edit,
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
                                  builder: (context) => PharmacyManage(),
                                ),
                              );
                            },
                            text: AppLocalizations.of(context)!.manage_pharmacy,
                            textColor: themeColor,
                            icon: Icons.edit,
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
