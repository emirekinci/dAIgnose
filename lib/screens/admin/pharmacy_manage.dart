import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grad_project/l10n/app_localizations.dart';
import 'package:grad_project/models/pharmacy.dart';
import 'package:grad_project/screens/admin/pharmacy_add.dart';
import 'package:grad_project/services/pharmacy_service.dart';
import 'package:grad_project/utils/constants.dart';
import 'package:grad_project/utils/districts.dart';
import 'package:grad_project/utils/validation_funcs.dart';
import 'package:grad_project/widgets/custom_form_field.dart';
import 'package:grad_project/widgets/delete_confirmation_dialog.dart';

class PharmacyManage extends StatefulWidget {
  const PharmacyManage({super.key});

  @override
  State<PharmacyManage> createState() => _PharmacyManageState();
}

class _PharmacyManageState extends State<PharmacyManage> {
  late Future<List<Pharmacy>> _pharmaciesFuture;

  @override
  void initState() {
    super.initState();
    _pharmaciesFuture = PharmacyService().getPharmacies();
  }

  final _formKey = GlobalKey<FormState>();
  final themeColor = Colors.blue;
  final themeColorAccent = Colors.blueAccent;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapsController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? selectedDistrict;
  Pharmacy? selectedPharmacy;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _mapsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updatePharmacy() async {
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

    if (!hasValueChanged()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.no_record_found)),
      );
      return;
    }

    try {
      final updatedPharmacy = Pharmacy(
        id: selectedPharmacy!.id,
        name: _nameController.text,
        address: _addressController.text,
        addressLink: _mapsController.text,
        phone: _phoneController.text,
        district: selectedDistrict!,
      );

      await PharmacyService().updatePharmacy(
        selectedPharmacy!.id,
        updatedPharmacy,
      );

      if (!mounted) return;

      setState(() {
        _pharmaciesFuture = PharmacyService().getPharmacies();
        selectedPharmacy = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_update_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_update_failed} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deletePharmacy() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (selectedPharmacy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.make_selection)),
      );

      return;
    }

    try {
      await PharmacyService().deletePharmacy(selectedPharmacy!.id);

      if (!mounted) return;

      setState(() {
        _pharmaciesFuture = PharmacyService().getPharmacies();
        selectedPharmacy = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.info_removal_succesful),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.info_removal_succesful} $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool hasValueChanged() {
    return _nameController.text != selectedPharmacy!.name ||
        _addressController.text != selectedPharmacy!.address ||
        _mapsController.text != selectedPharmacy!.addressLink ||
        _phoneController.text != selectedPharmacy!.phone ||
        selectedDistrict != selectedPharmacy!.district;
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
                      SizedBox(height: 60.0),
                      Text(
                        AppLocalizations.of(context)!.manage_pharmacy,
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 35.0),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 70.0,
                          child: FutureBuilder<List<Pharmacy>>(
                            future: _pharmaciesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: themeColor,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "${AppLocalizations.of(context)!.validation_something_went_wrong} ${snapshot.error}",
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 24,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: themeColor),
                                        borderRadius: BorderRadius.circular(20),
                                        color: themeColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.no_record_found,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        elevation: 7.0,
                                        color: themeColor,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width /
                                              3.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: themeColor,
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PharmacyAdd(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.login,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.add_pharmacy,
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
                                );
                              }

                              List<Pharmacy> pharmacyList = snapshot.data!;

                              return DropdownSearch<Pharmacy>(
                                items: pharmacyList,
                                selectedItem: selectedPharmacy,
                                itemAsString: (pharmacy) => pharmacy.name,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPharmacy = value!;
                                    _nameController.text = value.name;
                                    _addressController.text = value.address;
                                    _phoneController.text = value.phone;
                                    selectedDistrict = value.district;
                                  });
                                },
                                dropdownButtonProps: DropdownButtonProps(
                                  icon: SizedBox.shrink(),
                                ),
                                popupProps: PopupProps.menu(
                                  fit: FlexFit.loose,
                                  showSearchBox: true,
                                  searchDelay: Duration(milliseconds: 250),
                                  emptyBuilder: (context, searchEntry) {
                                    return SizedBox(
                                      height: 75,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.no_record_found,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  searchFieldProps: TextFieldProps(
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.name,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z0-9 ]'),
                                      ),
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText:
                                          AppLocalizations.of(context)!.search,
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      filled: true,
                                      fillColor: themeColorAccent,
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
                                  menuProps: MenuProps(
                                    elevation: 4,
                                    barrierColor: Colors.black.withAlpha(125),
                                    animationDuration: Duration(
                                      milliseconds: 500,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          color: themeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText:
                                        AppLocalizations.of(
                                          context,
                                        )!.select_pharmacy,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    fillColor: themeColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 14.0,
                                      horizontal: 42.0,
                                    ),
                                  ),
                                ),
                                dropdownBuilder:
                                    (context, selectedItem) => Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        selectedItem?.name ??
                                            AppLocalizations.of(
                                              context,
                                            )!.select_pharmacy,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                              );
                            },
                          ),
                        ),
                      ),

                      if (selectedPharmacy != null) ...[
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
                                        AppLocalizations.of(context)!.name,
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
                                            AppLocalizations.of(
                                              context,
                                            )!.address,
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
                                    hintText:
                                        AppLocalizations.of(context)!.phone,
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
                          padding: const EdgeInsets.all(8.0),
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
                                onPressed: _updatePharmacy,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      AppLocalizations.of(context)!.save,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                onPressed: () {
                                  showDeleteConfirmationDialog(
                                    context,
                                    _deletePharmacy,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete, color: Colors.white),
                                    SizedBox(width: 5.0),
                                    Text(
                                      AppLocalizations.of(context)!.delete,
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
