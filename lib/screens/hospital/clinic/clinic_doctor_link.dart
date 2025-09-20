import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/util.dart';

class ClinicDoctorLink extends StatefulWidget {
  const ClinicDoctorLink({super.key});

  @override
  State<ClinicDoctorLink> createState() => _ClinicDoctorLinkState();
}

class _ClinicDoctorLinkState extends State<ClinicDoctorLink> {
  late Future<List<Clinic>> _clinicsFuture;
  late Future<List<Doctor>> _doctorsFuture;
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.green;
  String? _selectedClinicId;
  String? _selectedDoctorId;

  @override
  void initState() {
    super.initState();
    _clinicsFuture = HospitalService().fetchClinicsFromHospital(
      FirebaseAuth.instance.currentUser!.uid,
    );
    _doctorsFuture = HospitalService().fetchUnassignedDoctors(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void _linkClinicAndDoctor() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (!_formKey.currentState!.validate() ||
        _selectedClinicId == null ||
        _selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validation_input_error),
        ),
      );
      return;
    }

    try {
      await HospitalService().linkClinicAndHospital(
        _selectedClinicId!,
        _selectedDoctorId!,
      );

      if (!mounted) return;

      setState(() {
        _doctorsFuture = HospitalService().fetchUnassignedDoctors(
          FirebaseAuth.instance.currentUser!.uid,
        );
        _selectedDoctorId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.info_doctor_match_succesful,
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_doctor_match_failed} $e",
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
                      SizedBox(height: 100.0),
                      Text(
                        AppLocalizations.of(context)!.match_clinic_doctor,
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
                          height: 180.0,
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
                                            style: TextStyle(
                                              color: themeColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }

                                      final clinics = snapshot.data!;
                                      return Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Positioned(
                                            right: 12,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: themeColor,
                                            ),
                                          ),
                                          DropdownButtonFormField<String>(
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
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: clinic.id,
                                                    child: Center(
                                                      child: Text(
                                                        clinic.type
                                                            .localizeClinicType(
                                                              context,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: themeColor,
                                                          fontSize: 16.0,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                            onChanged: (String? selectedId) {
                                              setState(() {
                                                _selectedClinicId = selectedId;
                                              });
                                            },
                                            validator: (selectedClinicId) {
                                              if (selectedClinicId != null) {
                                                return null;
                                              }
                                              return "";
                                            },
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                fontSize: 0.0,
                                              ),
                                              hintStyle: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 14.0,
                                                    horizontal: 16.0,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
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
                                  child: FutureBuilder<List<Doctor>>(
                                    future: _doctorsFuture,
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
                                            )!.info_no_available_doctor,
                                            style: TextStyle(
                                              color: themeColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }

                                      final doctors = snapshot.data!;
                                      return Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          Positioned(
                                            right: 12,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: themeColor,
                                            ),
                                          ),
                                          DropdownButtonFormField<String>(
                                            value: _selectedDoctorId,
                                            hint: Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.doctor,
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
                                                doctors.map((doctor) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: doctor.id,
                                                    child: Center(
                                                      child: Text(
                                                        doctor.name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: themeColor,
                                                          fontSize: 16.0,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                            onChanged: (String? selectedId) {
                                              setState(() {
                                                _selectedDoctorId = selectedId;
                                              });
                                            },
                                            validator: (selectedDoctorId) {
                                              if (selectedDoctorId != null) {
                                                return null;
                                              }
                                              return "";
                                            },
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                fontSize: 0.0,
                                              ),
                                              hintStyle: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 14.0,
                                                    horizontal: 16.0,
                                                  ),
                                            ),
                                          ),
                                        ],
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
                            width: MediaQuery.of(context).size.width / 3.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: _linkClinicAndDoctor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.link, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.match,
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
