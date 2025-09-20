import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnoseResult {
  final String id;
  final String patientId;
  final String imageBase64;
  final String imageHash;
  final String result;
  final double confidence;
  final String category;
  final Timestamp createdAt;

  DiagnoseResult({
    required this.id,
    required this.patientId,
    required this.imageBase64,
    required this.imageHash,
    required this.result,
    required this.confidence,
    required this.category,
    required this.createdAt,
  });

  factory DiagnoseResult.fromJson(Map<String, dynamic> json, String id) {
    return DiagnoseResult(
      id: id,
      patientId: json['patient_id'] ?? '',
      imageBase64: json['image_base64'] ?? '',
      imageHash: json['image_hash'] ?? '',
      result: json['result'] ?? '',
      confidence:
          (json['confidence'] is int)
              ? (json['confidence'] as int).toDouble()
              : (json['confidence'] as double? ?? 0.0),
      category: json['type'] ?? '',
      createdAt: json['created_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'image_base64': imageBase64,
      'image_hash': imageHash,
      'result': result,
      'confidence': confidence,
      'type': category,
      'created_at': createdAt,
    };
  }

  String getLocalizedResult(String localeCode) {
    final names = {
      'Egzama': {'tr': 'Egzama', 'en': 'Eczema'},
      'Melanom': {'tr': 'Melanom', 'en': 'Melanoma'},
      'Atopik Dermatit': {'tr': 'Atopik Dermatit', 'en': 'Atopic Dermatitis'},
      'Bazal Hücreli Karsinom': {
        'tr': 'Bazal Hücreli Karsinom',
        'en': 'Basal Cell Carcinoma',
      },
      'Melanositik Nevus': {
        'tr': 'Melanositik Nevus',
        'en': 'Melanocytic Nevi',
      },
      'İyi Huylu Keratoz': {
        'tr': 'İyi Huylu Keratoz',
        'en': 'Benign Keratosis',
      },
      'Sedef Hastalığı': {'tr': 'Sedef Hastalığı', 'en': 'Psoriasis'},
      'Seboreik Keratoz': {
        'tr': 'Seboreik Keratoz',
        'en': 'Seborrheic Keratoses',
      },
      'Tinea / Mantar Enfeksiyonu - Kandidiyazis': {
        'tr': 'Tinea / Mantar Enfeksiyonu - Kandidiyazis',
        'en': 'Tinea / Ringworm - Candidiasis',
      },
      'Siğil - Molluskum Kontagiozum': {
        'tr': 'Siğil - Molluskum Kontagiozum',
        'en': 'Warts Molluscum',
      },
      'Diş Taşı': {'tr': 'Diş Taşı', 'en': 'Calculus'},
      'Diş Çürüğü': {'tr': 'Diş Çürüğü', 'en': 'Dental Caries'},
      'Diş Eti İltihabı': {'tr': 'Diş Eti İltihabı', 'en': 'Gingivitis'},
      'Aft / Ağız Yarası': {'tr': 'Aft / Ağız Yarası', 'en': 'Mouth Ulcer'},
      'Hipodonti': {'tr': 'Hipodonti', 'en': 'Hypodontia'},
      'Diş Renklenmesi': {'tr': 'Diş Renklenmesi', 'en': 'Tooth Discoloration'},
      'Akral Lentiginöz Melanom': {
        'tr': 'Akral Lentiginöz Melanom',
        'en': 'Acral Lentiginous Melanoma',
      },
      'Mavi Parmak': {'tr': 'Mavi Parmak', 'en': 'Blue Finger'},
      'Çomak Parmak': {'tr': 'Çomak Parmak', 'en': 'Clubbing'},
      'Sağlıklı Parmak': {'tr': 'Sağlıklı Parmak', 'en': 'Healthy Nail'},
      'Onikogrifozis': {'tr': 'Onikogrifozis', 'en': 'Onychogryphosis'},
      'Tırnak Çukurları': {'tr': 'Tırnak Çukurları', 'en': 'Pitting'},
    };

    return names[result]?[localeCode] ?? names[result]?['en'] ?? result;
  }
}
