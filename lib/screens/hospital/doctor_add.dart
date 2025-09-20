import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/clinic.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class DoctorAdd extends StatefulWidget {
  const DoctorAdd({super.key});

  @override
  State<DoctorAdd> createState() => _DoctorAddState();
}

class _DoctorAddState extends State<DoctorAdd> {
  late Future<List<Clinic>> _clinicsFuture;
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.green;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedGender;
  String? _selectedClinicId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _clinicsFuture = HospitalService().fetchClinicsFromHospital(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void _addDoctor() async {
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

    if (_isLoading) {
      return;
    }

    try {
      _isLoading = true;

      await HospitalService().addDoctor(
        _nameController.text,
        _usernameController.text,
        _emailController.text,
        _selectedClinicId!,
        _passwordController.text,
        _selectedGender!,
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_register_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_register_failed} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                      SizedBox(height: 55.0),
                      Text(
                        AppLocalizations.of(context)!.add_doctor,
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
                          height: 450.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _nameController,
                                  hintText:
                                      AppLocalizations.of(context)!.full_name,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.name,
                                  maxLength: MAX_HOSPITAL_NAME_LENGTH,
                                  validator: (value) {
                                    if (nameValidatior(
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
                                  controller: _usernameController,
                                  hintText:
                                      AppLocalizations.of(context)!.username,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.text,
                                  maxLength: MAX_USERNAME_LENGTH,
                                  validator: (value) {
                                    if (usernameValidatior(
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
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Positioned(
                                        right: 12,
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: themeColor,
                                        ),
                                      ),
                                      FutureBuilder<List<Clinic>>(
                                        future: _clinicsFuture,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: themeColor,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                "${AppLocalizations.of(context)!.validation_something_went_wrong} ${snapshot.error}",
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.no_record_found,
                                              ),
                                            );
                                          }

                                          final clinics = snapshot.data!;
                                          return DropdownButtonFormField<
                                            String
                                          >(
                                            value: _selectedClinicId,
                                            hint: Center(
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.clinic,
                                                style: TextStyle(
                                                  color: themeColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            isExpanded: true,
                                            icon: SizedBox.shrink(),
                                            items:
                                                clinics.map((clinic) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: clinic.id,
                                                    child: Center(
                                                      child: Text(
                                                        clinic.type,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: themeColor,
                                                          fontSize: 16.0,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                            onChanged: (String? selectedId) {
                                              setState(() {
                                                _selectedClinicId = selectedId;
                                              });
                                            },
                                            validator: (selectedClinicId) {
                                              if (selectedClinicId != null) {
                                                return null;
                                              }
                                              return "";
                                            },
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                fontSize: 0.0,
                                              ),
                                              hintStyle: TextStyle(
                                                color: themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 14.0,
                                                    horizontal: 16.0,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
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
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: _addDoctor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.add_doctor,
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
