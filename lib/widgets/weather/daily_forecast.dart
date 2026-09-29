import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../models/daily_forecast_model.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyForecastModel> forecasts;

  const DailyForecast({
    super.key,
    required this.forecasts,
  });

  String _formatTemperature(double temperature) {
    if (WeatherApp.temperatureUnit.value == 'F') {
      final fahrenheit = (temperature * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }

    return '${temperature.round()}°C';
  }

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    return ValueListenableBuilder<String>(
      valueListenable: WeatherApp.temperatureUnit,
      builder: (context, temperatureUnit, child) {
        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.fiveDayForecast,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.forecast,
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...forecasts.asMap().entries.map(
                  (entry) {
                final int index = entry.key;
                final DailyForecastModel day =
                    entry.value;

                return TweenAnimationBuilder<double>(
                  duration: Duration(
                    milliseconds: 450 + (index * 80),
                  ),
                  tween: Tween<double>(
                    begin: 0,
                    end: 1,
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (
                      context,
                      value,
                      child,
                      ) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          18 * (1 - value),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: _DailyForecastCard(
                    day: day,
                    isDark: isDark,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    formatTemperature:
                    _formatTemperature,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _DailyForecastCard extends StatelessWidget {
  final DailyForecastModel day;
  final bool isDark;
  final Color primaryText;
  final Color secondaryText;
  final String Function(double) formatTemperature;

  const _DailyForecastCard({
    required this.day,
    required this.isDark,
    required this.primaryText,
    required this.secondaryText,
    required this.formatTemperature,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isDark
        ? const Color(0xFF101D2A)
        : Colors.white;

    final Color accentColor = isDark
        ? const Color(0xFF55B9FF)
        : Theme.of(context).colorScheme.primary;

    final String dayName =
    _getDayName(day.date);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.24 : 0.06,
            ),
            blurRadius: 13,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              dayName,
              style: TextStyle(
                color: primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accentColor.withValues(
                alpha: isDark ? 0.10 : 0.07,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.network(
              'https://openweathermap.org/img/wn/'
                  '${day.icon}@2x.png',
              width: 48,
              height: 48,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Icon(
                  Icons.cloud,
                  color: accentColor,
                  size: 30,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  day.condition,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      color: accentColor,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${day.minRainProbability}% - '
                            '${day.maxRainProbability}% '
                            '${AppStrings.rain}',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            formatTemperature(day.temperature),
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    const List<String> days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[date.weekday - 1];
  }
}