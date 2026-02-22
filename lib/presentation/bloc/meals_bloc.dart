import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macrotrace/domain/entities/daily_meals.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';
import 'package:macrotrace/domain/services/id_service.dart';
import 'package:macrotrace/domain/usecases/get_all_meals.dart';
import 'package:macrotrace/domain/usecases/get_daily_summary.dart';
import 'package:macrotrace/domain/usecases/get_food_items.dart';
import 'package:macrotrace/presentation/bloc/meals_event.dart';
import 'package:macrotrace/presentation/bloc/meals_state.dart';
import 'package:intl/intl.dart';
import 'package:macrotrace/domain/services/date_time_service.dart';
import 'package:macrotrace/presentation/models/daily_meals_ui_model.dart';
import 'package:macrotrace/presentation/navigation/navigation_service.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final GetAllMeals _getAllMeals;
  final GetFoodItems _getFoodItems;
  final GetDailySummary _getDailySummary;
  final IdService _idService;
  final NavigationService _navigationService;
  final DateTimeService _dateTimeService;
  final MealRepository _mealRepository;
  late final StreamSubscription _mealsUpdatedSubscription;

  MealsBloc({
    required GetAllMeals getAllMeals,
    required GetFoodItems getFoodItems,
    required GetDailySummary getDailySummary,
    required IdService idService,
    required NavigationService navigationService,
    required DateTimeService dateTimeService,
    required MealRepository mealRepository,
  }) : _getAllMeals = getAllMeals,
       _getFoodItems = getFoodItems,
       _getDailySummary = getDailySummary,
       _idService = idService,
       _navigationService = navigationService,
       _dateTimeService = dateTimeService,
       _mealRepository = mealRepository,
       super(const MealsState()) {
    on<LoadMeals>(_onLoadMeals);
    on<CreateMeal>(_onCreateMeal);
    on<EditMeal>(_onEditMeal);

    _mealsUpdatedSubscription = _mealRepository.mealsUpdated.listen((_) {
      add(LoadMeals());
    });
  }

  @override
  Future<void> close() {
    _mealsUpdatedSubscription.cancel();
    return super.close();
  }

  void _onCreateMeal(CreateMeal event, Emitter<MealsState> emit) {
    _navigationService.mealPage(_idService.generateId());
  }

  void _onEditMeal(EditMeal event, Emitter<MealsState> emit) {
    _navigationService.mealPage(event.mealId);
  }

  Future<void> _onLoadMeals(LoadMeals event, Emitter<MealsState> emit) async {
    emit(state.copyWith(status: MealsStatus.loading));
    try {
      final results = await Future.wait([_getAllMeals(), _getFoodItems()]);

      final allMeals = results[0] as List<Meal>;
      final foodItems = results[1] as List<FoodItem>;
      final foodItemMap = {for (var item in foodItems) item.id: item};

      // Group meals by day
      final Map<DateTime, List<Meal>> grouped = {};
      for (final meal in allMeals) {
        final date = DateUtils.dateOnly(meal.timestamp);
        if (grouped[date] == null) {
          grouped[date] = [];
        }
        grouped[date]!.add(meal);
      }

      // Create pure DailyMeals domain entities
      final List<DailyMeals> pureDailyMeals = [];
      for (final date in grouped.keys) {
        final mealsForDay = grouped[date]!;
        final summary = _getDailySummary(
          mealsForDay: mealsForDay,
          allFoodItems: foodItems,
        );
        pureDailyMeals.add(
          DailyMeals(date: date, meals: mealsForDay, summary: summary),
        );
      }

      // Sort pureDailyMeals descending by date
      pureDailyMeals.sort((a, b) => b.date.compareTo(a.date));

      // Transform pure DailyMeals into DailyMealsUIModel
      final List<DailyMealsUIModel> dailyMealsUIModels = [];
      final now = _dateTimeService.getToday();
      final yesterday = _dateTimeService.getYesterday();

      for (final dailyMeals in pureDailyMeals) {
        String formattedDate;
        if (DateUtils.isSameDay(dailyMeals.date, now)) {
          formattedDate = 'Today';
        } else if (DateUtils.isSameDay(dailyMeals.date, yesterday)) {
          formattedDate = 'Yesterday';
        } else {
          formattedDate = DateFormat.yMMMd().format(dailyMeals.date);
        }

        final formattedSummary =
            "P: ${dailyMeals.summary['protein']?.toStringAsFixed(1) ?? '0'} C: ${dailyMeals.summary['carbohydrate']?.toStringAsFixed(1) ?? '0'} F: ${dailyMeals.summary['fat']?.toStringAsFixed(1) ?? '0'}";

        dailyMealsUIModels.add(
          DailyMealsUIModel(
            dailyMeals: dailyMeals,
            formattedDate: formattedDate,
            formattedSummary: formattedSummary,
            foodItemMap:
                foodItemMap, // Passed to UIModel as it's needed for MealListItem
          ),
        );
      }

      emit(
        state.copyWith(
          status: MealsStatus.success,
          dailyMeals: dailyMealsUIModels,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: MealsStatus.failure,
          error: 'Failed to load meals: $e',
        ),
      );
    }
  }
}
