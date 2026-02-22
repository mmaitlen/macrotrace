import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/entities/meal_entry.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';
import 'package:macrotrace/domain/services/id_service.dart';
import 'package:macrotrace/domain/usecases/get_meal_by_id.dart';
import 'package:macrotrace/domain/usecases/save_meal.dart';
import 'package:macrotrace/presentation/bloc/meal_form_event.dart';
import 'package:macrotrace/presentation/bloc/meal_form_state.dart';

class MealFormBloc extends Bloc<MealFormEvent, MealFormState> {
  final MealRepository _mealRepository;
  final GetMealById _getMealById;
  final SaveMeal _saveMeal;
  final IdService _idService;

  MealFormBloc({
    required MealRepository mealRepository,
    required GetMealById getMealById,
    required SaveMeal saveMeal,
    required IdService idService,
  }) : _mealRepository = mealRepository,
       _getMealById = getMealById,
       _saveMeal = saveMeal,
       _idService = idService,
       super(const MealFormState()) {
    on<LoadMealForm>(_onLoadMealForm);
    on<ToggleFoodItem>(_onToggleFoodItem);
    on<UpdateFoodItemPoints>(_onUpdateFoodItemPoints);
    on<SaveMealRequested>(_onSaveMealRequested);
  }

  Future<void> _onSaveMealRequested(
    SaveMealRequested event,
    Emitter<MealFormState> emit,
  ) async {
    emit(state.copyWith(status: MealFormStatus.loading));
    try {
      final entries = state.selectedFoodEntries.entries
          .map((entry) => MealEntry(foodId: entry.key, points: entry.value))
          .toList();

      final meal = Meal(
        id: state.initialMeal?.id ?? _idService.generateId(),
        timestamp: state.initialMeal?.timestamp ?? DateTime.now(),
        entries: entries,
      );

      await _saveMeal(meal);
      emit(state.copyWith(status: MealFormStatus.saveSuccess));
    } catch (e) {
      emit(
        state.copyWith(
          status: MealFormStatus.failure,
          error: 'Failed to save meal: $e',
        ),
      );
    }
  }

  void _onUpdateFoodItemPoints(
    UpdateFoodItemPoints event,
    Emitter<MealFormState> emit,
  ) {
    final updatedSelectedFoodEntries = Map<String, double>.from(
      state.selectedFoodEntries,
    );
    updatedSelectedFoodEntries[event.foodId] = event.points;
    emit(state.copyWith(selectedFoodEntries: updatedSelectedFoodEntries));
  }

  void _onToggleFoodItem(ToggleFoodItem event, Emitter<MealFormState> emit) {
    final updatedSelectedFoodEntries = Map<String, double>.from(
      state.selectedFoodEntries,
    );
    if (event.isSelected) {
      updatedSelectedFoodEntries[event.foodId] = 1.0;
    } else {
      updatedSelectedFoodEntries.remove(event.foodId);
    }
    emit(state.copyWith(selectedFoodEntries: updatedSelectedFoodEntries));
  }

  Future<void> _onLoadMealForm(
    LoadMealForm event,
    Emitter<MealFormState> emit,
  ) async {
    emit(state.copyWith(status: MealFormStatus.loading));
    try {
      final foodItems = await _mealRepository.getFoodItems();
      final meal = await _getMealById(event.mealId);

      if (meal != null) {
        final selectedFoodEntries = {
          for (var entry in meal.entries) entry.foodId: entry.points,
        };
        emit(
          state.copyWith(
            status: MealFormStatus.success,
            foodItems: foodItems,
            initialMeal: meal,
            isEditMode: true,
            selectedFoodEntries: selectedFoodEntries,
          ),
        );
      } else {
        emit(
          state.copyWith(status: MealFormStatus.success, foodItems: foodItems),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: MealFormStatus.failure,
          error: 'Failed to load meal form: $e',
        ),
      );
    }
  }
}
