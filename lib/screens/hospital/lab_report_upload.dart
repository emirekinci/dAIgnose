import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class LabReportUpload extends StatefulWidget {
  const LabReportUpload({super.key});

  @override
  State<LabReportUpload> createState() => _LabReportUploadState();
}

class _LabReportUploadState extends State<LabReportUpload> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.green;
  final TextEditingController _tcknController = TextEditingController();
  File? selectedFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _tcknController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void pickFile() async {
    FocusScope.of(context).unfocus();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && mounted) {
      final fileBytes = result.files.single.size;
      const maxSizeInBytes = 0.256 * 1024 * 1024; // 0.25 MB

      if (fileBytes > maxSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.validation_exceeded_file_size,
            ),
          ),
        );
        return;
      }

      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitForm() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (!_formKey.currentState!.validate() || selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validation_input_error),
        ),
      );
      return;
    }

    if (!await tcknExists(_tcknController.text)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validation_invalid_tckn),
        ),
      );
      return;
    }

    if (_isLoading) {
      return;
    }

    try {
      _isLoading = true;

      await HospitalService().uploadLabReport(
        file: selectedFile!,
        tckn: _tcknController.text,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_upload_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_upload_failed} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
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
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 55.0),
                        Text(
                          AppLocalizations.of(context)!.upload_lab_report,
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
                            height: 75.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CustomFormField(
                                    controller: _tcknController,
                                    hintText:
                                        AppLocalizations.of(context)!.tckn,
                                    boxColor: Colors.white,
                                    textColor: themeColor,
                                    textInputType: TextInputType.number,
                                    maxLength: MAX_TCKN_LENGTH,
                                    validator: (value) {
                                      if (tcknValidator(value)) {
                                        return null;
                                      }

                                      return "";
                                    },
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
                              width: MediaQuery.of(context).size.width / 2.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: () => pickFile(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      selectedFile == null
                                          ? AppLocalizations.of(
                                            context,
                                          )!.upload_file
                                          : AppLocalizations.of(
                                            context,
                                          )!.upload_new_file,
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
                        selectedFile != null
                            ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                elevation: 7.0,
                                color: themeColor,
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      _submitForm();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5.0),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.upload_to_system,
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
                            )
                            : SizedBox(),
                      ],
                    ),
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
