import 'package:get_it/get_it.dart';
import 'package:macrotrace/data/datasources/in_memory_data_source.dart';
import 'package:macrotrace/data/datasources/local_data_source.dart';
import 'package:macrotrace/data/repositories/meal_repository_impl.dart';
import 'package:macrotrace/domain/repositories/meal_repository.dart';
import 'package:macrotrace/domain/usecases/get_all_meals.dart';
import 'package:macrotrace/domain/usecases/get_daily_summary.dart';
import 'package:macrotrace/domain/usecases/get_food_items.dart';
import 'package.macrotrace/presentation/bloc/meals_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => MealsBloc(
      getAllMeals: sl(),
      getFoodItems: sl(),
      getDailySummary: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllMeals(sl()));
  sl.registerLazySingleton(() => GetFoodItems(sl()));
  sl.registerLazySingleton(() => GetDailySummary());

  // Repository
  sl.registerLazySingleton<MealRepository>(
    () => MealRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => InMemoryDataSource(),
  );

  // Initialize data source
  await sl<LocalDataSource>().init();
}
