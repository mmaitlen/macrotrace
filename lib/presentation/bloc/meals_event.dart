import 'package:equatable/equatable.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object> get props => [];
}

class LoadMeals extends MealsEvent {}

class CreateMeal extends MealsEvent {}

class EditMeal extends MealsEvent {
  final String mealId;
  const EditMeal(this.mealId);
}
