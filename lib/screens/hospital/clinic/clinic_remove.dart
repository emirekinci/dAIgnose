import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/util.dart';
import 'package:grad_project/widgets/delete_confirmation_dialog.dart';

class ClinicRemove extends StatefulWidget {
  const ClinicRemove({super.key});

  @override
  State<ClinicRemove> createState() => _ClinicRemoveState();
}

class _ClinicRemoveState extends State<ClinicRemove> {
  late Future<List<Clinic>> _clinicsFuture;
  final hospitalId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _clinicsFuture = HospitalService().fetchClinicsFromHospital(hospitalId);
  }

  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.green;
  String? _selectedClinicId;

  void _clinicRemove() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.make_selection)),
      );
      return;
    }

    try {
      await HospitalService().removeClinic(_selectedClinicId!);

      if (!mounted) return;

      setState(() {
        _clinicsFuture = HospitalService().fetchClinicsFromHospital(hospitalId);
        _selectedClinicId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_removal_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_removal_failed} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 55.0),
                      Text(
                        AppLocalizations.of(context)!.remove_clinic,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 7.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: MediaQuery.of(context).size.width - 70.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FutureBuilder<List<Clinic>>(
                                    future: _clinicsFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: themeColor,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "${AppLocalizations.of(context)!.validation_something_went_wrong} ${snapshot.error}",
                                          ),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.no_record_found,
                                          ),
                                        );
                                      }

                                      final clinics = snapshot.data!;
                                      return DropdownButtonFormField<String>(
                                        value: _selectedClinicId,
                                        hint: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.clinic,
                                            style: TextStyle(
                                              color: themeColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        isExpanded: true,
                                        icon: SizedBox.shrink(),
                                        items:
                                            clinics.map((clinic) {
                                              return DropdownMenuItem<String>(
                                                value: clinic.id,
                                                child: Center(
                                                  child: Text(
                                                    clinic.type
                                                        .localizeClinicType(
                                                          context,
                                                        ),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: themeColor,
                                                      fontSize: 16.0,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedClinicId = newValue;
                                          });
                                        },
                                        validator: (selectedClinic) {
                                          if (selectedClinic != null) {
                                            return null;
                                          }
                                          return "";
                                        },
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 0.0),
                                          hintStyle: TextStyle(
                                            color: themeColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 14.0,
                                            horizontal: 16.0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                          color: themeColor,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                  context,
                                  _clinicRemove,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.remove_the_clinic,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
