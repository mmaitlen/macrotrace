import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/data/repositories/meal_repository_impl.dart';
import 'package:macrotrace/domain/entities/daily_meals.dart';
import 'package:macrotrace/domain/entities/food_item.dart';
import 'package:macrotrace/domain/entities/meal.dart';
import 'package:macrotrace/domain/entities/meal_entry.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';
import 'package:macrotrace/domain/services/date_time_service.dart';
import 'package:macrotrace/domain/usecases/get_all_meals.dart';
import 'package:macrotrace/domain/usecases/get_daily_summary.dart';
import 'package:macrotrace/domain/usecases/get_food_items.dart';
import 'package:macrotrace/presentation/bloc/meals_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_event.dart';
import 'package:macrotrace/presentation/bloc/meals_state.dart';
import 'package:macrotrace/presentation/models/daily_meals_ui_model.dart'; // New import
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'meals_bloc_test.mocks.dart';

@GenerateMocks([
  DateTimeService,
  LocalDataSource,
  GetAllMeals,
  GetFoodItems,
  GetDailySummary,
])
void main() {
  late MockDateTimeService mockDateTimeService;
  late MockLocalDataSource mockLocalDataSource;
  late MealRepository mockMealRepository;
  late GetAllMeals getAllMeals;
  late GetFoodItems getFoodItems;
  late GetDailySummary getDailySummary;
  late MealsBloc mealsBloc;

  // Hardcoded date for testing
  final DateTime testToday = DateTime(1969, 7, 16);
  final DateTime testYesterday = DateTime(1969, 7, 15);
  final DateTime testTwoDaysAgo = DateTime(1969, 7, 14);
  final DateTime testThreeDaysAgo = DateTime(1969, 7, 13);

  // Hardcoded FoodItems
  final List<FoodItem> testFoodItems = [
    FoodItem(
      id: 'banana',
      name: 'Banana',
      measurementAmount: 1.0,
      measurementUnit: 'each',
      macroTypes: ['carbohydrate'],
    ),
    FoodItem(
      id: 'chicken_breast',
      name: 'Chicken Breast',
      measurementAmount: 4.0,
      measurementUnit: 'oz',
      macroTypes: ['protein'],
    ),
    FoodItem(
      id: 'avocado',
      name: 'Avocado',
      measurementAmount: 0.5,
      measurementUnit: 'each',
      macroTypes: ['fat'],
    ),
  ];

  // Hardcoded Meals
  final List<Meal> testMeals = [
    // Today's meals (July 16, 1969)
    Meal(
      timestamp: DateTime(1969, 7, 16, 8, 0),
      entries: [
        MealEntry(foodId: 'banana', points: 2.0),
        MealEntry(foodId: 'chicken_breast', points: 3.0),
      ],
    ),
    Meal(
      timestamp: DateTime(1969, 7, 16, 12, 30),
      entries: [
        MealEntry(foodId: 'chicken_breast', points: 5.0),
        MealEntry(foodId: 'avocado', points: 1.5),
      ],
    ),
    // Yesterday's meals (July 15, 1969)
    Meal(
      timestamp: DateTime(1969, 7, 15, 9, 0),
      entries: [
        MealEntry(foodId: 'banana', points: 3.0),
        MealEntry(foodId: 'avocado', points: 2.0),
      ],
    ),
    // Two days ago meals (July 14, 1969)
    Meal(
      timestamp: DateTime(1969, 7, 14, 18, 0),
      entries: [MealEntry(foodId: 'chicken_breast', points: 4.0)],
    ),
    // Three days ago meals (July 13, 1969)
    Meal(
      timestamp: DateTime(1969, 7, 13, 10, 0),
      entries: [MealEntry(foodId: 'banana', points: 1.0)],
    ),
  ];

  setUpAll(() {
    // Register GetDailySummary as it doesn't have external dependencies
    GetIt.instance.registerLazySingleton(() => GetDailySummary());
  });

  setUp(() {
    mockDateTimeService = MockDateTimeService();
    mockLocalDataSource = MockLocalDataSource();
    mockMealRepository = MealRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
    getAllMeals = GetAllMeals(mockMealRepository);
    getFoodItems = GetFoodItems(mockMealRepository);
    getDailySummary =
        GetIt.instance<GetDailySummary>(); // Get the real instance

    when(mockDateTimeService.getToday()).thenReturn(testToday);
    when(mockDateTimeService.getYesterday()).thenReturn(testYesterday);

    when(
      mockLocalDataSource.getFoodItems(),
    ).thenAnswer((_) async => testFoodItems);
    when(mockLocalDataSource.getAllMeals()).thenAnswer((_) async => testMeals);

    mealsBloc = MealsBloc(
      getAllMeals: getAllMeals,
      getFoodItems: getFoodItems,
      getDailySummary: getDailySummary,
      dateTimeService: mockDateTimeService,
    );
  });

  tearDown(() {
    mealsBloc.close();
    GetIt.instance.reset(); // Reset GetIt for each test to avoid conflicts
  });

  blocTest<MealsBloc, MealsState>(
    'emits [loading, success] with correct daily meals and formatted dates',
    build: () => mealsBloc,
    act: (bloc) => bloc.add(LoadMeals()),
    expect: () => [
      const MealsState(status: MealsStatus.loading),
      MealsState(
        status: MealsStatus.success,
        dailyMeals: [
          DailyMealsUIModel(
            dailyMeals: DailyMeals(
              date: testToday,
              meals: [testMeals[0], testMeals[1]],
              summary: {'carbohydrate': 2.0, 'protein': 8.0, 'fat': 1.5},
            ),
            formattedDate: 'Today',
            formattedSummary: 'P: 8.0 C: 2.0 F: 1.5',
            foodItemMap: {for (var item in testFoodItems) item.id: item},
          ),
          DailyMealsUIModel(
            dailyMeals: DailyMeals(
              date: testYesterday,
              meals: [testMeals[2]],
              summary: {'carbohydrate': 3.0, 'protein': 0.0, 'fat': 2.0},
            ),
            formattedDate: 'Yesterday',
            formattedSummary: 'P: 0.0 C: 3.0 F: 2.0',
            foodItemMap: {for (var item in testFoodItems) item.id: item},
          ),
          DailyMealsUIModel(
            dailyMeals: DailyMeals(
              date: testTwoDaysAgo,
              meals: [testMeals[3]],
              summary: {'protein': 4.0, 'carbohydrate': 0.0, 'fat': 0.0},
            ),
            formattedDate:
                'Jul 14, 1969', // Format 'MMM d, yyyy' from DateFormat.yMMMd()
            formattedSummary: 'P: 4.0 C: 0.0 F: 0.0',
            foodItemMap: {for (var item in testFoodItems) item.id: item},
          ),
          DailyMealsUIModel(
            dailyMeals: DailyMeals(
              date: testThreeDaysAgo,
              meals: [testMeals[4]],
              summary: {'carbohydrate': 1.0, 'protein': 0.0, 'fat': 0.0},
            ),
            formattedDate:
                'Jul 13, 1969', // Format 'MMM d, yyyy' from DateFormat.yMMMd()
            formattedSummary: 'P: 0.0 C: 1.0 F: 0.0',
            foodItemMap: {for (var item in testFoodItems) item.id: item},
          ),
        ],
      ),
    ],
  );
}
