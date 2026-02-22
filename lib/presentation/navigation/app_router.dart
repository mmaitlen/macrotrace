import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:macrotrace/presentation/bloc/meal_form_bloc.dart';
import 'package:macrotrace/presentation/bloc/meal_form_event.dart';
import 'package:macrotrace/presentation/screens/meal_screen.dart';
import 'package:macrotrace/presentation/screens/meals_screen.dart';
import 'package:macrotrace/service_locator.dart' as sl;

// GoRouter configuration
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MealsScreen()),
    GoRoute(
      path: '/meal/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => sl.sl<MealFormBloc>()..add(LoadMealForm(id)),
          child: MealScreen(mealId: id),
        );
      },
    ),
  ],
);
