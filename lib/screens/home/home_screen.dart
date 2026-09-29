import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/app.dart';
import '../../app/routes.dart';
import '../../models/daily_forecast_model.dart';
import '../../models/forecast_model.dart';
import '../../models/weather_model.dart';
import '../../services/forecast_service.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/weather/daily_forecast.dart';
import '../../widgets/weather/hourly_forecast.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigate;

  const HomeScreen({
    super.key,
    this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService weatherService =
  WeatherService();

  final LocationService locationService =
  LocationService();

  final ForecastService forecastService =
  ForecastService();

  final TextEditingController searchController =
  TextEditingController();

  WeatherModel? weatherData;

  List<ForecastModel> forecastData = [];

  List<DailyForecastModel> dailyForecastData = [];

  bool isLoading = false;

  bool isGettingLocation = false;

  String? errorMessage;

  // ==========================================================
  // BACKGROUND IMAGE
  // ==========================================================

  static const String backgroundImage =
      'assets/images/weather_background.jpeg.jfif';

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CURRENT LOCATION
  // ==========================================================

  Future<void> _getCurrentLocation() async {
    if (isGettingLocation) return;

    setState(() {
      isGettingLocation = true;
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position =
      await locationService.getCurrentLocation();

      final weather =
      await weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final forecast =
      await weatherService.getForecastByCoordinates(
        position.latitude,
        position.longitude,
      );

      final dailyForecast =
      forecastService.getDailyForecast(
        forecast,
      );

      if (!mounted) return;

      setState(() {
        weatherData = weather;

        forecastData = forecast;

        dailyForecastData =
            dailyForecast.skip(1).take(5).toList();

        searchController.text =
            weather.cityName;

        isLoading = false;

        isGettingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );

        isLoading = false;

        isGettingLocation = false;
      });
    }
  }

  // ==========================================================
  // SEARCH WEATHER
  // ==========================================================

  Future<void> _searchWeather(
      String city,
      ) async {
    if (city.trim().isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final weather =
      await weatherService.getWeather(
        city.trim(),
      );

      if (!mounted) return;

      setState(() {
        weatherData = weather;

        searchController.text =
            weather.cityName;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );

        isLoading = false;
      });
    }
  }

  String _formatTemperature(double temperature) {
    if (WeatherApp.temperatureUnit.value == 'F') {
      final fahrenheit = (temperature * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }

    return '${temperature.round()}°C';
  }

  // ==========================================================
  // WEATHER INSIGHT
  // ==========================================================

  String _getWeatherInsight() {
    if (weatherData == null) {
      return 'Checking current weather conditions...';
    }

    final condition =
    weatherData!.condition.toLowerCase();

    if (condition.contains('rain') ||
        condition.contains('drizzle') ||
        condition.contains('thunderstorm')) {
      return 'Take an umbrella before heading outside.';
    }

    if (condition.contains('clear')) {
      return 'Good day for outdoor activities!';
    }

    if (condition.contains('cloud')) {
      return 'A comfortable day with some clouds.';
    }

    if (condition.contains('snow')) {
      return 'Stay warm and take care while going outside.';
    }

    return 'Check the weather before planning your day.';
  }

  IconData _getInsightIcon() {
    if (weatherData == null) {
      return Icons.cloud_outlined;
    }

    final condition =
    weatherData!.condition.toLowerCase();

    if (condition.contains('rain') ||
        condition.contains('drizzle')) {
      return Icons.umbrella_rounded;
    }

    if (condition.contains('thunderstorm')) {
      return Icons.thunderstorm_rounded;
    }

    if (condition.contains('clear')) {
      return Icons.wb_sunny_rounded;
    }

    if (condition.contains('cloud')) {
      return Icons.cloud_rounded;
    }

    return Icons.wb_cloudy_rounded;
  }

  // ==========================================================
  // SETTINGS
  // ==========================================================

  void _openSettings() {
    Navigator.pushNamed(
      context,
      AppRoutes.settings,
    );
  }

  // ==========================================================
  // DRAWER
  // ==========================================================

  void _openRoute(String route) {
    Navigator.pop(context);

    if (widget.onNavigate != null) {
      if (route == AppRoutes.home) {
        widget.onNavigate!(0);
        return;
      }

      if (route == AppRoutes.forecast) {
        widget.onNavigate!(1);
        return;
      }

      if (route == AppRoutes.search) {
        widget.onNavigate!(2);
        return;
      }
    }

    Navigator.pushNamed(
      context,
      route,
    );
  }

  // ==========================================================
  // WEATHER ICON
  // ==========================================================

  String _weatherIconUrl() {
    final String icon =
        weatherData?.icon ?? '01d';

    return 'https://openweathermap.org/img/wn/'
        '${icon}@4x.png';
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: WeatherApp.temperatureUnit,
      builder: (context, temperatureUnit, child) {
        final bool isDark =
            Theme
                .of(context)
                .brightness ==
                Brightness.dark;

        final Color accentColor =
        isDark
            ? const Color(0xFF58B9FF)
            : const Color(0xFF1594E8);

        final Color glassColor =
        Colors.black.withValues(
          alpha: isDark ? 0.34 : 0.27,
        );

        final String currentDate =
        DateFormat(
          'EEE, dd MMM yyyy  hh:mm a',
        ).format(
          DateTime.now(),
        );

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor:
          const Color(0xFF081725),

          // ======================================================
          // DRAWER
          // ======================================================

          drawer: Drawer(
            backgroundColor:
            const Color(0xFF0B1724),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_rounded,
                      color: accentColor,
                      size: 34,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Weather App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Know the weather, plan your day',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Divider(
                    color: Colors.white12,
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.home_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _openRoute(
                        AppRoutes.home,
                      );
                    },
                  ),

// 👇 NEW
                  ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      await _getCurrentLocation();
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.search_rounded,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _openRoute(
                        AppRoutes.search,
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Forecast',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _openRoute(
                        AppRoutes.forecast,
                      );
                    },
                  ),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: WeatherApp.themeMode,
                    builder: (context, themeMode, child) {
                      final isDark = themeMode == ThemeMode.dark;

                      return SwitchListTile(
                        secondary: Icon(
                          isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: Colors.white70,
                        ),
                        title: const Text(
                          'Dark Mode',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        value: isDark,
                        onChanged: (value) {
                          WeatherApp.themeMode.value =
                          value ? ThemeMode.dark : ThemeMode.light;
                        },
                        activeColor: const Color(0xFF58B9FF),
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white70,
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _openRoute(
                        AppRoutes.settings,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // APP BAR
          // ======================================================

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,

            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 31,
                  ),
                );
              },
            ),

            titleSpacing: 0,

            title: const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Weather App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Know the weather, plan your day',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.profile,
                  );
                },
                icon: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 6),
            ],
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: Stack(
            children: [
              // --------------------------------------------------
              // REAL PHOTO BACKGROUND
              // --------------------------------------------------

              Positioned.fill(
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              // --------------------------------------------------
              // LIGHT OVERLAY
              // --------------------------------------------------

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(
                          alpha: 0.20,
                        ),
                        Colors.black.withValues(
                          alpha: 0.10,
                        ),
                        const Color(
                          0xFF06121E,
                        ).withValues(
                          alpha: 0.88,
                        ),
                      ],
                      stops: const [
                        0.0,
                        0.42,
                        1.0,
                      ],
                    ),
                  ),
                ),
              ),

              // --------------------------------------------------
              // CONTENT
              // --------------------------------------------------

              SafeArea(
                child: RefreshIndicator(
                  color: accentColor,
                  onRefresh:
                  _getCurrentLocation,

                  child: SingleChildScrollView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),

                    padding:
                    const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      125,
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                      children: [
                        // ==================================================
                        // SEARCH BAR
                        // ==================================================

                        Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.17,
                            ),
                            borderRadius:
                            BorderRadius.circular(
                              19,
                            ),
                            border: Border.all(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: TextField(
                            controller:
                            searchController,

                            onSubmitted:
                            _searchWeather,

                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),

                            decoration:
                            InputDecoration(
                              border:
                              InputBorder.none,

                              prefixIcon:
                              const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 25,
                              ),

                              hintText:
                              'Search city...',

                              hintStyle:
                              const TextStyle(
                                color:
                                Colors.white70,
                                fontSize: 15,
                              ),

                              contentPadding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 17,
                              ),

                              suffixIcon:
                              searchController
                                  .text
                                  .isNotEmpty
                                  ? IconButton(
                                onPressed: () {
                                  searchController
                                      .clear();

                                  setState(() {});
                                },
                                icon:
                                const Icon(
                                  Icons.close,
                                  color:
                                  Colors
                                      .white70,
                                ),
                              )
                                  : null,
                            ),

                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ==================================================
                        // LOCATION
                        // ==================================================

                        if (weatherData != null)
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration:
                                BoxDecoration(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.18,
                                  ),
                                  shape:
                                  BoxShape.circle,
                                ),
                                child:
                                const Icon(
                                  Icons
                                      .location_on_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      weatherData!
                                          .cityName,
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 25,
                                        fontWeight:
                                        FontWeight.w800,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      currentDate,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 22),

                        // ==================================================
                        // LOADING
                        // ==================================================

                        if (isGettingLocation && weatherData == null)
                          const Positioned.fill(
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),

                        // ==================================================
                        // ERROR
                        // ==================================================

                        if (errorMessage != null)
                          Container(
                            padding:
                            const EdgeInsets.all(
                              18,
                            ),
                            decoration:
                            BoxDecoration(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.45,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons
                                      .cloud_off_rounded,
                                  color:
                                  Colors.white,
                                  size: 42,
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  errorMessage!,
                                  textAlign:
                                  TextAlign.center,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                ElevatedButton(
                                  onPressed:
                                  _getCurrentLocation,
                                  child:
                                  const Text(
                                    'Try Again',
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ==================================================
                        // MAIN WEATHER
                        // ==================================================

                        if (weatherData != null) ...[
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                            children: [
                              // WEATHER ICON
                              Expanded(
                                flex: 4,
                                child: Image.network(
                                  _weatherIconUrl(),
                                  height: 135,
                                  width: 135,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context,
                                      error,
                                      stackTrace,) {
                                    return const Icon(
                                      Icons
                                          .wb_sunny_rounded,
                                      color:
                                      Colors.white,
                                      size: 90,
                                    );
                                  },
                                ),
                              ),

                              // TEMPERATURE
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(
                                      _formatTemperature(
                                          weatherData!.temperature),
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 58,
                                        height: 1,
                                        fontWeight:
                                        FontWeight.w800,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      weatherData!
                                          .condition,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 21,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      'Feels like '
                                          '${_formatTemperature(
                                          weatherData!.feelsLike)}',
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ==================================================
                          // WEATHER INFORMATION GLASS PANEL
                          // ==================================================

                          Container(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              vertical: 16,
                            ),
                            decoration:
                            BoxDecoration(
                              color: glassColor,
                              borderRadius:
                              BorderRadius.circular(
                                24,
                              ),
                              border: Border.all(
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.20,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(
                                    alpha: 0.20,
                                  ),
                                  blurRadius: 20,
                                  offset:
                                  const Offset(
                                    0,
                                    8,
                                  ),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _GlassWeatherInfo(
                                  icon: Icons
                                      .water_drop_outlined,
                                  value:
                                  '${weatherData!.humidity}%',
                                  title: 'Humidity',
                                  accentColor:
                                  accentColor,
                                ),

                                _GlassDivider(),

                                _GlassWeatherInfo(
                                  icon:
                                  Icons.air_rounded,
                                  value:
                                  '${(weatherData!.windSpeed * 3.6)
                                      .toStringAsFixed(1)} km/h',
                                  title: 'Wind',
                                  accentColor:
                                  accentColor,
                                ),

                                _GlassDivider(),

                                _GlassWeatherInfo(
                                  icon: Icons
                                      .thermostat_outlined,
                                  value:
                                  '${weatherData!.feelsLike.round()}°C',
                                  title: 'Feels Like',
                                  accentColor:
                                  accentColor,
                                ),

                                _GlassDivider(),

                                _GlassWeatherInfo(
                                  icon:
                                  Icons.speed_rounded,
                                  value:
                                  '${weatherData!.pressure} hPa',
                                  title: 'Pressure',
                                  accentColor:
                                  accentColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ==================================================
                          // WEATHER INSIGHT
                          // ==================================================

                          Container(
                            padding:
                            const EdgeInsets.all(
                              15,
                            ),
                            decoration:
                            BoxDecoration(
                              color: glassColor,
                              borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                              border: Border.all(
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.18,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    accentColor
                                        .withValues(
                                      alpha: 0.18,
                                    ),
                                    shape:
                                    BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getInsightIcon(),
                                    color:
                                    accentColor,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      const Text(
                                        'Weather Insight',
                                        style:
                                        TextStyle(
                                          color:
                                          Colors.white70,
                                          fontSize: 11,
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 3,
                                      ),

                                      Text(
                                        _getWeatherInsight(),
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.white,
                                          fontSize: 14,
                                          fontWeight:
                                          FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons
                                      .chevron_right_rounded,
                                  color:
                                  Colors.white70,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ==================================================
                          // TODAY'S FORECAST
                          // ==================================================

                          if (!isLoading &&
                              forecastData.isNotEmpty)
                            HourlyForecast(
                              forecasts:
                              forecastData,
                            ),

                          const SizedBox(height: 25),

                          // ==================================================
                          // 5 DAY FORECAST
                          // ==================================================

                          if (!isLoading &&
                              dailyForecastData
                                  .isNotEmpty)
                            DailyForecast(
                              forecasts:
                              dailyForecastData,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

        );
      },
    );
  }

}



// ============================================================
// GLASS WEATHER INFO
// ============================================================

class _GlassWeatherInfo
    extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color accentColor;

  const _GlassWeatherInfo({
    required this.icon,
    required this.value,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 25,
            ),

            const SizedBox(height: 8),

            Text(
              value,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// GLASS DIVIDER
// ============================================================

class _GlassDivider
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 58,
      color: Colors.white.withValues(
        alpha: 0.12,
      ),
    );
  }
}

