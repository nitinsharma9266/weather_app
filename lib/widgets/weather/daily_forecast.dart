import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/daily_forecast_model.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyForecastModel> forecasts;

  const DailyForecast({
    super.key,
    required this.forecasts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppStrings.fiveDayForecast,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...forecasts.map((day) {
          return Card(
            elevation: 3,
            color: AppColors.white,
            shadowColor: AppColors.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              leading: Image.network(
                'https://openweathermap.org/img/wn/'
                    '${day.icon}@2x.png',
                width: 50,
                height: 50,
              ),
              title: Text(
                "${day.date.day}/${day.date.month}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${day.condition} • "
                    "${day.minRainProbability}% - "
                    "${day.maxRainProbability}% "
                    "${AppStrings.rain}",
              ),
              trailing: Text(
                "${day.temperature.round()}°C",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}