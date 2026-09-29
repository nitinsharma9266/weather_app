import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../models/forecast_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const HourlyForecast({
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Forecast",
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
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics:
                const BouncingScrollPhysics(),
                itemCount: forecasts.length,
                itemBuilder: (context, index) {
                  final forecast = forecasts[index];

                  return TweenAnimationBuilder<double>(
                    duration: Duration(
                      milliseconds: 400 + (index * 80),
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
                            20 * (1 - value),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: _HourlyCard(
                      forecast: forecast,
                      isDark: isDark,
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      formatTemperature:
                      _formatTemperature,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HourlyCard extends StatelessWidget {
  final ForecastModel forecast;
  final bool isDark;
  final Color primaryText;
  final Color secondaryText;
  final String Function(double) formatTemperature;

  const _HourlyCard({
    required this.forecast,
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

    return Container(
      width: 108,
      margin: const EdgeInsets.only(
        right: 12,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 8,
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
              alpha: isDark ? 0.24 : 0.07,
            ),
            blurRadius: 13,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            Helpers.formatForecastTime(
              forecast.time,
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: accentColor.withValues(
                alpha: isDark ? 0.10 : 0.07,
              ),
              shape: BoxShape.circle,
            ),
            child: Image.network(
              'https://openweathermap.org/img/wn/'
                  '${forecast.icon}@2x.png',
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
          const SizedBox(height: 7),
          Text(
            formatTemperature(
              forecast.temperature,
            ),
            style: TextStyle(
              color: primaryText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.water_drop_outlined,
                color: accentColor,
                size: 12,
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  '${forecast.rainProbability}% '
                      '${AppStrings.rain}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}