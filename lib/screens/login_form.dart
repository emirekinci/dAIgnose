import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/services/auth_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class LoginForm extends StatefulWidget {
  final String userType;

  const LoginForm({required this.userType, super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? type;
  String loginHintText = "";
  Color themeColor = Colors.red;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) return;

    _isInitialized = true;

    if (widget.userType == "doctor") {
      type = AppLocalizations.of(context)!.doctor;
      loginHintText = AppLocalizations.of(context)!.username;
      themeColor = Colors.orange;
      return;
    }

    if (widget.userType == "patient") {
      type = AppLocalizations.of(context)!.patient;
      loginHintText = AppLocalizations.of(context)!.tckn;
      themeColor = Colors.red;
      return;
    }

    if (widget.userType == "hospital") {
      type = AppLocalizations.of(context)!.hospital;
      loginHintText = AppLocalizations.of(context)!.username;
      themeColor = Colors.green;
      return;
    }

    if (widget.userType == "admin") {
      type = AppLocalizations.of(context)!.admin;
      loginHintText = AppLocalizations.of(context)!.username;
      themeColor = Colors.blue;
      return;
    }
  }

  void _login() async {
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
    await AuthService().signIn(
      _usernameController.text,
      _passwordController.text,
      widget.userType,
      context,
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
                      SizedBox(height: 150.0),
                      Text(
                        "$type ${AppLocalizations.of(context)!.login}",
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
                                child: CustomFormField(
                                  controller: _usernameController,
                                  hintText: loginHintText,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType:
                                      widget.userType == "patient"
                                          ? TextInputType.number
                                          : TextInputType.text,
                                  maxLength:
                                      widget.userType == "patient"
                                          ? MAX_TCKN_LENGTH
                                          : MAX_USERNAME_LENGTH,
                                  validator: (value) {
                                    if (widget.userType == "patient") {
                                      if (tcknValidator(value)) {
                                        return null;
                                      }
                                    } else {
                                      if (usernameValidatior(value)) {
                                        return null;
                                      }
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
                                    if (passwordValidator(value)) {
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
                              onPressed: _login,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.sign_in,
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
