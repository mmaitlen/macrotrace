import 'package:equatable/equatable.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

enum MealFormStatus { initial, loading, success, failure, saveSuccess }

class MealFormState extends Equatable {
  final MealFormStatus status;
  final bool isEditMode;
  final Meal? initialMeal;
  final List<FoodItem> foodItems;
  final Map<String, double> selectedFoodEntries;
  final String? error;

  const MealFormState({
    this.status = MealFormStatus.initial,
    this.isEditMode = false,
    this.initialMeal,
    this.foodItems = const [],
    this.selectedFoodEntries = const {},
    this.error,
  });

  MealFormState copyWith({
    MealFormStatus? status,
    bool? isEditMode,
    Meal? initialMeal,
    List<FoodItem>? foodItems,
    Map<String, double>? selectedFoodEntries,
    String? error,
  }) {
    return MealFormState(
      status: status ?? this.status,
      isEditMode: isEditMode ?? this.isEditMode,
      initialMeal: initialMeal ?? this.initialMeal,
      foodItems: foodItems ?? this.foodItems,
      selectedFoodEntries: selectedFoodEntries ?? this.selectedFoodEntries,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isEditMode,
    initialMeal,
    foodItems,
    selectedFoodEntries,
    error,
  ];
}
