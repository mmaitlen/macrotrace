import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class GetDailySummary {
  Map<String, double> call({
    required List<Meal> mealsForDay,
    required List<FoodItem> allFoodItems,
  }) {
    final summary = <String, double>{
      'protein': 0.0,
      'carbohydrate': 0.0,
      'fat': 0.0,
    };

    if (allFoodItems.isEmpty) return summary;

    final foodItemMap = {for (var item in allFoodItems) item.id: item};

    for (final meal in mealsForDay) {
      for (final entry in meal.entries) {
        final foodItem = foodItemMap[entry.foodId];
        if (foodItem != null) {
          for (final macro in foodItem.macroTypes) {
            summary.update(
              macro,
              (value) => value + entry.points,
              ifAbsent: () => entry.points,
            );
          }
        }
      }
    }
    return summary;
  }
}
