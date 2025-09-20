import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/doctor.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/screens/patient/appointment/appointment_booking.dart';
import 'package:grad_project/services/appointment_service.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/districts.dart';
import 'package:grad_project/widgets/doctor_card.dart';

class AppointmentDoctorList extends StatefulWidget {
  final List<Doctor> doctors;
  final bool hasFilter;
  final String clinicType;

  const AppointmentDoctorList({
    required this.doctors,
    required this.clinicType,
    this.hasFilter = false,
    super.key,
  });

  @override
  State<AppointmentDoctorList> createState() => _AppointmentDoctorListState();
}

class _AppointmentDoctorListState extends State<AppointmentDoctorList> {
  List<Hospital> hospitals = [];
  Map<String, Hospital> hospitalsMap = {};
  Map<String, int> availableDaysMap = {};
  bool isLoading = true;
  String? _selectedDistrict;

  static const themeColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
    _loadAvailableDays();
  }

  Future<void> _loadHospitals() async {
    final hospitalIds =
        widget.doctors.map((d) => d.hospitalId).toSet().toList();
    final result = await HospitalService().getHospitalsByIds(hospitalIds);

    if (!mounted) return;

    setState(() {
      hospitals = result;
      hospitalsMap = {for (var hospital in hospitals) hospital.id: hospital};
      isLoading = false;
    });
  }

  Future<void> _loadAvailableDays() async {
    final futures = widget.doctors.map(
      (doctor) =>
          AppointmentService().getAvailableDaysCount(doctor.id).then((count) {
            return MapEntry(doctor.id, count);
          }),
    );

    final results = await Future.wait(futures);

    if (!mounted) return;

    setState(() {
      availableDaysMap = Map.fromEntries(results);
      isLoading = false;
    });
  }

  String _getAvailableDaysText(int? availableDays) {
    if (availableDays == null) {
      return AppLocalizations.of(context)!.loading;
    } else if (availableDays == 0) {
      return AppLocalizations.of(context)!.not_available;
    } else {
      return "$availableDays ${AppLocalizations.of(context)!.days_available}";
    }
  }

  List<Doctor> getFilteredDoctors() {
    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      return widget.doctors;
    }

    final hospitalIdsInDistrict =
        hospitalsMap.values
            .where((hospital) => hospital.district == _selectedDistrict)
            .map((h) => h.id)
            .toSet();

    return widget.doctors
        .where((doctor) => hospitalIdsInDistrict.contains(doctor.hospitalId))
        .toList();
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
                  SizedBox(height: 45.0),
                  if (widget.hasFilter)
                    Material(
                      borderRadius: BorderRadius.circular(20.0),
                      elevation: 7.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 140.0,
                        height: 50.0,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              if (_selectedDistrict == null)
                                Positioned(
                                  right: 12,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ),
                              Stack(
                                children: [
                                  DropdownButtonFormField<String>(
                                    dropdownColor: Colors.red,
                                    value: _selectedDistrict,
                                    hint: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.district,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: SizedBox.shrink(),
                                    items:
                                        districts.map((String district) {
                                          return DropdownMenuItem<String>(
                                            value: district,
                                            child: Center(
                                              child: Text(
                                                district,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDistrict = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.0),
                                      hintStyle: TextStyle(
                                        color: Colors.white,
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
                                  ),
                                  if (_selectedDistrict != null)
                                    Positioned(
                                      right: 5.0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedDistrict = null;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child:
                        getFilteredDoctors().isEmpty
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
                              itemCount: getFilteredDoctors().length,
                              itemBuilder: (context, index) {
                                final doctor = getFilteredDoctors()[index];
                                final availableDays =
                                    availableDaysMap[doctor.id];

                                return DoctorCard(
                                  doctorName: doctor.name,
                                  hospitalName:
                                      hospitalsMap[doctor.hospitalId]?.name ??
                                      AppLocalizations.of(context)!.unknown,
                                  availableDaysText: _getAvailableDaysText(
                                    availableDays,
                                  ),
                                  isAvailable:
                                      availableDays != null &&
                                      availableDays > 0,
                                  onTap:
                                      (availableDays != null &&
                                              availableDays > 0)
                                          ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => AppointmentBooking(
                                                      doctor: doctor,
                                                      clinicType:
                                                          widget.clinicType,
                                                      hospital:
                                                          hospitalsMap[doctor
                                                              .hospitalId]!,
                                                    ),
                                              ),
                                            );
                                          }
                                          : null,
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
