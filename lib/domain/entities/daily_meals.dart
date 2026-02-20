import 'package:macrotrace/domain/entities/meal.dart';

class DailyMeals {
  final DateTime date;
  final List<Meal> meals;
  final Map<String, double> summary;

  DailyMeals({
    required this.date,
    required this.meals,
    required this.summary,
  });
}
