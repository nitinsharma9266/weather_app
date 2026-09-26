import '../models/daily_forecast_model.dart';
import '../models/forecast_model.dart';

class ForecastService {
  List<DailyForecastModel> getDailyForecast(
      List<ForecastModel> forecasts,
      ) {
    final Map<String, List<ForecastModel>> groupedForecasts = {};

    for (final forecast in forecasts) {
      final String dateKey =
          "${forecast.time.year}-"
          "${forecast.time.month.toString().padLeft(2, '0')}-"
          "${forecast.time.day.toString().padLeft(2, '0')}";

      groupedForecasts.putIfAbsent(
        dateKey,
            () => [],
      );

      groupedForecasts[dateKey]!.add(forecast);
    }

    final List<DailyForecastModel> dailyForecasts = [];

    for (final entry in groupedForecasts.entries) {
      final forecastsForDay = entry.value;

      // Din ke beech wali forecast ko representative value ke liye use karenge.
      final ForecastModel representative =
      forecastsForDay[forecastsForDay.length ~/ 2];

      final int minRainProbability =
      forecastsForDay
          .map((forecast) => forecast.rainProbability)
          .reduce((a, b) => a < b ? a : b);

      final int maxRainProbability =
      forecastsForDay
          .map((forecast) => forecast.rainProbability)
          .reduce((a, b) => a > b ? a : b);

      dailyForecasts.add(
        DailyForecastModel(
          date: representative.time,
          temperature: representative.temperature,
          icon: representative.icon,
          condition: representative.condition,
          minRainProbability: minRainProbability,
          maxRainProbability: maxRainProbability,
        ),
      );
    }

    return dailyForecasts;
  }
}