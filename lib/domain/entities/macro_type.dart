enum MacroType {
  protein,
  carbohydrate,
  fat;

  static MacroType fromString(String value) {
    return MacroType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown macro type: $value'),
    );
  }
}
