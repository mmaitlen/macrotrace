# MacroTrace Product Requirements Document (PRD)

## 1. High-Level Features

MacroTrace is a Flutter application designed to help users track their daily macronutrient intake. Users log meals composed of various food items, where each item contributes a specific "point" value towards a daily allotment for different macro categories (protein, carbohydrates, fat). The primary goal is to provide a simple, fast way for users to monitor their dietary goals.

## 2. Technical Requirements

- **Architecture:** Clean Architecture will be strictly followed, separating the application into Presentation, Domain, and Data layers.
- **UI Layer:**
    - **State Management:** Flutter BLoC will be used for state management, with BLoCs treated as ViewModels that interact with domain-layer use cases.
    - **Navigation:** `go_router` will manage all routing and navigation.
- **Dependency Injection:** `get_it` will be used for service location and dependency injection.
- **Persistence (Post-V1):** The initial version will use in-memory data. Future versions will use a more robust persistence solution like `SharedPreferences` or a local database.
- **Code Style:** All code must adhere to the official Dart Linter (`flutter_lints`) and Effective Dart guidelines.

## 3. Data Schemas (V1)

### 3.1 `FoodItem`

This model represents a single food item from the application's food database. For V1, this data is sourced from `assets/food_data_v2.json`.

**JSON Structure Example:**
```json
{
  "id": "turkey_breast",
  "name": "Turkey breast",
  "measurement_amount": 1.0,
  "measurement_unit": "oz",
  "macro_types": ["protein"]
}
```

- **`id` (String):** A unique identifier for the food item.
- **`name` (String):** The display name of the food.
- **`measurement_amount` (double):** The quantity of the base measurement that equals one "point".
- **`measurement_unit` (String):** The unit for the base measurement (e.g., "oz", "cup", "each").
- **`macro_types` (List<String>):** A list of macro categories this food belongs to.

### 3.2 `Meal`

This model represents a single meal, which is a collection of food entries at a specific time.

**Internal Structure Example (JSON representation):**
```json
{
  "timestamp": "2026-02-19T12:00:00Z",
  "entries": [
    {
      "food_id": "turkey_breast",
      "points": 2.5
    },
    {
      "food_id": "broccoli",
      "points": 1.0
    }
  ]
}
```

- **`timestamp` (DateTime):** The date and time the meal was logged.
- **`entries` (List<MealEntry>):** A list of the food entries that make up the meal.

### 3.3 `MealEntry`

This model represents a specific food consumed as part of a meal, linking a `FoodItem` with the amount consumed.

**Internal Structure Example (JSON representation):**
```json
{
  "food_id": "turkey_breast",
  "points": 2.5
}
```
- **`food_id` (String):** The ID of the food item, which references a `FoodItem`.
- **`points` (double):** The amount of the food consumed, measured in "points". For example, 2.5 points of Turkey Breast equates to 2.5 oz.

## 4. Task List (Milestones)

### Milestone 1: Foundation & Read-Only UI

**Goal:** Establish the project's architecture and display a read-only list of hardcoded meals. This milestone focuses on building the data foundation and the initial UI without any create, update, or delete functionality.

**Tasks:**

1.  **`feat(architecture): setup clean architecture folders`**
    - Create the directory structure for a Clean Architecture project (e.g., `data`, `domain`, `presentation` layers with sub-folders for `models`, `repositories`, `usecases`, `bloc`, `ui`).

2.  **`feat(data): define and implement data models`**
    - Create the Dart classes for `FoodItem`, `Meal`, and `MealEntry` based on the schemas in section 3.
    - Include `fromJson` factory constructors to parse the JSON data.

3.  **`feat(data): implement in-memory data service`**
    - Create a `FoodDataService` that reads `assets/food_data_v2.json` on initialization and stores the list of `FoodItem` objects in memory.
    - Create a `MealDataService` that returns a hardcoded, in-memory list of `Meal` objects for multiple days. This service will be the single source of truth for the UI in M1.
    - The service should expose a method like `Future<List<Meal>> getMealsForDate(DateTime date)`.

4.  **`feat(domain): create use cases`**
    - Implement a `GetMealsForDateUseCase` that retrieves meal data from the `MealDataService`.
    - Implement a `GetDailySummaryUseCase` that calculates the total points for each macro category for a given day.

5.  **`feat(ui): build scrolling meals screen`**
    - Create the `MealsScreen` widget.
    - Implement a `MealsBloc` that uses the domain-layer use cases to fetch and manage the state of the meals.
    - The UI should be a continuous, vertically scrolling list of all meals, grouped and separated by date headers.
    - Each date header should display a summary of the total consumed points (protein, carbohydrates, and fat) for that day.
    - In the date header should display "Today" for the current date and "Yesterday" for the previous day.  All other headers show a formatted date.
    - The list should not scroll endlessly into the past; it should begin from the current date and end at the earliest meal entry provided by the data service.

6.  **`feat(domain): adjust use cases for scrolling view`**
    - Modify the `GetMealsForDateUseCase` to a `GetAllMealsUseCase` that retrieves all meals, sorted by date.
    - The `GetDailySummaryUseCase` will now likely be used by the BLoC to calculate summaries for each day group within the list.

7.  **`test(bloc): implement headless bloc test`**
    - Create a headless `bloc_test` for the `MealsBloc` to ensure correct state transformations.
    - Implement an injectable `DateTimeService` to abstract `DateTime.now()` and improve testability of date-sensitive logic.
    - Introduce a `DailyMealsUIModel` in the presentation layer to separate UI concerns from domain entities, adhering to Clean Architecture principles.
    - Ensure all tests pass and the data flow from mock data sources to the `MealsState` is correct.
