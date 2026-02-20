import 'package:equatable/equatable.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();

  @override
  List<Object> get props => [];
}

class LoadMeals extends MealsEvent {}
