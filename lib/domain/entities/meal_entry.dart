class MealEntry {
  final String foodId;
  final double points;

  MealEntry({required this.foodId, required this.points});

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      foodId: json['food_id'] as String,
      points: (json['points'] as num).toDouble(),
    );
  }
}
