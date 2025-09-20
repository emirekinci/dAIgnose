import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/services/hospital_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/districts.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class HospitalAdd extends StatefulWidget {
  const HospitalAdd({super.key});

  @override
  State<HospitalAdd> createState() => _HospitalAddState();
}

class _HospitalAddState extends State<HospitalAdd> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.blue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedDistrict;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _mapsController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _addHospital() async {
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

    try {
      await HospitalService().addHospital(
        _nameController.text,
        _usernameController.text,
        _emailController.text,
        selectedDistrict,
        _addressController.text,
        _mapsController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      Navigator.popUntil(context, (route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_add_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${AppLocalizations.of(context)!.info_add_failed} $e"),
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
                      SizedBox(height: 40.0),
                      Text(
                        AppLocalizations.of(context)!.add_hospital,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 7.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: MediaQuery.of(context).size.width - 70.0,
                          height: 600.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _nameController,
                                  hintText: AppLocalizations.of(context)!.name,
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
                                      DropdownButtonFormField<String>(
                                        value: selectedDistrict,
                                        hint: Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.district,
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
                                            districts.map((String district) {
                                              return DropdownMenuItem<String>(
                                                value: district,
                                                child: Center(
                                                  child: Text(
                                                    district,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: themeColor,
                                                      fontSize: 16.0,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedDistrict = newValue;
                                          });
                                        },
                                        validator: (selectedDistrict) {
                                          if (selectedDistrict != null) {
                                            return null;
                                          }

                                          return "";
                                        },
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 0.0),
                                          hintStyle: TextStyle(
                                            color: themeColor,
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
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: TextFormField(
                                    controller: _addressController,
                                    validator: (value) {
                                      if (addressValidator(
                                        value.toString().trim(),
                                      )) {
                                        return null;
                                      }

                                      return "";
                                    },
                                    maxLength: MAX_ADDRESS_LENGTH,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z0-9 .,-/:()]'),
                                      ),
                                    ],
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(fontSize: 0.0),
                                      hintText:
                                          AppLocalizations.of(context)!.address,
                                      hintStyle: TextStyle(
                                        color: themeColor,
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
                                      counterText: "",
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeColor,
                                      fontSize: 16.0,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CustomFormField(
                                  controller: _mapsController,
                                  hintText:
                                      "Google Maps (${AppLocalizations.of(context)!.optional})",
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.url,
                                  maxLength: MAX_MAPS_LINK_LENGTH,
                                  validator: (value) {
                                    if (googleMapsLinkValidator(
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
                              onPressed: _addHospital,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_business, color: Colors.white),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.add_hospital,
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
