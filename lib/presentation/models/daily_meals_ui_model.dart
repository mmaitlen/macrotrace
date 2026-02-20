import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/daily_meals.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class DailyMealsUIModel extends Equatable {
  final DailyMeals dailyMeals; // Reference to the domain entity
  final String formattedDate;
  final String formattedSummary;
  final Map<String, FoodItem>
  foodItemMap; // Keep foodItemMap here if needed for MealListItem

  const DailyMealsUIModel({
    required this.dailyMeals,
    required this.formattedDate,
    required this.formattedSummary,
    required this.foodItemMap,
  });

  // Convenience getters to access properties from the domain entity
  DateTime get date => dailyMeals.date;
  List<Meal> get meals => dailyMeals.meals;
  Map<String, double> get summary => dailyMeals.summary;

  @override
  List<Object?> get props => [
    dailyMeals,
    formattedDate,
    formattedSummary,
    foodItemMap,
  ];
}
