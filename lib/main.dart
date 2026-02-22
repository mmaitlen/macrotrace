import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_bloc.dart';
import 'package:macrotrace/presentation/bloc/meals_event.dart';
import 'package:macrotrace/presentation/navigation/app_router.dart';
import 'package:macrotrace/service_locator.dart' as service_locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service_locator.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => service_locator.sl<MealsBloc>()..add(LoadMeals()),
      child: MaterialApp.router(routerConfig: appRouter),
    );
  }
}
