import 'package:flutter/material.dart';

import '../models/element_model.dart';

class ElementData {
  // ============================================================
  // Starting Elements (The 4 Primal Elements)
  // ============================================================

  static const fire = ElementModel(
    id: 'fire',
    nameEn: 'Fire',
    nameBn: 'আগুন',
    icon: '🔥',
    iconData: Icons.local_fire_department_rounded,
    descriptionEn: 'A primal force of heat and transformation.',
    descriptionBn: 'তাপ ও রূপান্তরের এক প্রাথমিক শক্তি।',
    category: ElementCategory.energy,
    rarity: ElementRarity.common,
    color: Color(0xFFFF6B35),
  );

  static const water = ElementModel(
    id: 'water',
    nameEn: 'Water',
    nameBn: 'পানি',
    icon: '💧',
    iconData: Icons.water_drop_rounded,
    descriptionEn: 'The flowing essence of life and change.',
    descriptionBn: 'জীবন ও পরিবর্তনের প্রবাহমান উপাদান।',
    category: ElementCategory.nature,
    rarity: ElementRarity.common,
    color: Color(0xFF4DA6FF),
  );

  static const earth = ElementModel(
    id: 'earth',
    nameEn: 'Earth',
    nameBn: 'মাটি',
    icon: '🌍',
    iconData: Icons.public_rounded,
    descriptionEn: 'The solid foundation from which nature grows.',
    descriptionBn: 'প্রকৃতির বিকাশের কঠিন ভিত্তি।',
    category: ElementCategory.nature,
    rarity: ElementRarity.common,
    color: Color(0xFF9B8065),
  );

  static const air = ElementModel(
    id: 'air',
    nameEn: 'Air',
    nameBn: 'বায়ু',
    icon: '💨',
    iconData: Icons.air_rounded,
    descriptionEn: 'An invisible force that surrounds and moves everything.',
    descriptionBn: 'এক অদৃশ্য শক্তি যা সবকিছুকে ঘিরে রাখে ও চালিত করে।',
    category: ElementCategory.nature,
    rarity: ElementRarity.common,
    color: Color(0xFFB7B0FF),
  );

  // ============================================================
  // Discovered Elements
  // ============================================================

  static const steam = ElementModel(
    id: 'steam',
    nameEn: 'Steam',
    nameBn: 'বাষ্প',
    icon: '♨️',
    iconData: Icons.hot_tub_rounded,
    descriptionEn: 'Water transformed by intense heat.',
    descriptionBn: 'তীব্র তাপে রূপান্তরিত পানি।',
    category: ElementCategory.weather,
    rarity: ElementRarity.common,
    color: Color(0xFFD9E7FF),
  );

  static const lava = ElementModel(
    id: 'lava',
    nameEn: 'Lava',
    nameBn: 'লাভা',
    icon: '🌋',
    iconData: Icons.whatshot_rounded,
    descriptionEn: 'Molten earth awakened by fire.',
    descriptionBn: 'আগুনে জেগে ওঠা গলিত পৃথিবী।',
    category: ElementCategory.matter,
    rarity: ElementRarity.uncommon,
    color: Color(0xFFFF4D2E),
  );

  static const energy = ElementModel(
    id: 'energy',
    nameEn: 'Energy',
    nameBn: 'শক্তি',
    icon: '⚡',
    iconData: Icons.bolt_rounded,
    descriptionEn: 'A concentrated force created by elemental interaction.',
    descriptionBn: 'উপাদানের মিথস্ক্রিয়া থেকে সৃষ্ট ঘনীভূত শক্তি।',
    category: ElementCategory.energy,
    rarity: ElementRarity.uncommon,
    color: Color(0xFFFFD84D),
  );

  static const plant = ElementModel(
    id: 'plant',
    nameEn: 'Plant',
    nameBn: 'উদ্ভিদ',
    icon: '🌱',
    iconData: Icons.eco_rounded,
    descriptionEn: 'Life beginning to take root.',
    descriptionBn: 'শিকড় গাড়তে শুরু করা জীবন।',
    category: ElementCategory.life,
    rarity: ElementRarity.common,
    color: Color(0xFF65C466),
  );

  static const cloud = ElementModel(
    id: 'cloud',
    nameEn: 'Cloud',
    nameBn: 'মেঘ',
    icon: '☁️',
    iconData: Icons.cloud_rounded,
    descriptionEn: 'Water carried through the open air.',
    descriptionBn: 'বাতাসের মধ্যে ভেসে থাকা পানি।',
    category: ElementCategory.weather,
    rarity: ElementRarity.common,
    color: Color(0xFFB9C9E8),
  );

  static const dust = ElementModel(
    id: 'dust',
    nameEn: 'Dust',
    nameBn: 'ধুলো',
    icon: '🌫️',
    iconData: Icons.grain_rounded,
    descriptionEn: 'Tiny fragments of earth carried by air.',
    descriptionBn: 'বাতাসে ভেসে থাকা পৃথিবীর ক্ষুদ্র কণা।',
    category: ElementCategory.matter,
    rarity: ElementRarity.common,
    color: Color(0xFFB7A98A),
  );

  static const stone = ElementModel(
    id: 'stone',
    nameEn: 'Stone',
    nameBn: 'পাথর',
    icon: '🪨',
    iconData: Icons.landscape_rounded,
    descriptionEn: 'Solid rock formed when cooling molten rock meets air.',
    descriptionBn: 'গলিত লাভা বাতাসে শীতল হয়ে তৈরি হওয়া কঠিন শিলা।',
    category: ElementCategory.matter,
    rarity: ElementRarity.uncommon,
    color: Color(0xFF8E9AAF),
  );

  static const rain = ElementModel(
    id: 'rain',
    nameEn: 'Rain',
    nameBn: 'বৃষ্টি',
    icon: '🌧️',
    iconData: Icons.water_rounded,
    descriptionEn: 'Condensed cloud vapors descending back to the earth.',
    descriptionBn: 'মেঘের ঘনীভূত বাষ্প যা পৃথিবীতে ফিরে আসে।',
    category: ElementCategory.weather,
    rarity: ElementRarity.common,
    color: Color(0xFF5390D9),
  );

  static const lightning = ElementModel(
    id: 'lightning',
    nameEn: 'Lightning',
    nameBn: 'বজ্রপাত',
    icon: '🌩️',
    iconData: Icons.flash_on_rounded,
    descriptionEn: 'A sudden electric discharge tearing through stormy clouds.',
    descriptionBn: 'মেঘের মধ্য দিয়ে প্রবাহিত প্রচণ্ড বৈদ্যুতিক স্ফুলিঙ্গ।',
    category: ElementCategory.weather,
    rarity: ElementRarity.rare,
    color: Color(0xFFFFEA00),
  );

  static const sand = ElementModel(
    id: 'sand',
    nameEn: 'Sand',
    nameBn: 'বালু',
    icon: '🏖️',
    iconData: Icons.beach_access_rounded,
    descriptionEn: 'Ancient stone ground into fine golden granules by wind.',
    descriptionBn: 'বাতাসের ক্ষয়ে পাথরের তৈরি সূক্ষ্ম সোনালী কণা।',
    category: ElementCategory.nature,
    rarity: ElementRarity.uncommon,
    color: Color(0xFFE9C46A),
  );

  static const glass = ElementModel(
    id: 'glass',
    nameEn: 'Glass',
    nameBn: 'কাচ',
    icon: '🪟',
    iconData: Icons.auto_awesome_rounded,
    descriptionEn: 'Sand refined and vitrified into crystalline transparency.',
    descriptionBn: 'তীব্র তাপে বালু গলে তৈরি স্বচ্ছ কাঁচ।',
    category: ElementCategory.technology,
    rarity: ElementRarity.rare,
    color: Color(0xFF80ED99),
  );

  static const life = ElementModel(
    id: 'life',
    nameEn: 'Life',
    nameBn: 'জীবন',
    icon: '✨',
    iconData: Icons.favorite_rounded,
    descriptionEn: 'The spark of sentient vitality animating the elements.',
    descriptionBn: 'উপাদানগুলোতে প্রাণ সঞ্চারকারী চেতনার দীপ্তি।',
    category: ElementCategory.life,
    rarity: ElementRarity.rare,
    color: Color(0xFFFF70A6),
  );

  static const obsidian = ElementModel(
    id: 'obsidian',
    nameEn: 'Obsidian',
    nameBn: 'অবসিডিয়ান',
    icon: '🔮',
    iconData: Icons.diamond_rounded,
    descriptionEn: 'Volcanic glass forged in instantaneous aquatic cooling.',
    descriptionBn: 'পানিতে দ্রুত শীতল হওয়া লাভা থেকে গঠিত প্রাকৃতিক কাচ।',
    category: ElementCategory.mystical,
    rarity: ElementRarity.rare,
    color: Color(0xFF9D4EDD),
  );

  static const metal = ElementModel(
    id: 'metal',
    nameEn: 'Metal',
    nameBn: 'ধাতু',
    icon: '⚔️',
    iconData: Icons.shield_rounded,
    descriptionEn: 'Dense, durable mineral extracted through intense smelting.',
    descriptionBn: 'পাথর আগুনে গলিয়ে নিষ্কাশিত কঠিন ধাতু।',
    category: ElementCategory.matter,
    rarity: ElementRarity.rare,
    color: Color(0xFFB0C4DE),
  );

  static const storm = ElementModel(
    id: 'storm',
    nameEn: 'Storm',
    nameBn: 'ঝড়',
    icon: '🌪️',
    iconData: Icons.cyclone_rounded,
    descriptionEn: 'Violent atmospheric fury combining lightning and gale.',
    descriptionBn: 'বজ্রপাত ও উন্মত্ত বাতাসের বিধ্বংসী প্রাকৃতিক রূপ।',
    category: ElementCategory.weather,
    rarity: ElementRarity.epic,
    color: Color(0xFF7209B7),
  );

  static const volcano = ElementModel(
    id: 'volcano',
    nameEn: 'Volcano',
    nameBn: 'আগ্নেয়গিরি',
    icon: '🌋',
    iconData: Icons.terrain_rounded,
    descriptionEn:
        'A rupture in the crust where magma erupts with primal power.',
    descriptionBn: 'পৃথিবীর গভীরে লাভা উদ্গীরণকারী ভয়ঙ্কর পর্বত।',
    category: ElementCategory.nature,
    rarity: ElementRarity.epic,
    color: Color(0xFFFF5400),
  );

  // ============================================================
  // Collections
  // ============================================================

  static const startingElements = [fire, water, earth, air];

  static const allElements = [
    fire,
    water,
    earth,
    air,
    steam,
    lava,
    energy,
    plant,
    cloud,
    dust,
    stone,
    rain,
    lightning,
    sand,
    glass,
    life,
    obsidian,
    metal,
    storm,
    volcano,
  ];

  static final Map<String, ElementModel> _byId = {
    for (final element in allElements) element.id: element,
  };

  static ElementModel? findById(String id) => _byId[id];

  static int xpForRarity(ElementRarity rarity) {
    switch (rarity) {
      case ElementRarity.common:
        return 25;
      case ElementRarity.uncommon:
        return 50;
      case ElementRarity.rare:
        return 100;
      case ElementRarity.epic:
        return 200;
      case ElementRarity.legendary:
        return 500;
    }
  }
}
