import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../models/weather_model.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final WeatherService weatherService =
  WeatherService();

  final LocationService locationService =
  LocationService();

  WeatherModel? weatherData;

  bool isLoading = false;
  String? errorMessage;

  final List<String> popularLocations = [
    'Delhi',
    'Mumbai',
    'Bengaluru',
    'Hyderabad',
    'Kolkata',
  ];

  // ==========================================================
  // GET WEATHER BY CITY
  // ==========================================================

  Future<void> _getWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      weatherData = null;
    });

    try {
      final data =
      await weatherService.getWeather(city);

      if (!mounted) return;

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // ==========================================================
  // CURRENT LOCATION
  // ==========================================================

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      weatherData = null;
    });

    try {
      final position =
      await locationService.getCurrentLocation();

      final data =
      await weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    }
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  void _showAboutApp() {
    showAboutDialog(
      context: context,
      applicationName: 'Weather App',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.cloud,
        size: 45,
      ),
      applicationLegalese:
      'A Flutter weather application.',
    );
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

    final Color cardColor = isDark
        ? const Color(0xFF101D2A)
        : Colors.white;

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    final Color accentColor =
        Theme.of(context).colorScheme.primary;

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
              'Settings',
              style: TextStyle(
                color: primaryText,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Customize your weather experience',
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          children: [
            // ==================================================
            // APPEARANCE
            // ==================================================

            _SectionTitle(
              title: 'Appearance',
              color: primaryText,
            ),

            const SizedBox(height: 10),

            // DARK MODE
            _SettingsCard(
              color: cardColor,
              darkMode: isDark,
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable:
                WeatherApp.themeMode,
                builder: (
                    context,
                    themeMode,
                    child,
                    ) {
                  return SwitchListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    secondary: _IconCircle(
                      icon: Icons.dark_mode_outlined,
                      color: accentColor,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      themeMode == ThemeMode.dark
                          ? 'Dark theme enabled'
                          : 'Light theme enabled',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    value:
                    themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      WeatherApp.themeMode.value =
                      value
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // TEMPERATURE UNIT
            _SettingsCard(
              color: cardColor,
              darkMode: isDark,
              child: ValueListenableBuilder<String>(
                valueListenable:
                WeatherApp.temperatureUnit,
                builder: (
                    context,
                    unit,
                    child,
                    ) {
                  return ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: _IconCircle(
                      icon:
                      Icons.thermostat_outlined,
                      color: accentColor,
                    ),
                    title: Text(
                      'Temperature Unit',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      unit == 'C'
                          ? 'Celsius (°C)'
                          : 'Fahrenheit (°F)',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    trailing:
                    DropdownButton<String>(
                      value: unit,
                      underline:
                      const SizedBox.shrink(),
                      dropdownColor: cardColor,
                      items: const [
                        DropdownMenuItem(
                          value: 'C',
                          child: Text('°C'),
                        ),
                        DropdownMenuItem(
                          value: 'F',
                          child: Text('°F'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        WeatherApp
                            .temperatureUnit
                            .value = value;
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // LOCATION
            // ==================================================

            _SectionTitle(
              title: 'Location',
              color: primaryText,
            ),

            const SizedBox(height: 10),

            // CURRENT LOCATION
            _SettingsCard(
              color: cardColor,
              darkMode: isDark,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                leading: _IconCircle(
                  icon: Icons.my_location,
                  color: accentColor,
                ),
                title: Text(
                  'Use Current Location',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'Get weather using GPS',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: secondaryText,
                ),
                onTap:
                _getCurrentLocationWeather,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Popular Locations',
              style: TextStyle(
                color: primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            ...popularLocations.map(
                  (city) {
                return Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: _SettingsCard(
                    color: cardColor,
                    darkMode: isDark,
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 2,
                      ),
                      leading: _IconCircle(
                        icon:
                        Icons.location_on_outlined,
                        color: accentColor,
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          color: primaryText,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: secondaryText,
                      ),
                      onTap: () {
                        _getWeather(city);
                      },
                    ),
                  ),
                );
              },
            ),

            // ==================================================
            // LOADING
            // ==================================================

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // ==================================================
            // ERROR
            // ==================================================

            if (errorMessage != null)
              Container(
                margin:
                const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ==================================================
            // WEATHER RESULT
            // ==================================================

            if (weatherData != null && !isLoading)
              _WeatherResult(
                weather: weatherData!,
                cardColor: cardColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                accentColor: accentColor,
              ),

            const SizedBox(height: 25),

            // ==================================================
            // ABOUT
            // ==================================================

            _SectionTitle(
              title: 'About',
              color: primaryText,
            ),

            const SizedBox(height: 10),

            _SettingsCard(
              color: cardColor,
              darkMode: isDark,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                leading: _IconCircle(
                  icon: Icons.info_outline,
                  color: accentColor,
                ),
                title: Text(
                  'About Weather App',
                  style: TextStyle(
                    color: primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: secondaryText,
                ),
                onTap: _showAboutApp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

// ============================================================
// SETTINGS CARD
// ============================================================

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool darkMode;

  const _SettingsCard({
    required this.child,
    required this.color,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: darkMode
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: darkMode ? 0.22 : 0.06,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================
// ICON CIRCLE
// ============================================================

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconCircle({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 21,
      ),
    );
  }
}

// ============================================================
// WEATHER RESULT
// ============================================================

class _WeatherResult extends StatelessWidget {
  final WeatherModel weather;
  final Color cardColor;
  final Color primaryText;
  final Color secondaryText;
  final Color accentColor;

  const _WeatherResult({
    required this.weather,
    required this.cardColor,
    required this.primaryText,
    required this.secondaryText,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.network(
            'https://openweathermap.org/img/wn/'
                '${weather.icon}@4x.png',
            width: 85,
            height: 85,
            errorBuilder: (
                context,
                error,
                stackTrace,
                ) {
              return Icon(
                Icons.wb_sunny_rounded,
                size: 55,
                color: accentColor,
              );
            },
          ),

          const SizedBox(height: 5),

          Text(
            weather.cityName,
            style: TextStyle(
              color: primaryText,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            weather.description,
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '${weather.temperature.round()}°C',
            style: TextStyle(
              color: primaryText,
              fontSize: 42,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Feels like '
                '${weather.feelsLike.round()}°C',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _WeatherDetail(
                  icon: Icons.water_drop_outlined,
                  value:
                  '${weather.humidity}%',
                  title: 'Humidity',
                  color: accentColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _WeatherDetail(
                  icon: Icons.air,
                  value:
                  '${(weather.windSpeed * 3.6).toStringAsFixed(1)} km/h',
                  title: 'Wind',
                  color: accentColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WEATHER DETAIL
// ============================================================

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color color;
  final Color primaryText;
  final Color secondaryText;

  const _WeatherDetail({
    required this.icon,
    required this.value,
    required this.title,
    required this.color,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 21,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: secondaryText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}