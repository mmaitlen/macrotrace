import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macrotrace/domain/entities/daily_meals.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/usecases/get_all_meals.dart';
import 'package:macrotrace/domain/usecases/get_daily_summary.dart';
import 'package:macrotrace/domain/usecases/get_food_items.dart';
import 'package:macrotrace/presentation/bloc/meals_event.dart';
import 'package:macrotrace/presentation/bloc/meals_state.dart';
import 'package:intl/intl.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final GetAllMeals _getAllMeals;
  final GetFoodItems _getFoodItems;
  final GetDailySummary _getDailySummary;

  MealsBloc({
    required GetAllMeals getAllMeals,
    required GetFoodItems getFoodItems,
    required GetDailySummary getDailySummary,
  }) : _getAllMeals = getAllMeals,
       _getFoodItems = getFoodItems,
       _getDailySummary = getDailySummary,
       super(const MealsState()) {
    on<LoadMeals>(_onLoadMeals);
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

      // Create DailyMeals objects with summaries
      final List<DailyMeals> dailyMeals = [];
      final now = DateUtils.dateOnly(DateTime.now());
      final yesterday = DateUtils.dateOnly(
        DateTime.now().subtract(const Duration(days: 1)),
      );

      for (final date in grouped.keys) {
        final mealsForDay = grouped[date]!;
        final summary = _getDailySummary(
          mealsForDay: mealsForDay,
          allFoodItems: foodItems,
        );

        String formattedDate;
        if (date == now) {
          formattedDate = 'Today';
        } else if (date == yesterday) {
          formattedDate = 'Yesterday';
        } else {
          formattedDate = DateFormat.yMMMd().format(date);
        }

        dailyMeals.add(
          DailyMeals(
            date: date,
            meals: mealsForDay,
            summary: summary,
            formattedDate: formattedDate,
            protienPointTotal: summary['protein'] ?? 0,
            carbohydratePointTotal: summary['carbohydrate'] ?? 0,
            fatPointTotal: summary['fat'] ?? 0,
          ),
        );
      }

      // Sort days descending
      dailyMeals.sort((a, b) => b.date.compareTo(a.date));

      emit(
        state.copyWith(
          status: MealsStatus.success,
          dailyMeals: dailyMeals,
          foodItemMap: foodItemMap,
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
