class DailyForecastModel {
  final DateTime date;
  final double temperature;
  final String icon;
  final String condition;
  final int minRainProbability;
  final int maxRainProbability;

  DailyForecastModel({
    required this.date,
    required this.temperature,
    required this.icon,
    required this.condition,
    required this.minRainProbability,
    required this.maxRainProbability,
  });
}