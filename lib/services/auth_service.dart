import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<User?> signIn(
    String username,
    String password,
    String type,
    context,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    try {
      String fieldToSearch = (type == "patient") ? "tckn" : "username";

      QuerySnapshot userDoc =
          await db
              .collection(type)
              .where(fieldToSearch, isEqualTo: username)
              .get();

      if (userDoc.docs.isNotEmpty) {
        var userData = userDoc.docs.first.data() as Map<String, dynamic>;

        final fieldToGetName = switch (type) {
          "patient" => "first_name",
          "doctor" => "name",
          "hospital" => "name",
          _ => "username",
        };

        try {
          await prefs.setString("userType", type);
          await prefs.setString("username", userData[fieldToGetName]);

          UserCredential userCredential = await _auth
              .signInWithEmailAndPassword(
                email: userData["email"],
                password: password,
              );

          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == "network-request-failed") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.no_network_connection,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (e.code == "invalid-credential") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.incorrect_username_or_password,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          print(e.code);
          return null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.incorrect_username_or_password,
            ),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      await prefs.remove("userType");
      await prefs.remove("username");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sign In Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
