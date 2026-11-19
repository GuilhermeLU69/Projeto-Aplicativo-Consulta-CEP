import 'package:flutter/material.dart';

import 'modules/history/page/history_page.dart';
import 'modules/home/page/home_page.dart';
import 'modules/initial/page/initial_page.dart';
import 'routes/app_routes.dart';
import 'shared/colors/app_colors.dart';

class FastLocationApp extends StatelessWidget {
  const FastLocationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastLocation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      initialRoute: AppRoutes.initial,
      routes: {
        AppRoutes.initial: (_) => const InitialPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.history: (_) => const HistoryPage(),
      },
    );
  }
}
