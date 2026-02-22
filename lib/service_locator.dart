import 'package:get_it/get_it.dart';
import 'package:macrotrace/data/datasources/in_memory_data_source.dart';
import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/data/repositories/meal_repository_impl.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';
import 'package:macrotrace/domain/usecases/get_all_meals.dart';
import 'package:macrotrace/domain/usecases/get_daily_summary.dart';
import 'package:macrotrace/domain/usecases/get_food_items.dart';
import 'package:macrotrace/domain/usecases/get_meal_by_id.dart';
import 'package:macrotrace/domain/usecases/save_meal.dart';
import 'package:macrotrace/presentation/bloc/meal_form_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_bloc.dart';
import 'package:macrotrace/domain/services/date_time_service.dart';
import 'package:macrotrace/data/services/system_date_time_service.dart';
import 'package:macrotrace/domain/services/id_service.dart'; // New import
import 'package:macrotrace/data/services/uuid_service.dart';
import 'package:macrotrace/presentation/navigation/app_router.dart';
import 'package:macrotrace/presentation/navigation/navigation_service.dart'; // New import

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => MealsBloc(
      getAllMeals: sl(),
      getFoodItems: sl(),
      getDailySummary: sl(),
      idService: sl(),
      navigationService: sl(),
      dateTimeService: sl(),
      mealRepository: sl(),
    ),
  );
  sl.registerFactory(
    () => MealFormBloc(
      mealRepository: sl(),
      getMealById: sl(),
      saveMeal: sl(),
      idService: sl(), // Provide IdService
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllMeals(sl()));
  sl.registerLazySingleton(() => GetFoodItems(sl()));
  sl.registerLazySingleton(() => GetDailySummary());
  sl.registerLazySingleton(() => GetMealById(sl()));
  sl.registerLazySingleton(() => SaveMeal(sl()));

  // Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => InMemoryDataSource(idService: sl()),
  ); // Provide IdService

  // Services
  sl.registerLazySingleton<DateTimeService>(
    () => SystemDateTimeService(getNow: DateTime.now),
  );
  sl.registerLazySingleton<IdService>(
    () => UuidService(),
  ); // Register IdService

  // Navigation
  sl.registerLazySingleton(() => NavigationService(appRouter));

  // Initialize data source
  await sl<LocalDataSource>().init();
}
