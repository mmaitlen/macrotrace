import 'package:macrotrace/domain/entities/meal_entry.dart';

class Meal {
  final DateTime timestamp;
  final List<MealEntry> entries;

  Meal({required this.timestamp, required this.entries});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      timestamp: DateTime.parse(json['timestamp'] as String),
      entries: (json['entries'] as List)
          .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
