class ForecastModel {
  final DateTime time;
  final double temperature;
  final String icon;
  final String condition;
  final int rainProbability;

  ForecastModel({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.condition,
    required this.rainProbability,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
      ),
      temperature: json['main']['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
      condition: json['weather'][0]['main'],
      rainProbability: ((json['pop'] ?? 0) * 100).round(),
    );
  }
}