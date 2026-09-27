import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../screens/home/home_screen.dart';
import 'routes.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // Global Dark/Light Mode
  static final ValueNotifier<ThemeMode> themeMode =
  ValueNotifier(ThemeMode.light);

  // Global Temperature Unit
  static final ValueNotifier<String> temperatureUnit =
  ValueNotifier('C');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weather App',

          themeMode: currentTheme,

          // Light Theme
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor:
            AppColors.background,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
            ),
            useMaterial3: true,
          ),

          // Dark Theme
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          initialRoute: AppRoutes.welcome,

          routes: AppRoutes.routes,

          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            );
          },
        );
      },
    );
  }
}