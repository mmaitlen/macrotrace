import 'package:equatable/equatable.dart';
import 'package:macrotrace/presentation/models/daily_meals_ui_model.dart'; // New import

enum MealsStatus { initial, loading, success, failure }

class MealsState extends Equatable {
  final MealsStatus status;
  final List<DailyMealsUIModel> dailyMeals; // Changed type
  final String? error;

  const MealsState({
    this.status = MealsStatus.initial,
    this.dailyMeals = const [],
    this.error,
  });

  MealsState copyWith({
    MealsStatus? status,
    List<DailyMealsUIModel>? dailyMeals, // Changed type
    String? error,
  }) {
    return MealsState(
      status: status ?? this.status,
      dailyMeals: dailyMeals ?? this.dailyMeals,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, dailyMeals, error];
}
