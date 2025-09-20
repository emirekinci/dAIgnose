import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/clinic_type.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/screens/patient/appointment/appointment_doctor_selection.dart';
import 'package:grad_project/services/clinic_service.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/util.dart';

class AppointmentSearch extends StatefulWidget {
  const AppointmentSearch({super.key});

  @override
  State<AppointmentSearch> createState() => _AppoinmentSearchState();
}

class _AppoinmentSearchState extends State<AppointmentSearch> {
  late Future<List<ClinicType>> _clinicsFuture;
  late Future<List<Hospital>> _hospitalsFuture;

  @override
  void initState() {
    super.initState();
    _clinicsFuture = ClinicService().getClinics();
  }

  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.red;
  String? _selectedClinic;
  String? _selectedHospital;

  Future<void> _searchAndNavigateToDoctors() async {
    if (_selectedClinic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.select_clinic)),
      );
      return;
    }
    final doctors = await HospitalService().fetchDoctorsByClinicAndHospital(
      _selectedClinic!,
      _selectedHospital,
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AppointmentDoctorList(
              doctors: doctors,
              hasFilter: _selectedHospital == null,
              clinicType: _selectedClinic!,
            ),
      ),
    );
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
                      SizedBox(height: 45.0),
                      Text(
                        AppLocalizations.of(context)!.book_appointment,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 7.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: MediaQuery.of(context).size.width - 70.0,
                            height: 75.0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: FutureBuilder<List<ClinicType>>(
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
                                      value: _selectedClinic,
                                      hint: Center(
                                        child: Text(
                                          "${AppLocalizations.of(context)!.clinic}*",
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
                                              value: clinic.type,
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
                                          _selectedClinic = newValue;
                                          _hospitalsFuture = HospitalService()
                                              .fetchHospitalsWithClinicType(
                                                _selectedClinic!,
                                              );
                                          _selectedHospital = null;
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
                          ),
                        ),
                      ),
                      if (_selectedClinic != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            elevation: 7.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              width: MediaQuery.of(context).size.width - 70.0,
                              height: 75.0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: FutureBuilder<List<Hospital>>(
                                    future: _hospitalsFuture,
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
                                            )!.info_no_available_hospital,
                                          ),
                                        );
                                      }

                                      final hospitals = snapshot.data!;
                                      return Stack(
                                        children: [
                                          DropdownButtonFormField<String>(
                                            value: _selectedHospital,
                                            hint: Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.hospital,
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
                                                hospitals.map((hospital) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: hospital.id,
                                                    child: Center(
                                                      child: Text(
                                                        hospital.name,
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
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedHospital = newValue;
                                              });
                                            },
                                            validator: (selectedHospital) {
                                              if (selectedHospital != null) {
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
                                          if (_selectedHospital != null)
                                            Positioned(
                                              right: 5.0,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: themeColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedHospital = null;
                                                  });
                                                },
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                onPressed: _searchAndNavigateToDoctors,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      AppLocalizations.of(context)!.search,
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
