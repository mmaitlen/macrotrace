import 'package:equatable/equatable.dart';

class MealEntry extends Equatable {
  final String foodId;
  final double points;

  const MealEntry({required this.foodId, required this.points});

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      foodId: json['food_id'] as String,
      points: (json['points'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [foodId, points];
}
