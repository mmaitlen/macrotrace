import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/meal_entry.dart';
import 'package:uuid/uuid.dart';

class Meal extends Equatable {
  final String id;
  final DateTime timestamp;
  final List<MealEntry> entries;

  const Meal({
    required this.id,
    required this.timestamp,
    required this.entries,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String? ?? const Uuid().v4(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      entries: (json['entries'] as List)
          .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, timestamp, entries];
}
