import 'package:flutter/material.dart';
import 'package:grad_project/l10n/app_localizations.dart';

String getLocalizedGender(BuildContext context, String gender) {
  final l10n = AppLocalizations.of(context)!;
  switch (gender) {
    case 'female':
      return l10n.female;
    case 'male':
      return l10n.male;
    default:
      return "";
  }
}

extension ClinicTypeLocalization on String {
  String localizeClinicType(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    const translations = {
      'FTR': {'en': 'PM&R', 'tr': 'FTR'},
      'Cildiye': {'en': 'Dermatology', 'tr': 'Cildiye'},
      'Göz': {'en': 'Ophthalmology', 'tr': 'Göz'},
      'Diş Hekimliği': {'en': 'Dentistiry', 'tr': 'Diş Hekimliği'},
      'Kardiyoloji': {'en': 'Cardiology', 'tr': 'Kardiyoloji'},
      'Radyoloji': {'en': 'Radiology', 'tr': 'Radyoloji'},
      'Üroloji': {'en': 'Urology', 'tr': 'Üroloji'},
      'Beyin Cerrahisi': {'en': 'Neurosurgery', 'tr': 'Beyin Cerrahisi'},
    };

    return translations[this]?[locale] ?? translations[this]?['en'] ?? this;
  }
}

extension DiseaseLocalization on String {
  String localizeDiseaseName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    const translations = {
      'Egzama': {'en': 'Eczema', 'tr': 'Egzama'},
      'Melanom': {'en': 'Melanoma', 'tr': 'Melanom'},
      'Atopik Dermatit': {'en': 'Atopic Dermatitis', 'tr': 'Atopik Dermatit'},
      'Bazal Hücreli Karsinom': {
        'en': 'Basal Cell Carcinoma',
        'tr': 'Bazal Hücreli Karsinom',
      },
      'Melanositik Nevus': {
        'en': 'Melanocytic Nevi',
        'tr': 'Melanositik Nevus',
      },
      'İyi Huylu Keratoz': {
        'en': 'Benign Keratosis',
        'tr': 'İyi Huylu Keratoz',
      },
      'Sedef Hastalığı': {'en': 'Psoriasis', 'tr': 'Sedef Hastalığı'},
      'Seboreik Keratoz': {
        'en': 'Seborrheic Keratoses',
        'tr': 'Seboreik Keratoz',
      },
      'Tinea / Mantar Enfeksiyonu - Kandidiyazis': {
        'en': 'Tinea / Ringworm - Candidiasis',
        'tr': 'Tinea / Mantar Enfeksiyonu - Kandidiyazis',
      },
      'Siğil - Molluskum Kontagiozum': {
        'en': 'Warts Molluscum',
        'tr': 'Siğil - Molluskum Kontagiozum',
      },
      'Diş Taşı': {'en': 'Calculus', 'tr': 'Diş Taşı'},
      'Diş Çürüğü': {'en': 'Dental Caries', 'tr': 'Diş Çürüğü'},
      'Diş Eti İltihabı': {'en': 'Gingivitis', 'tr': 'Diş Eti İltihabı'},
      'Aft / Ağız Yarası': {'en': 'Mouth Ulcer', 'tr': 'Aft / Ağız Yarası'},
      'Hipodonti': {'en': 'Hypodontia', 'tr': 'Hipodonti'},
      'Diş Renklenmesi': {'en': 'Tooth Discoloration', 'tr': 'Diş Renklenmesi'},
      'Akral Lentiginöz Melanom': {
        'en': 'Acral Lentiginous Melanoma',
        'tr': 'Akral Lentiginöz Melanom',
      },
      'Mavi Parmak': {'en': 'Blue Finger', 'tr': 'Mavi Parmak'},
      'Çomak Parmak': {'en': 'Clubbing', 'tr': 'Çomak Parmak'},
      'Sağlıklı Parmak': {'en': 'Healthy Nail', 'tr': 'Sağlıklı Parmak'},
      'Onikogrifozis': {'en': 'Onychogryphosis', 'tr': 'Onikogrifozis'},
      'Tırnak Çukurları': {'en': 'Pitting', 'tr': 'Tırnak Çukurları'},
    };

    return translations[this]?[locale] ?? translations[this]?['en'] ?? this;
  }
}
