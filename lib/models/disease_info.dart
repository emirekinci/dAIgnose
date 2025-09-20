class DiseaseInfo {
  final String id;
  final Map<String, String> names;
  final Map<String, String> descriptions;
  final String imagePath;
  final DiseaseCategory category;

  const DiseaseInfo({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.imagePath,
    required this.category,
  });

  String getLocalizedName(String locale) {
    return names[locale] ?? names.values.first;
  }

  String getLocalizedDescription(String locale) {
    return descriptions[locale] ?? descriptions.values.first;
  }
}

enum DiseaseCategory { skin, oral, nail }
