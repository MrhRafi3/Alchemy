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
    descriptionEn: 'Discover ten different elements.',
    descriptionBn: 'দশটি ভিন্ন উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 10,
    xpReward: 100,
  );

  static const masterAlchemist = AchievementModel(
    id: 'master_alchemist',
    titleEn: 'Master Alchemist',
    titleBn: 'মাস্টার আলকেমিস্ট',
    descriptionEn: 'Discover fifteen different elements.',
    descriptionBn: 'পনেরোটি ভিন্ন উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 15,
    xpReward: 150,
  );

  static const grandMagus = AchievementModel(
    id: 'grand_magus',
    titleEn: 'Grand Magus',
    titleBn: 'গ্র্যান্ড ম্যাগুস',
    descriptionEn: 'Master all twenty primordial elements.',
    descriptionBn: 'সকল বিশটি প্রাথমিক উপাদান আবিষ্কার করুন।',
    requiredDiscoveries: 20,
    xpReward: 250,
  );

  static const List<AchievementModel> all = [
    firstDiscovery,
    apprenticeAlchemist,
    elementHunter,
    intoTheUnknown,
    masterAlchemist,
    grandMagus,
  ];
}
