import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';

class GetMealById {
  final MealRepository repository;

  GetMealById(this.repository);

  Future<Meal?> call(String id) async {
    final meals = await repository.getAllMeals();
    try {
      return meals.firstWhere((meal) => meal.id == id);
    } catch (e) {
      return null;
    }
  }
}
