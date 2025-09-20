import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/lab_report_with_hospital.dart';
import 'package:grad_project/services/patient_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LabReportList extends StatefulWidget {
  final int tckn;
  final Color theme;

  const LabReportList({required this.tckn, this.theme = Colors.red, super.key});

  @override
  State<LabReportList> createState() => _LabReportListState();
}

class _LabReportListState extends State<LabReportList> {
  List<LabReportWithHospital> _labReportsWithHospitals = [];
  bool isLoading = true;

  late Color themeColor;

  @override
  void initState() {
    themeColor = widget.theme;
    super.initState();
    fetchLabReports();
  }

  Future<void> openExcelFromBase64(String base64Str, String fileName) async {
    try {
      final bytes = base64Decode(base64Str);
      final tempDir = await getTemporaryDirectory();

      if (!mounted) return;

      final filePath = '${tempDir.path}/$fileName.xlsx';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final result = await OpenFile.open(filePath);

      if (!mounted) return;

      if (result.type == ResultType.noAppToOpen) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.info_no_application_for_excel,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_excel_launch_failed} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void fetchLabReports() async {
    final labReportWithHospital = await PatientService()
        .getLabReportsWithHospitals(widget.tckn);

    if (!mounted) return;

    setState(() {
      _labReportsWithHospitals = labReportWithHospital;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
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
                        _labReportsWithHospitals.isEmpty
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
                              itemCount: _labReportsWithHospitals.length,
                              itemBuilder: (context, index) {
                                final item = _labReportsWithHospitals[index];
                                final report = item.labReport;
                                final hospital = item.hospital;
                                final date = report.timestamp.toDate();

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
                                      openExcelFromBase64(
                                        report.fileBase64,
                                        'lab_report_${report.id}',
                                      );
                                    },
                                    title: Text(
                                      hospital!.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${date.day.toString().padLeft(2, '0')}."
                                      "${date.month.toString().padLeft(2, '0')}."
                                      "${date.year} - ${date.hour}.${date.minute.toString().padLeft(2, '0')}",
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
