import '../models/element_model.dart';
import 'element_data.dart';

class RecipeData {
  static const Map<String, ElementModel> recipes = {
    // Original recipes (preserved exactly)
    'fire+water': ElementData.steam,
    'earth+fire': ElementData.lava,
    'air+fire': ElementData.energy,
    'earth+water': ElementData.plant,
    'air+water': ElementData.cloud,
    'air+earth': ElementData.dust,

    // Expanded recipes
    'air+lava': ElementData.stone,
    'cloud+water': ElementData.rain,
    'air+stone': ElementData.sand,
    'fire+sand': ElementData.glass,
    'cloud+energy': ElementData.lightning,
    'energy+plant': ElementData.life,
    'lava+water': ElementData.obsidian,
    'fire+stone': ElementData.metal,
    'cloud+lightning': ElementData.storm,
    'earth+lava': ElementData.volcano,
  };

  static String _key(String first, String second) {
    final elements = [first, second]..sort();
    return '${elements[0]}+${elements[1]}';
  }

  static ElementModel? findResult(String first, String second) {
    return recipes[_key(first, second)];
  }

  /// Returns the pair of ingredient IDs used to forge the given element, if any.
  static List<String>? findIngredientsFor(String targetElementId) {
    for (final entry in recipes.entries) {
      if (entry.value.id == targetElementId) {
        return entry.key.split('+');
      }
    }
    return null;
  }

  /// Returns all recipes that can be formed using any of the available element IDs.
  static List<MapEntry<String, ElementModel>> getAvailableRecipes(
    Set<String> availableElementIds,
  ) {
    final available = <MapEntry<String, ElementModel>>[];
    for (final entry in recipes.entries) {
      final parts = entry.key.split('+');
      if (availableElementIds.contains(parts[0]) &&
          availableElementIds.contains(parts[1])) {
        available.add(entry);
      }
    }
    return available;
  }
}
