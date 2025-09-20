import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/util.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<Doctor> _doctors = [];
  Map<String, String> doctorClinicTypes = {};
  bool isLoading = true;

  static const themeColor = Colors.green;

  @override
  void initState() {
    super.initState();
    fetchDoctorsAndRelatedData();
  }

  void fetchDoctorsAndRelatedData() async {
    final doctors = await HospitalService().fetchDoctorsByHospital(
      FirebaseAuth.instance.currentUser!.uid,
    );

    if (!mounted) return;

    final Map<String, String> clinicTypesMap = {};

    for (var doctor in doctors) {
      final clinicDoctorSnap =
          await FirebaseFirestore.instance
              .collection('clinic_doctor')
              .where('doctor_id', isEqualTo: doctor.id)
              .get();

      if (clinicDoctorSnap.docs.isNotEmpty) {
        final clinicId = clinicDoctorSnap.docs.first['clinic_id'];

        final clinicSnap =
            await FirebaseFirestore.instance
                .collection('clinic')
                .doc(clinicId)
                .get();

        if (clinicSnap.exists) {
          clinicTypesMap[doctor.id] = clinicSnap['type'];
        }
      }
    }

    if (!mounted) return;

    setState(() {
      _doctors = doctors;
      doctorClinicTypes = clinicTypesMap;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 65.0),
                  Expanded(
                    child:
                        _doctors.isEmpty
                            ? Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline, color: themeColor),
                                  SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.no_record_found,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _doctors.length,
                              itemBuilder: (context, index) {
                                final doctor = _doctors[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  color: themeColor,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      doctor.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    trailing: Text(
                                      doctorClinicTypes[doctor.id]
                                              ?.localizeClinicType(context) ??
                                          AppLocalizations.of(
                                            context,
                                          )!.no_clinic_assigned,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
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
