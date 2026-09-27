import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/daily_forecast_model.dart';
import '../../models/forecast_model.dart';
import '../../services/forecast_service.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/weather/daily_forecast.dart';
import '../../widgets/weather/hourly_forecast.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() =>
      _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final LocationService locationService =
  LocationService();

  final WeatherService weatherService =
  WeatherService();

  final ForecastService forecastService =
  ForecastService();

  List<ForecastModel> hourlyForecast = [];

  List<DailyForecastModel> dailyForecast = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  // ==========================================================
  // LOAD FORECAST
  // ==========================================================

  Future<void> _loadForecast() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position =
      await locationService.getCurrentLocation();

      final forecast =
      await weatherService
          .getForecastByCoordinates(
        position.latitude,
        position.longitude,
      );

      final daily =
      forecastService.getDailyForecast(
        forecast,
      );

      if (!mounted) return;

      setState(() {
        hourlyForecast = forecast;

        dailyForecast =
            daily.skip(1).take(5).toList();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;

        errorMessage = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF07111C)
        : const Color(0xFFF5F9FD);

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: primaryText,
            size: 21,
          ),
        ),

        title: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Forecast',
              style: TextStyle(
                color: primaryText,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Weather forecast',
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadForecast,
          child: _buildBody(
            context,
            isDark,
            primaryText,
            secondaryText,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BODY CONTENT
  // ==========================================================

  Widget _buildBody(
      BuildContext context,
      bool isDark,
      Color primaryText,
      Color secondaryText,
      ) {
    if (isLoading) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 550,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return _ErrorView(
        message: errorMessage!,
        onRetry: _loadForecast,
      );
    }

    return SingleChildScrollView(
      physics:
      const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        30,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // ==================================================
          // DATE HEADER
          // ==================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF101D2A)
                  : Colors.white,

              borderRadius:
              BorderRadius.circular(20),

              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(
                  alpha: 0.07,
                )
                    : Colors.black.withValues(
                  alpha: 0.04,
                ),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.22 : 0.06,
                  ),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),

            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(
                      alpha: 0.10,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weather Forecast',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                        ).format(
                          DateTime.now(),
                        ),
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================================================
          // HOURLY FORECAST
          // ==================================================

          if (hourlyForecast.isNotEmpty)
            HourlyForecast(
              forecasts: hourlyForecast,
            ),

          const SizedBox(height: 26),

          // ==================================================
          // DAILY FORECAST
          // ==================================================

          if (dailyForecast.isNotEmpty)
            DailyForecast(
              forecasts: dailyForecast,
            ),
        ],
      ),
    );
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    return SingleChildScrollView(
      physics:
      const AlwaysScrollableScrollPhysics(),

      child: SizedBox(
        height: 550,

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(
                      alpha: 0.08,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_off,
                    size: 42,
                    color: Colors.redAccent,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Unable to load forecast',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(
                    Icons.refresh,
                  ),
                  label: const Text(
                    'Try Again',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}