import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

abstract class LocalDataSource {
  Future<List<FoodItem>> getFoodItems();
  Future<List<Meal>> getAllMeals();
}
