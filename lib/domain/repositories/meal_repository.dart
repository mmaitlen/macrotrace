import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

abstract class MealRepository {
  Future<List<FoodItem>> getFoodItems();
  Future<List<Meal>> getAllMeals();
  Future<Meal> creaeMeal();
  Future<void> saveMeal(Meal meal);
  Stream<void> get mealsUpdated;
}
