import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';

class GetAllMeals {
  final MealRepository repository;

  GetAllMeals(this.repository);

  Future<List<Meal>> call() async {
    final meals = await repository.getAllMeals();
    meals.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort descending
    return meals;
  }
}
