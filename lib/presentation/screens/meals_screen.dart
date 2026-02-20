import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_state.dart';
import 'package:macrotrace/presentation/widgets/date_header.dart';
import 'package:macrotrace/presentation/widgets/meal_list_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MacroTrace')),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (context, state) {
          if (state.status == MealsStatus.loading ||
              state.status == MealsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MealsStatus.failure) {
            return Center(
              child: Text(state.error ?? 'An unknown error occurred.'),
            );
          }
          if (state.status == MealsStatus.success && state.dailyMeals.isEmpty) {
            return const Center(child: Text('No meals logged yet.'));
          }

          return ListView.builder(
            itemCount: state.dailyMeals.length,
            itemBuilder: (context, index) {
              final dailyMeals = state.dailyMeals[index];
              final formattedSummary =
                  "P: ${dailyMeals.protienPointTotal.toStringAsFixed(1)} - C: ${dailyMeals.carbohydratePointTotal.toStringAsFixed(1)} - F: ${dailyMeals.fatPointTotal.toStringAsFixed(1)}";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateHeader(
                    formattedDate: dailyMeals.formattedDate,
                    formattedSummary: formattedSummary,
                  ),
                  ...dailyMeals.meals.map(
                    (meal) => MealListItem(
                      meal: meal,
                      foodItemMap: state.foodItemMap,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
