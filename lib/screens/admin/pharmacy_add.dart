import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/services/pharmacy_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/districts.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';

class PharmacyAdd extends StatefulWidget {
  const PharmacyAdd({super.key});

  @override
  State<PharmacyAdd> createState() => _PharmacyAddState();
}

class _PharmacyAddState extends State<PharmacyAdd> {
  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.blue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? selectedDistrict;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _mapsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addPharmacy() async {
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
      await PharmacyService().addPharmacy(
        _nameController.text,
        selectedDistrict,
        _addressController.text,
        _mapsController.text,
        _phoneController.text,
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
                      SizedBox(height: 75.0),
                      Text(
                        AppLocalizations.of(context)!.add_pharmacy,
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
                          height: 450.0,
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
                                  controller: _phoneController,
                                  hintText: AppLocalizations.of(context)!.phone,
                                  boxColor: Colors.white,
                                  textColor: themeColor,
                                  textInputType: TextInputType.number,
                                  maxLength: MAX_PHONE_NUMBER_LENGTH,
                                  validator: (value) {
                                    if (phoneValidator(
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
                            width: MediaQuery.of(context).size.width / 2.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: themeColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: _addPharmacy,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_pharmacy,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.add_pharmacy,
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
