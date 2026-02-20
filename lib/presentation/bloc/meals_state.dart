import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/daily_meals.dart';
import 'package:macrotrace/domain/entities/food_item.dart';

enum MealsStatus { initial, loading, success, failure }

class MealsState extends Equatable {
  final MealsStatus status;
  final List<DailyMeals> dailyMeals;
  final Map<String, FoodItem> foodItemMap;
  final String? error;

  const MealsState({
    this.status = MealsStatus.initial,
    this.dailyMeals = const [],
    this.foodItemMap = const {},
    this.error,
  });

  MealsState copyWith({
    MealsStatus? status,
    List<DailyMeals>? dailyMeals,
    Map<String, FoodItem>? foodItemMap,
    String? error,
  }) {
    return MealsState(
      status: status ?? this.status,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      foodItemMap: foodItemMap ?? this.foodItemMap,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, dailyMeals, foodItemMap, error];
}
