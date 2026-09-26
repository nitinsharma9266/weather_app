import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/weather_model.dart';

class WeatherHeader extends StatelessWidget {
  final WeatherModel? weather;

  const WeatherHeader({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Icon(
            Icons.sunny,
            color: AppColors.weatherAccent,
            size: 20,
          ),
        ),

        const SizedBox(height: 30),

        Center(
          child: Text(
            weather == null
                ? "--°C"
                : "${weather!.temperature.round()}°C",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: Text(
            weather == null
                ? "--"
                : weather!.condition,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: Text(
            weather == null
                ? "Feels like --°C"
                : "Feels like "
                "${weather!.feelsLike.round()}°C",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}