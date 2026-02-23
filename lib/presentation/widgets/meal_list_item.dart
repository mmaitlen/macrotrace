import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';

class MealListItem extends StatelessWidget {
  final Meal meal;
  final Map<String, FoodItem> foodItemMap;
  final ValueChanged<String> onEditMeal;

  const MealListItem({
    super.key,
    required this.meal,
    required this.foodItemMap,
    required this.onEditMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meal at ${DateFormat.jm().format(meal.timestamp)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => onEditMeal(meal.id),
                ),
              ],
            ),
            ...meal.entries.map((entry) {
              final foodItem = foodItemMap[entry.foodId];
              if (foodItem == null) {
                return Text('Unknown food item: ${entry.foodId}');
              }
              final amount = entry.points * foodItem.measurementAmount;
              return ListTile(
                title: Text(foodItem.name),
                subtitle: Text(
                  '${amount.toStringAsFixed(1)} ${foodItem.measurementUnit}',
                ),
                trailing: Text('${entry.points.toStringAsFixed(1)} pts'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
