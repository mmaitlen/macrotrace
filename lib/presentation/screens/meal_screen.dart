import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:macrotrace/presentation/bloc/meal_form_bloc.dart';
import 'package:macrotrace/presentation/bloc/meal_form_event.dart';
import 'package:macrotrace/presentation/bloc/meal_form_state.dart';

class MealScreen extends StatelessWidget {
  final String mealId;

  const MealScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealFormBloc, MealFormState>(
      listener: (context, state) {
        if (state.status == MealFormStatus.saveSuccess) {
          context.pop();
        }
      },
      child: BlocBuilder<MealFormBloc, MealFormState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.isEditMode ? 'Edit Meal' : 'Create Meal'),
            ),
            body: Builder(
              builder: (context) {
                if (state.status == MealFormStatus.loading ||
                    state.status == MealFormStatus.initial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == MealFormStatus.failure) {
                  return Center(
                    child: Text(state.error ?? 'An unknown error occurred.'),
                  );
                }
                if (state.status == MealFormStatus.success ||
                    state.status == MealFormStatus.saveSuccess) {
                  final sortedFoodItems = [...state.foodItems]
                    ..sort((a, b) {
                      final aIsSelected = state.selectedFoodEntries.containsKey(
                        a.id,
                      );
                      final bIsSelected = state.selectedFoodEntries.containsKey(
                        b.id,
                      );
                      if (aIsSelected && !bIsSelected) {
                        return -1;
                      }
                      if (!aIsSelected && bIsSelected) {
                        return 1;
                      }
                      return a.name.compareTo(b.name);
                    });

                  return ListView.builder(
                    itemCount: sortedFoodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = sortedFoodItems[index];
                      final isSelected = state.selectedFoodEntries.containsKey(
                        foodItem.id,
                      );

                      if (isSelected) {
                        final points = state.selectedFoodEntries[foodItem.id]!;
                        return ListTile(
                          title: Text(foodItem.name),
                          leading: IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              context.read<MealFormBloc>().add(
                                ToggleFoodItem(
                                  foodId: foodItem.id,
                                  isSelected: false,
                                ),
                              );
                            },
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: TextField(
                              controller: TextEditingController(
                                text: points.toString(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final newPoints = double.tryParse(value);
                                if (newPoints != null) {
                                  context.read<MealFormBloc>().add(
                                    UpdateFoodItemPoints(
                                      foodId: foodItem.id,
                                      points: newPoints,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(foodItem.name),
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              if (value != null) {
                                context.read<MealFormBloc>().add(
                                  ToggleFoodItem(
                                    foodId: foodItem.id,
                                    isSelected: value,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: state.selectedFoodEntries.isNotEmpty
                  ? () {
                      context.read<MealFormBloc>().add(SaveMealRequested());
                    }
                  : null,
              child: const Icon(Icons.save),
            ),
          );
        },
      ),
    );
  }
}
