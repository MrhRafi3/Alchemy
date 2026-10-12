import 'package:flutter/material.dart';

enum ElementCategory {
  nature,
  matter,
  weather,
  energy,
  life,
  technology,
  civilization,
  cosmic,
  mystical,
}

enum ElementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

class ElementModel {
  final String id;

  final String nameEn;
  final String nameBn;

  final String icon;

  final String descriptionEn;
  final String descriptionBn;

  final ElementCategory category;
  final ElementRarity rarity;

  final Color color;

  const ElementModel({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.icon,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.category,
    required this.rarity,
    required this.color,
  });

  String getName(String languageCode) {
    return languageCode == 'bn' ? nameBn : nameEn;
  }

  String getDescription(String languageCode) {
    return languageCode == 'bn'
        ? descriptionBn
        : descriptionEn;
  }
}