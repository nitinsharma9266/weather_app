import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/home/profile_screen.dart';
import '../screens/home/welcome_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/forecast/forecast_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String home = '/';
  static const String search = '/search';
  static const String forecast = '/forecast';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(),
      home: (context) => const HomeScreen(),
      search: (context) => const SearchScreen(),
      forecast: (context) => const ForecastScreen(),
      settings: (context) => const SettingsScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }
}