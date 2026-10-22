class AchievementModel {
  final String id;

  final String titleEn;
  final String titleBn;

  final String descriptionEn;
  final String descriptionBn;

  final int requiredDiscoveries;
  final int xpReward;

  const AchievementModel({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.requiredDiscoveries,
    required this.xpReward,
  });

  String getTitle(String languageCode) {
    return languageCode == 'bn' ? titleBn : titleEn;
  }

  String getDescription(String languageCode) {
    return languageCode == 'bn' ? descriptionBn : descriptionEn;
  }
}
