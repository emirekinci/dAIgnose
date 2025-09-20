import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yes_cancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get yes_cancel;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @hospitals.
  ///
  /// In en, this message translates to:
  /// **'Hospitals'**
  String get hospitals;

  /// No description provided for @pharmacies.
  ///
  /// In en, this message translates to:
  /// **'Pharmacies'**
  String get pharmacies;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @patient_register.
  ///
  /// In en, this message translates to:
  /// **'Patient Register'**
  String get patient_register;

  /// No description provided for @register_first_title.
  ///
  /// In en, this message translates to:
  /// **'Register (1/2)'**
  String get register_first_title;

  /// No description provided for @register_second_title.
  ///
  /// In en, this message translates to:
  /// **'Register (2/2)'**
  String get register_second_title;

  /// No description provided for @tckn.
  ///
  /// In en, this message translates to:
  /// **'Turkish ID Number'**
  String get tckn;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_repeat.
  ///
  /// In en, this message translates to:
  /// **'Password (Repeat)'**
  String get password_repeat;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birthday;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @clinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinic;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get not_available;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get next;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get sign_up;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get sign_in;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select a Date'**
  String get select_date;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @diagnose.
  ///
  /// In en, this message translates to:
  /// **'Diagnose'**
  String get diagnose;

  /// No description provided for @disease_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Disease Diagnose'**
  String get disease_diagnose;

  /// No description provided for @book_appointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get book_appointment;

  /// No description provided for @my_diagnose_results.
  ///
  /// In en, this message translates to:
  /// **'My Diagnose Results'**
  String get my_diagnose_results;

  /// No description provided for @my_lab_reports.
  ///
  /// In en, this message translates to:
  /// **'My Lab Reports'**
  String get my_lab_reports;

  /// No description provided for @my_appointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get my_appointments;

  /// No description provided for @select_hospital.
  ///
  /// In en, this message translates to:
  /// **'Select Hospital'**
  String get select_hospital;

  /// No description provided for @select_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Select Pharmacy'**
  String get select_pharmacy;

  /// No description provided for @add_hospital.
  ///
  /// In en, this message translates to:
  /// **'Add Hospital'**
  String get add_hospital;

  /// No description provided for @add_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Add Pharmacy'**
  String get add_pharmacy;

  /// No description provided for @add_doctor.
  ///
  /// In en, this message translates to:
  /// **'Add Doctor'**
  String get add_doctor;

  /// No description provided for @add_clinic.
  ///
  /// In en, this message translates to:
  /// **'Add Clinic'**
  String get add_clinic;

  /// No description provided for @match_clinic_doctor.
  ///
  /// In en, this message translates to:
  /// **'Match Clinic & Doctor'**
  String get match_clinic_doctor;

  /// No description provided for @remove_clinic.
  ///
  /// In en, this message translates to:
  /// **'Remove Clinic'**
  String get remove_clinic;

  /// No description provided for @remove_the_clinic.
  ///
  /// In en, this message translates to:
  /// **'Remove Clinic'**
  String get remove_the_clinic;

  /// No description provided for @manage_hospital.
  ///
  /// In en, this message translates to:
  /// **'Manage Hospital'**
  String get manage_hospital;

  /// No description provided for @manage_pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Manage Pharmacy'**
  String get manage_pharmacy;

  /// No description provided for @doctor_list.
  ///
  /// In en, this message translates to:
  /// **'Doctor List'**
  String get doctor_list;

  /// No description provided for @upcoming_appointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcoming_appointments;

  /// No description provided for @diagnose_results.
  ///
  /// In en, this message translates to:
  /// **'Diagnose Results'**
  String get diagnose_results;

  /// No description provided for @lab_reports.
  ///
  /// In en, this message translates to:
  /// **'Lab Reports'**
  String get lab_reports;

  /// No description provided for @disease_details.
  ///
  /// In en, this message translates to:
  /// **'Disease Details'**
  String get disease_details;

  /// No description provided for @list_diagnose_results.
  ///
  /// In en, this message translates to:
  /// **'List Diagnose Results'**
  String get list_diagnose_results;

  /// No description provided for @list_lab_reports.
  ///
  /// In en, this message translates to:
  /// **'List Lab Reports'**
  String get list_lab_reports;

  /// No description provided for @upload_lab_report.
  ///
  /// In en, this message translates to:
  /// **'Upload Lab Report'**
  String get upload_lab_report;

  /// No description provided for @cancel_the_appointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel the Appointment'**
  String get cancel_the_appointment;

  /// No description provided for @cancel_the_appointment_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancel_the_appointment_text;

  /// No description provided for @upload_file.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get upload_file;

  /// No description provided for @upload_new_file.
  ///
  /// In en, this message translates to:
  /// **'Upload New File'**
  String get upload_new_file;

  /// No description provided for @pick_image.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pick_image;

  /// No description provided for @pick_new_image.
  ///
  /// In en, this message translates to:
  /// **'Pick New Image'**
  String get pick_new_image;

  /// No description provided for @upload_to_system.
  ///
  /// In en, this message translates to:
  /// **'Upload to the System'**
  String get upload_to_system;

  /// No description provided for @days_available.
  ///
  /// In en, this message translates to:
  /// **'days available'**
  String get days_available;

  /// No description provided for @current_appointment.
  ///
  /// In en, this message translates to:
  /// **'Current Appointment'**
  String get current_appointment;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get delete_confirmation;

  /// No description provided for @appointment_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmation'**
  String get appointment_confirmation;

  /// No description provided for @delete_confirmation_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this record?'**
  String get delete_confirmation_text;

  /// No description provided for @appointment_confirmation_text.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm appointment:'**
  String get appointment_confirmation_text;

  /// No description provided for @already_have_appointment_text.
  ///
  /// In en, this message translates to:
  /// **'You already have an appointment with this clinic type. Do you want to cancel other appointment to proceed with new one?'**
  String get already_have_appointment_text;

  /// No description provided for @validation_input_error.
  ///
  /// In en, this message translates to:
  /// **'Please check the fields you entered.'**
  String get validation_input_error;

  /// No description provided for @validation_tckn_already_registered.
  ///
  /// In en, this message translates to:
  /// **'This T.C. identity number is already registered.'**
  String get validation_tckn_already_registered;

  /// No description provided for @validation_email_already_registered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get validation_email_already_registered;

  /// No description provided for @validation_password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Entered passwords do not match.'**
  String get validation_password_mismatch;

  /// No description provided for @validation_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again.'**
  String get validation_something_went_wrong;

  /// No description provided for @validation_no_change_made.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t changed anything.'**
  String get validation_no_change_made;

  /// No description provided for @validation_no_permission_for_patient.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to view this patient.'**
  String get validation_no_permission_for_patient;

  /// No description provided for @validation_invalid_tckn.
  ///
  /// In en, this message translates to:
  /// **'TCKN not found.'**
  String get validation_invalid_tckn;

  /// No description provided for @validation_exceeded_file_size.
  ///
  /// In en, this message translates to:
  /// **'Uploaded file cannot exceed 256 KBs'**
  String get validation_exceeded_file_size;

  /// No description provided for @validation_clinic_already_added.
  ///
  /// In en, this message translates to:
  /// **'This clinic was already added.'**
  String get validation_clinic_already_added;

  /// No description provided for @info_appointment_updated.
  ///
  /// In en, this message translates to:
  /// **'Appointment has been updated.'**
  String get info_appointment_updated;

  /// No description provided for @info_appointment_booked.
  ///
  /// In en, this message translates to:
  /// **'Appointment has been booked.'**
  String get info_appointment_booked;

  /// No description provided for @info_register_succesful.
  ///
  /// In en, this message translates to:
  /// **'Register succesful.'**
  String get info_register_succesful;

  /// No description provided for @info_register_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while registering:'**
  String get info_register_failed;

  /// No description provided for @info_add_succesful.
  ///
  /// In en, this message translates to:
  /// **'Added succesfully.'**
  String get info_add_succesful;

  /// No description provided for @info_add_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while adding:'**
  String get info_add_failed;

  /// No description provided for @info_update_succesful.
  ///
  /// In en, this message translates to:
  /// **'Update succesful.'**
  String get info_update_succesful;

  /// No description provided for @info_update_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while updating:'**
  String get info_update_failed;

  /// No description provided for @info_removal_succesful.
  ///
  /// In en, this message translates to:
  /// **'Removal succesful.'**
  String get info_removal_succesful;

  /// No description provided for @info_removal_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while removing:'**
  String get info_removal_failed;

  /// No description provided for @info_upload_succesful.
  ///
  /// In en, this message translates to:
  /// **'Upload succesful.'**
  String get info_upload_succesful;

  /// No description provided for @info_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while uploading:'**
  String get info_upload_failed;

  /// No description provided for @info_appointment_cancel_succesful.
  ///
  /// In en, this message translates to:
  /// **'Appointment has been canceled.'**
  String get info_appointment_cancel_succesful;

  /// No description provided for @info_appointment_cancel_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while canceling appointment:'**
  String get info_appointment_cancel_failed;

  /// No description provided for @info_doctor_match_succesful.
  ///
  /// In en, this message translates to:
  /// **'Doctor matched to the clinic succesfully.'**
  String get info_doctor_match_succesful;

  /// No description provided for @info_doctor_match_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while matching the doctor:'**
  String get info_doctor_match_failed;

  /// No description provided for @info_no_available_doctor.
  ///
  /// In en, this message translates to:
  /// **'No available doctor found.'**
  String get info_no_available_doctor;

  /// No description provided for @info_no_available_hospital.
  ///
  /// In en, this message translates to:
  /// **'No available hospital found'**
  String get info_no_available_hospital;

  /// No description provided for @info_map_did_not_launch.
  ///
  /// In en, this message translates to:
  /// **'Map couldn\'t launched:'**
  String get info_map_did_not_launch;

  /// No description provided for @info_diagnose_save_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem while saving diagnose:'**
  String get info_diagnose_save_failed;

  /// No description provided for @info_no_application_for_excel.
  ///
  /// In en, this message translates to:
  /// **'No application found to open excel file.'**
  String get info_no_application_for_excel;

  /// No description provided for @info_excel_launch_failed.
  ///
  /// In en, this message translates to:
  /// **'There was a problem opening excel file:'**
  String get info_excel_launch_failed;

  /// No description provided for @no_network_connection.
  ///
  /// In en, this message translates to:
  /// **'No connection. Please reconnect and try again.'**
  String get no_network_connection;

  /// No description provided for @incorrect_username_or_password.
  ///
  /// In en, this message translates to:
  /// **'The username or password you entered is incorrect.'**
  String get incorrect_username_or_password;

  /// No description provided for @no_record_found.
  ///
  /// In en, this message translates to:
  /// **'No Record Found.'**
  String get no_record_found;

  /// No description provided for @no_map_link_found.
  ///
  /// In en, this message translates to:
  /// **'No Maps Link Found.'**
  String get no_map_link_found;

  /// No description provided for @no_appointment_found.
  ///
  /// In en, this message translates to:
  /// **'No Appointment Found'**
  String get no_appointment_found;

  /// No description provided for @no_clinic_assigned.
  ///
  /// In en, this message translates to:
  /// **'No Clinic Assigned'**
  String get no_clinic_assigned;

  /// No description provided for @make_selection.
  ///
  /// In en, this message translates to:
  /// **'Please make a selection.'**
  String get make_selection;

  /// No description provided for @select_clinic.
  ///
  /// In en, this message translates to:
  /// **'Please select a clinic.'**
  String get select_clinic;

  /// No description provided for @oral_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Oral Diagnose'**
  String get oral_diagnose;

  /// No description provided for @nail_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Nail Diagnose'**
  String get nail_diagnose;

  /// No description provided for @skin_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Skin Diagnose'**
  String get skin_diagnose;

  /// No description provided for @oral_disease.
  ///
  /// In en, this message translates to:
  /// **'Oral Disease'**
  String get oral_disease;

  /// No description provided for @nail_disease.
  ///
  /// In en, this message translates to:
  /// **'Nail Disease'**
  String get nail_disease;

  /// No description provided for @skin_disease.
  ///
  /// In en, this message translates to:
  /// **'Skin Disease'**
  String get skin_disease;

  /// No description provided for @oral_disease_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Oral Disease Diagnose'**
  String get oral_disease_diagnose;

  /// No description provided for @nail_disease_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Nail Disease Diagnose'**
  String get nail_disease_diagnose;

  /// No description provided for @skin_disease_diagnose.
  ///
  /// In en, this message translates to:
  /// **'Skin Disease Diagnose'**
  String get skin_disease_diagnose;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @clinic_pmr.
  ///
  /// In en, this message translates to:
  /// **'PM&R'**
  String get clinic_pmr;

  /// No description provided for @clinic_dermatology.
  ///
  /// In en, this message translates to:
  /// **'Dermatology'**
  String get clinic_dermatology;

  /// No description provided for @clinic_ophthalmology.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmology'**
  String get clinic_ophthalmology;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
