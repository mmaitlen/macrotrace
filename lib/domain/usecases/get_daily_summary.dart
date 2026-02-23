import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/macro_type.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class GetDailySummary {
  Map<MacroType, double> call({
    required List<Meal> mealsForDay,
    required List<FoodItem> allFoodItems,
  }) {
    final summary = <MacroType, double>{
      MacroType.protein: 0.0,
      MacroType.carbohydrate: 0.0,
      MacroType.fat: 0.0,
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
