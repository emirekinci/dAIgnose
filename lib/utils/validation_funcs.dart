import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/utils/constants.dart';

final db = FirebaseFirestore.instance;

bool containsInvalidCharactersForName(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^a-zA-Z0-9 ]',
  ); // Allowed characters: Letters, numbers, space
  return forbiddenPattern.hasMatch(value);
}

bool containsInvalidCharactersForUsername(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^a-zA-Z0-9]',
  ); // Allowed characters: Letters, numbers
  return forbiddenPattern.hasMatch(value);
}

bool containsInvalidCharactersForAddress(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^a-zA-Z0-9 .,\-/:()]',
  ); // Allowed characters: Letters, numbers, space, . , - / : ( )
  return forbiddenPattern.hasMatch(value);
}

bool containsInvalidCharactersForPassword(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^a-zA-Z0-9!@#\$%^&*()_+\-=\[\]{};:\",.<>/?\\|`~]',
  ); // Allowed characters: Letters, numbers, and common symbols
  return forbiddenPattern.hasMatch(value);
}

bool containsInvalidCharactersForTCKN(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^0-9]',
  ); // Allowed characters: numbers
  return forbiddenPattern.hasMatch(value);
}

bool containsInvalidCharactersForPhone(String value) {
  final RegExp forbiddenPattern = RegExp(
    r'[^0-9]',
  ); // Allowed characters: numbers
  return forbiddenPattern.hasMatch(value);
}

bool isValidEmail(String value) {
  final RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ); // Checks if value has valid email format (example@gmail.com)
  return emailPattern.hasMatch(value);
}

final acceptedDomains = [
  'google.com/maps',
  'maps.google.com',
  'maps.app.goo.gl',
];

bool isAcceptedGoogleMapsUrl(String url) {
  return acceptedDomains.any((domain) => url.contains(domain));
}

bool nameValidatior(value) {
  if (value.isEmpty ||
      value.length > MAX_HOSPITAL_NAME_LENGTH ||
      containsInvalidCharactersForName(value)) {
    return false;
  }
  return true;
}

bool usernameValidatior(value) {
  if (value.isEmpty ||
      value.length > MAX_USERNAME_LENGTH ||
      value.length < 6 ||
      containsInvalidCharactersForUsername(value)) {
    return false;
  }
  return true;
}

bool emailValidatior(value) {
  if (value.isEmpty ||
      value.length > MAX_EMAIL_LENGTH ||
      value.length < 6 ||
      !isValidEmail(value)) {
    return false;
  }
  return true;
}

bool addressValidator(value) {
  if (value.isEmpty ||
      value.length > MAX_ADDRESS_LENGTH ||
      value.length < 12 ||
      containsInvalidCharactersForAddress(value)) {
    return false;
  }
  return true;
}

bool passwordValidator(value) {
  if (value.isEmpty ||
      value.length < 6 ||
      containsInvalidCharactersForPassword(value)) {
    return false;
  }
  return true;
}

bool tcknValidator(value) {
  if (value.isEmpty ||
      value.length != MAX_TCKN_LENGTH ||
      containsInvalidCharactersForTCKN(value)) {
    return false;
  }
  return true;
}

bool phoneValidator(value) {
  if (value.isEmpty ||
      value.length != MAX_PHONE_NUMBER_LENGTH ||
      containsInvalidCharactersForPhone(value)) {
    return false;
  }
  return true;
}

bool googleMapsLinkValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return true;
  }

  return isAcceptedGoogleMapsUrl(value.trim());
}

Future<bool> tcknExists(String tckn) async {
  try {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('patient')
            .where('tckn', isEqualTo: tckn)
            .limit(1)
            .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    return false;
  }
}

Future<bool> emailExistsInDocuments(String email) async {
  final collectionsToCheck = ['patient', 'hospital', 'admin', 'doctor'];

  try {
    for (final collection in collectionsToCheck) {
      final querySnapshot =
          await db
              .collection(collection)
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
    }

    return false;
  } catch (e) {
    return false;
  }
}
