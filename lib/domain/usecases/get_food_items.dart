import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';

class GetFoodItems {
  final MealRepository repository;

  GetFoodItems(this.repository);

  Future<List<FoodItem>> call() async {
    return repository.getFoodItems();
  }
}
