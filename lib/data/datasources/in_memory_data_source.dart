import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/entities/meal_entry.dart';
import 'package:macrotrace/domain/services/id_service.dart'; // New import

class InMemoryDataSource implements LocalDataSource {
  final IdService _idService;
  List<FoodItem> _foodItems = [];
  final List<Meal> _meals = [];
  final _mealsUpdatedController = StreamController<void>.broadcast();

  InMemoryDataSource({required IdService idService}) : _idService = idService;

  @override
  Stream<void> get mealsUpdated => _mealsUpdatedController.stream;

  @override
  Future<void> init() async {
    await _loadFoodItems();
    _generateHardcodedMeals();
  }

  Future<void> _loadFoodItems() async {
    final jsonString = await rootBundle.loadString('assets/food_data_v2.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List;
    _foodItems = jsonList
        .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void _generateHardcodedMeals() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // hardcoded meals used during initial development
    _meals.addAll([
      // Yesterday's Meals
      Meal(
        id: _idService.generateId(),
        timestamp: DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          8,
        ), // Breakfast
        entries: [
          MealEntry(foodId: 'whole_egg', points: 2),
          MealEntry(foodId: 'oatmeal', points: 1),
        ],
      ),
      Meal(
        id: _idService.generateId(),
        timestamp: DateTime(
          yesterday.year,
          yesterday.month,
          yesterday.day,
          13,
        ), // Lunch
        entries: [
          MealEntry(foodId: 'ground_turkey', points: 4),
          MealEntry(foodId: 'broccoli', points: 1),
          MealEntry(foodId: 'olive_oil', points: 1),
        ],
      ),
      // Today's Meals
      Meal(
        id: _idService.generateId(),
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

  @override
  Future<void> saveMeal(Meal meal) async {
    // get meal if it exists
    final index = _meals.indexWhere((m) => m.id == meal.id);
    // determine if we're editing existing meal or saving new meal
    if (index != -1) {
      // save existing meal
      _meals[index] = meal;
    } else {
      // save new meal
      _meals.add(meal);
    }
    _mealsUpdatedController.add(null);
  }

  @override
  void dispose() {
    _mealsUpdatedController.close();
  }
}
