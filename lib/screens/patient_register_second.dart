import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/screens/login_main.dart';
import 'package:grad_project/services/patient_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class PatientRegisterSecond extends StatefulWidget {
  final String tckn;
  final String email;
  final String password;

  const PatientRegisterSecond({
    required this.tckn,
    required this.email,
    required this.password,
    super.key,
  });

  @override
  State<PatientRegisterSecond> createState() => _PatientRegisterSecondState();
}

class _PatientRegisterSecondState extends State<PatientRegisterSecond> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.red;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  DateTime? selectedDate;
  String? _selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _register() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    FocusManager.instance.primaryFocus?.unfocus();

    if (!_formKey.currentState!.validate() || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validation_input_error),
        ),
      );
      return;
    }

    if (await tcknExists(widget.tckn) ||
        await emailExistsInDocuments(widget.email)) {
      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.validation_something_went_wrong,
          ),
        ),
      );
      return;
    }

    try {
      await PatientService().register(
        widget.tckn,
        widget.email,
        widget.password,
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
        _dobController.text,
        _heightController.text,
        _weightController.text,
        _selectedGender!,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.info_register_succesful,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.info_register_failed} $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
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
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 75.0),
                      Text(
                        AppLocalizations.of(context)!.register_second_title,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 7.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: MediaQuery.of(context).size.width - 70.0,
                          height: 450.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _firstNameController,
                                  hintText:
                                      AppLocalizations.of(context)!.first_name,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.name,
                                  maxLength: MAX_USERNAME_LENGTH,
                                  validator: (value) {
                                    if (nameValidatior(value)) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _lastNameController,
                                  hintText:
                                      AppLocalizations.of(context)!.last_name,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.name,
                                  maxLength: MAX_USERNAME_LENGTH,
                                  validator: (value) {
                                    if (nameValidatior(value)) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _phoneController,
                                  hintText: AppLocalizations.of(context)!.phone,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.number,
                                  maxLength: MAX_PHONE_NUMBER_LENGTH,
                                  validator: (value) {
                                    if (phoneValidator(value)) {
                                      return null;
                                    }

                                    return "";
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        right: 20,
                                        child: Icon(
                                          Icons.today_rounded,
                                          color: themeColor,
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _dobController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: SizedBox.shrink(),
                                          hintText:
                                              AppLocalizations.of(
                                                context,
                                              )!.birthday,
                                          hintStyle: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          errorStyle: TextStyle(fontSize: 0.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 14.0,
                                            horizontal: 42.0,
                                          ),
                                          counterText: "",
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16.0,
                                        ),
                                        maxLines: 1,
                                        onTap: () async {
                                          DateTime initialDate = DateTime.now()
                                              .subtract(
                                                const Duration(days: 365 * 18),
                                              );
                                          DateTime firstDate = DateTime(1900);
                                          DateTime lastDate = DateTime.now();

                                          final picked = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                selectedDate ?? initialDate,
                                            firstDate: firstDate,
                                            lastDate: lastDate,
                                            helpText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.select_date,
                                            fieldLabelText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.select_date,
                                            cancelText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.close,
                                            confirmText:
                                                AppLocalizations.of(
                                                  context,
                                                )!.select,
                                            builder: (
                                              BuildContext context,
                                              Widget? child,
                                            ) {
                                              return Theme(
                                                data: Theme.of(
                                                  context,
                                                ).copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                        primary: Colors.red,
                                                        onPrimary: Colors.white,
                                                        onSurface: Colors.black,
                                                      ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                        style:
                                                            TextButton.styleFrom(
                                                              foregroundColor:
                                                                  Colors.red,
                                                            ),
                                                      ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (picked != null) {
                                            setState(() {
                                              selectedDate = picked;
                                              _dobController.text =
                                                  "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "";
                                          }

                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomFormField(
                                        controller: _heightController,
                                        hintText:
                                            AppLocalizations.of(
                                              context,
                                            )!.height,
                                        boxColor: Colors.white,
                                        textColor: themeColor,
                                        textInputType: TextInputType.number,
                                        maxLength: 3,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              containsInvalidCharactersForPhone(
                                                value,
                                              )) {
                                            return "";
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomFormField(
                                        controller: _weightController,
                                        hintText:
                                            AppLocalizations.of(
                                              context,
                                            )!.weight,
                                        boxColor: Colors.white,
                                        textColor: themeColor,
                                        textInputType: TextInputType.number,
                                        maxLength: 3,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              containsInvalidCharactersForPhone(
                                                value,
                                              )) {
                                            return "";
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: Colors.white,
                                          value: "male",
                                          groupValue: _selectedGender,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          },
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.male,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Radio<String>(
                                          activeColor: Colors.white,
                                          value: "female",
                                          groupValue: _selectedGender,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          },
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.female,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                              onPressed: _register,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.how_to_reg, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.sign_up,
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
