import 'package:equatable/equatable.dart';

abstract class MealFormEvent extends Equatable {
  const MealFormEvent();

  @override
  List<Object> get props => [];
}

class LoadMealForm extends MealFormEvent {
  final String mealId;

  const LoadMealForm(this.mealId);

  @override
  List<Object> get props => [mealId];
}

class ToggleFoodItem extends MealFormEvent {
  final String foodId;
  final bool isSelected;

  const ToggleFoodItem({required this.foodId, required this.isSelected});

  @override
  List<Object> get props => [foodId, isSelected];
}

class UpdateFoodItemPoints extends MealFormEvent {
  final String foodId;
  final double points;

  const UpdateFoodItemPoints({required this.foodId, required this.points});

  @override
  List<Object> get props => [foodId, points];
}

class SaveMealRequested extends MealFormEvent {}
