import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/screens/patient_register_second.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class PatientRegisterFirst extends StatefulWidget {
  const PatientRegisterFirst({super.key});

  @override
  State<PatientRegisterFirst> createState() => _PatientRegisterFirstState();
}

class _PatientRegisterFirstState extends State<PatientRegisterFirst> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.red;
  final TextEditingController _tcknController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedPassController = TextEditingController();

  @override
  void dispose() {
    _tcknController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatedPassController.dispose();
    super.dispose();
  }

  void _navigateNextRegisterPage() async {
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

    if (await tcknExists(_tcknController.text)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validation_tckn_already_registered,
          ),
        ),
      );
      return;
    }

    if (await emailExistsInDocuments(_emailController.text)) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validation_email_already_registered,
          ),
        ),
      );
      return;
    }

    if (!mounted) return;

    if (_passwordController.text != _repeatedPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validation_password_mismatch,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PatientRegisterSecond(
              tckn: _tcknController.text,
              email: _emailController.text,
              password: _passwordController.text,
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
                      SizedBox(height: 75.0),
                      Text(
                        AppLocalizations.of(context)!.register_first_title,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 60.0),
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 7.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: MediaQuery.of(context).size.width - 70.0,
                          height: 320.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _tcknController,
                                  hintText: AppLocalizations.of(context)!.tckn,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.number,
                                  maxLength: MAX_TCKN_LENGTH,
                                  validator: (value) {
                                    if (tcknValidator(
                                      value.toString().trim(),
                                    )) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _emailController,
                                  hintText: AppLocalizations.of(context)!.email,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.emailAddress,
                                  maxLength: MAX_EMAIL_LENGTH,
                                  validator: (value) {
                                    if (emailValidatior(
                                      value.toString().trim(),
                                    )) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _passwordController,
                                  hintText:
                                      AppLocalizations.of(context)!.password,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.visiblePassword,
                                  maxLength: MAX_PASSWORD_LENGTH,
                                  validator: (value) {
                                    if (passwordValidator(
                                      value.toString().trim(),
                                    )) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _repeatedPassController,
                                  hintText:
                                      AppLocalizations.of(
                                        context,
                                      )!.password_repeat,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.visiblePassword,
                                  maxLength: MAX_PASSWORD_LENGTH,
                                  validator: (value) {
                                    if (passwordValidator(
                                      value.toString().trim(),
                                    )) {
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
                            width: MediaQuery.of(context).size.width / 3.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: _navigateNextRegisterPage,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.next,
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
