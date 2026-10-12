import '../models/element_model.dart';
import 'element_data.dart';


class RecipeData {
  static const Map<String, ElementModel> recipes = {
    'fire+water': ElementData.steam,
    'earth+fire': ElementData.lava,
    'air+fire': ElementData.energy,
    'earth+water': ElementData.plant,
    'air+water': ElementData.cloud,
    'air+earth': ElementData.dust,
  };

  static String _key(String first, String second) {
    final elements = [first, second]..sort();
    return '${elements[0]}+${elements[1]}';
  }

  static ElementModel? findResult(
      String first,
      String second,
      ) {
    return recipes[_key(first, second)];
  }
}