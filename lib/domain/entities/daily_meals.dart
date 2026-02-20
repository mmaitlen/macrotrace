import 'package:macrotrace/domain/entities/meal.dart';

class DailyMeals {
  final DateTime date;
  final List<Meal> meals;
  final Map<String, double> summary;
  final String formattedDate;
  final double protienPointTotal;
  final double carbohydratePointTotal;
  final double fatPointTotal;

  DailyMeals({
    required this.date,
    required this.meals,
    required this.summary,
    required this.formattedDate,
    required this.protienPointTotal,
    required this.carbohydratePointTotal,
    required this.fatPointTotal,
  });
}
