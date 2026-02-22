import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

abstract class LocalDataSource {
  Future<void> init();
  Future<List<FoodItem>> getFoodItems();
  Future<List<Meal>> getAllMeals();
  Future<void> saveMeal(Meal meal);
  void dispose();
  Stream<void> get mealsUpdated;
}
