import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class DailyMeals extends Equatable {
  final DateTime date;
  final List<Meal> meals;
  final Map<String, double> summary;
  final String formattedDate;
  final double protienPointTotal;
  final double carbohydratePointTotal;
  final double fatPointTotal;

  const DailyMeals({
    required this.date,
    required this.meals,
    required this.summary,
    required this.formattedDate,
    required this.protienPointTotal,
    required this.carbohydratePointTotal,
    required this.fatPointTotal,
  });

  @override
  List<Object?> get props => [
    date,
    meals,
    summary,
    formattedDate,
    protienPointTotal,
    carbohydratePointTotal,
    fatPointTotal,
  ];
}
