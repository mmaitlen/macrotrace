import 'package:go_router/go_router.dart';
import 'package:macrotrace/presentation/navigation/app_router.dart';

class NavigationService {
  NavigationService(this._goRouter);

  final GoRouter _goRouter;

  void back() => _goRouter.pop();

  void goHome() => _goRouter.go(homeScreenPath);
  void mealPage(String mealId) => _goRouter.push('/meal/$mealId');
}
