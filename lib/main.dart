import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/screens/admin/admin_main.dart';
import 'package:grad_project/screens/doctor/doctor_main.dart';
import 'package:grad_project/screens/hospital/hospital_main.dart';
import 'package:grad_project/screens/login_main.dart';
import 'package:grad_project/screens/patient/patient_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        primarySwatch: Colors.red,
      ),
      builder: (context, child) {
        return ColoredBox(color: Colors.white, child: child);
      },
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if (!snapshot.hasData) {
          return LoginPage();
        }

        return FutureBuilder<dynamic>(
          future: Future.wait([getUserType(), getUsername()]),
          builder: (context, userTypeSnapshot) {
            if (userTypeSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            String? userType = userTypeSnapshot.data[0];
            String? username = userTypeSnapshot.data[1];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.popUntil(context, (route) => route.isFirst);
            });

            if (userType == "admin") {
              return AdminMain(username: username!);
            }

            if (userType == "hospital") {
              return HospitalMain(username: username!);
            }

            if (userType == "patient") {
              return PatientMain(username: username!);
            }

            if (userType == "doctor") {
              return DoctorMain(username: username!);
            }

            return LoginPage();
          },
        );
      },
    );
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
