import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class DailyMeals extends Equatable {
  final DateTime date;
  final List<Meal> meals;
  final Map<String, double> summary;

  const DailyMeals({
    required this.date,
    required this.meals,
    required this.summary,
  });

  @override
  List<Object?> get props => [date, meals, summary];
}
