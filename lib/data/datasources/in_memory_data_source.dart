import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/entities/meal_entry.dart';

class InMemoryDataSource implements LocalDataSource {
  List<FoodItem> _foodItems = [];
  final List<Meal> _meals = [];

  Future<void> init() async {
    await _loadFoodItems();
    _generateHardcodedMeals();
  }

  Future<void> _loadFoodItems() async {
    final jsonString = await rootBundle.loadString('assets/food_data_v2.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List;
    _foodItems = jsonList.map((json) => FoodItem.fromJson(json as Map<String, dynamic>)).toList();
  }

  void _generateHardcodedMeals() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    _meals.addAll([
      // Yesterday's Meals
      Meal(
        timestamp: DateTime(yesterday.year, yesterday.month, yesterday.day, 8), // Breakfast
        entries: [
          MealEntry(foodId: 'whole_egg', points: 2),
          MealEntry(foodId: 'oatmeal', points: 1),
        ],
      ),
      Meal(
        timestamp: DateTime(yesterday.year, yesterday.month, yesterday.day, 13), // Lunch
        entries: [
          MealEntry(foodId: 'ground_turkey', points: 4),
          MealEntry(foodId: 'broccoli', points: 1),
          MealEntry(foodId: 'olive_oil', points: 1),
        ],
      ),
      // Today's Meals
      Meal(
        timestamp: DateTime(today.year, today.month, today.day, 9), // Breakfast
        entries: [
          MealEntry(foodId: 'yogurt', points: 1),
          MealEntry(foodId: 'almonds', points: 1),
        ],
      ),
    ]);
  }

  @override
  Future<List<FoodItem>> getFoodItems() async {
    if (_foodItems.isEmpty) {
      await init();
    }
    return _foodItems;
  }

  @override
  Future<List<Meal>> getAllMeals() async {
    if (_meals.isEmpty) {
      await init();
    }
    return _meals;
  }
}
