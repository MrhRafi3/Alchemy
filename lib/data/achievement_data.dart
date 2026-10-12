import '../models/achievement_model.dart';

class AchievementData {
  static const firstDiscovery = AchievementModel(
    id: 'first_discovery',
    titleEn: 'First Discovery',
    titleBn: 'প্রথম আবিষ্কার',
    descriptionEn: 'Discover your first new element.',
    descriptionBn: 'তোমার প্রথম নতুন উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 5,
    xpReward: 25,
  );

  static const apprenticeAlchemist = AchievementModel(
    id: 'apprentice_alchemist',
    titleEn: 'Apprentice Alchemist',
    titleBn: 'শিক্ষানবিশ আলকেমিস্ট',
    descriptionEn: 'Discover six different elements.',
    descriptionBn: 'ছয়টি ভিন্ন উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 6,
    xpReward: 50,
  );

  static const elementHunter = AchievementModel(
    id: 'element_hunter',
    titleEn: 'Element Hunter',
    titleBn: 'উপাদান শিকারি',
    descriptionEn: 'Discover eight different elements.',
    descriptionBn: 'আটটি ভিন্ন উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 8,
    xpReward: 75,
  );

  static const intoTheUnknown = AchievementModel(
    id: 'into_the_unknown',
    titleEn: 'Into the Unknown',
    titleBn: 'অজানার পথে',
    descriptionEn: 'Discover every currently available element.',
    descriptionBn: 'বর্তমানে থাকা সব উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 10,
    xpReward: 100,
  );

  static const List<AchievementModel> all = [
    firstDiscovery,
    apprenticeAlchemist,
    elementHunter,
    intoTheUnknown,
  ];
}