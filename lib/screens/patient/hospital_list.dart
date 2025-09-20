import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/hospital.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/districts.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalList extends StatefulWidget {
  const HospitalList({super.key});

  @override
  State<HospitalList> createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  List<Hospital> hospitals = [];
  List<Hospital> filteredHospitals = [];
  bool isLoading = true;
  String? _selectedDistrict;

  static const themeColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (!mounted) return;

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;

      throw "${AppLocalizations.of(context)!.info_map_did_not_launch} $url";
    }
  }

  Future<void> _loadHospitals() async {
    final result = await HospitalService().getHospitals();

    if (!mounted) return;

    setState(() {
      hospitals = result;
      filteredHospitals = getFilteredHospitals();
      isLoading = false;
    });
  }

  List<Hospital> getFilteredHospitals() {
    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      return hospitals;
    }

    return hospitals
        .where((hospital) => hospital.district == _selectedDistrict)
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
                                      filteredHospitals =
                                          getFilteredHospitals();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 0.0),
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
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
                                          filteredHospitals =
                                              getFilteredHospitals();
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
                        filteredHospitals.isEmpty
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
                              itemCount: filteredHospitals.length,
                              itemBuilder: (context, index) {
                                final hospital = filteredHospitals[index];

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
                                    onTap: () {
                                      if (hospital.addressLink != null) {
                                        if (hospital.addressLink!.isNotEmpty) {
                                          _openMap(hospital.addressLink!);
                                          return;
                                        }
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).hideCurrentSnackBar();

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.no_map_link_found,
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                      hospital.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      hospital.address,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: Text(
                                      hospital.district,
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
