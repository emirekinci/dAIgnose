import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/screens/patient/lab_report_list.dart';
import 'package:grad_project/services/appointment_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class LabReportQuery extends StatefulWidget {
  const LabReportQuery({super.key});

  @override
  State<LabReportQuery> createState() => _LabReportQueryState();
}

class _LabReportQueryState extends State<LabReportQuery> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.orange;
  final TextEditingController _tcknController = TextEditingController();
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

  void _submitForm() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate()) {
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

    if (!await AppointmentService().hasAppointmentWithPatient(
      _tcknController.text,
      FirebaseAuth.instance.currentUser!.uid,
    )) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validation_no_permission_for_patient,
          ),
        ),
      );
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LabReportList(
              tckn: int.parse(_tcknController.text),
              theme: Colors.orange,
            ),
      ),
    );

    _isLoading = false;
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
                        SizedBox(height: 75.0),
                        Text(
                          AppLocalizations.of(context)!.lab_reports,
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
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextButton(
                                onPressed: _submitForm,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.assignment, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.list_lab_reports,
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
