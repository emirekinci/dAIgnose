import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/diagnose_result.dart';
import 'package:grad_project/providers/locale_providers.dart';
import 'package:grad_project/services/diagnose_service.dart';

class DiagnoseList extends ConsumerStatefulWidget {
  final String patientId;
  final Color theme;

  const DiagnoseList({
    required this.patientId,
    this.theme = Colors.red,
    super.key,
  });

  @override
  ConsumerState<DiagnoseList> createState() => _DiagnoseListState();
}

class _DiagnoseListState extends ConsumerState<DiagnoseList> {
  List<DiagnoseResult> _diagnoseResults = [];
  bool isLoading = true;

  late Color themeColor;
  late String patientName;

  @override
  void initState() {
    themeColor = widget.theme;
    super.initState();
    fetchDiagnoseResults();
  }

  String getCategoryDisplayName(String type) {
    switch (type) {
      case 'oral':
        return AppLocalizations.of(context)!.oral_diagnose;
      case 'nail':
        return AppLocalizations.of(context)!.nail_diagnose;
      default:
        return AppLocalizations.of(context)!.skin_diagnose;
    }
  }

  void _showImage(BuildContext context, String imageBase64) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Image.memory(base64Decode(imageBase64))],
          ),
        );
      },
    );
  }

  void fetchDiagnoseResults() async {
    final diagnoseResult = await DiagnoseService().getDiagnoseResults(
      widget.patientId,
    );

    if (!mounted) return;

    setState(() {
      _diagnoseResults = diagnoseResult;
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
    final localeCode = ref.watch(localeProvider).languageCode;

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
                        _diagnoseResults.isEmpty
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
                              itemCount: _diagnoseResults.length,
                              itemBuilder: (context, index) {
                                final report = _diagnoseResults[index];
                                final date = report.createdAt.toDate();

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
                                      _showImage(context, report.imageBase64);
                                    },
                                    title: Text(
                                      "${report.getLocalizedResult(localeCode)} - (%${report.confidence.toStringAsFixed(2)})",
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
                                    trailing: Text(
                                      getCategoryDisplayName(report.category),
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
