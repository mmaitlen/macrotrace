import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';

class SaveMeal {
  final MealRepository repository;

  SaveMeal(this.repository);

  Future<void> call(Meal meal) {
    return repository.saveMeal(meal);
  }
}
