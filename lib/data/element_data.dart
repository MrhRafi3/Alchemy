import 'package:flutter/material.dart';

import '../models/element_model.dart';

class ElementData {
  static const fire = ElementModel(
    id: 'fire',
    nameEn: 'Fire',
    nameBn: 'আগুন',
    icon: '🔥',
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
    descriptionEn: 'An invisible force that surrounds and moves everything.',
    descriptionBn: 'এক অদৃশ্য শক্তি যা সবকিছুকে ঘিরে রাখে ও চালিত করে।',
    category: ElementCategory.nature,
    rarity: ElementRarity.common,
    color: Color(0xFFB7B0FF),
  );

  static const steam = ElementModel(
    id: 'steam',
    nameEn: 'Steam',
    nameBn: 'বাষ্প',
    icon: '♨️',
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
    descriptionEn: 'Tiny fragments of earth carried by air.',
    descriptionBn: 'বাতাসে ভেসে থাকা পৃথিবীর ক্ষুদ্র কণা।',
    category: ElementCategory.matter,
    rarity: ElementRarity.common,
    color: Color(0xFFB7A98A),
  );

  static const startingElements = [
    fire,
    water,
    earth,
    air,
  ];

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