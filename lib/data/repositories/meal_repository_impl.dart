import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  final LocalDataSource localDataSource;

  MealRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Meal>> getAllMeals() {
    return localDataSource.getAllMeals();
  }

  @override
  Future<List<FoodItem>> getFoodItems() {
    return localDataSource.getFoodItems();
  }

  @override
  Future<void> saveMeal(Meal meal) {
    return localDataSource.saveMeal(meal);
  }

  @override
  Stream<void> get mealsUpdated => localDataSource.mealsUpdated;

  @override
  Future<Meal> creaeMeal() {
    // TODO: implement creaeMeal
    throw UnimplementedError();
  }
}
