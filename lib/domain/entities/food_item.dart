import 'package:macrotrace/domain/entities/macro_type.dart';

class FoodItem {
  final String id;
  final String name;
  final double measurementAmount;
  final String measurementUnit;
  final List<MacroType> macroTypes;

  FoodItem({
    required this.id,
    required this.name,
    required this.measurementAmount,
    required this.measurementUnit,
    required this.macroTypes,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      measurementAmount: (json['measurement_amount'] as num).toDouble(),
      measurementUnit: json['measurement_unit'] as String,
      macroTypes:
          (json['macro_types'] as List)
              .map((e) => MacroType.fromString(e as String))
              .toList(),
    );
  }
}
