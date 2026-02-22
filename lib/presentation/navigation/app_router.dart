import 'package:go_router/go_router.dart';
import 'package:macrotrace/presentation/screens/meal_screen.dart';
import 'package:macrotrace/presentation/screens/meals_screen.dart';

// GoRouter configuration
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MealsScreen()),
    GoRoute(
      path: '/meal/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MealScreen(mealId: id);
      },
    ),
  ],
);
