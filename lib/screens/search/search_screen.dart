import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/location_search_model.dart';
import '../../models/weather_model.dart';
import '../../services/location_search_service.dart';
import '../../services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController =
  TextEditingController();

  final LocationSearchService locationSearchService =
  LocationSearchService();

  final WeatherService weatherService =
  WeatherService();

  List<LocationSearchModel> searchResults = [];

  WeatherModel? weatherData;

  bool isSearching = false;
  bool isLoading = false;

  String? errorMessage;

  // ==========================================================
  // SEARCH LOCATIONS
  // ==========================================================

  Future<void> _searchLocations(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    try {
      final results =
      await locationSearchService.searchLocations(query);

      if (!mounted) return;

      setState(() {
        searchResults = results;
        isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  // ==========================================================
  // SELECT LOCATION
  // ==========================================================

  Future<void> _selectLocation(
      LocationSearchModel location,
      ) async {
    FocusScope.of(context).unfocus();

    searchController.text = location.name;

    setState(() {
      searchResults = [];
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data =
      await weatherService.getWeatherByCoordinates(
        location.latitude,
        location.longitude,
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? const Color(0xFF07111C)
        : const Color(0xFFF5F9FD);

    final Color primaryText =
    isDark ? Colors.white : Colors.black87;

    final Color secondaryText =
    isDark ? Colors.white70 : Colors.black54;

    final Color cardColor = isDark
        ? const Color(0xFF101D2A)
        : Colors.white;

    final Color accentColor =
        Theme.of(context).colorScheme.primary;

    final DateTime now = DateTime.now();

    final String day =
    DateFormat('EEEE').format(now);

    final String date =
    DateFormat('dd MMMM yyyy').format(now);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search',
              style: TextStyle(
                color: primaryText,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Find weather for any city',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // DATE
              // ==================================================

              Text(
                day,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                date,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // SEARCH BAR
              // ==================================================

              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.black.withValues(alpha: 0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.20 : 0.06,
                      ),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _searchLocations,
                  style: TextStyle(
                    color: primaryText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for a city...',
                    hintStyle: TextStyle(
                      color: secondaryText,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: accentColor,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // SEARCH LOADING
              // ==================================================

              if (isSearching)
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // ==================================================
              // SEARCH RESULTS
              // ==================================================

              if (!isSearching &&
                  searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.20 : 0.06,
                        ),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children:
                    searchResults.map((location) {
                      return ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(
                              alpha: 0.10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: accentColor,
                          ),
                        ),
                        title: Text(
                          location.name,
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          [
                            if (location.state != null)
                              location.state!,
                            location.country,
                          ].join(', '),
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: secondaryText,
                        ),
                        onTap: () {
                          _selectLocation(location);
                        },
                      );
                    }).toList(),
                  ),
                ),

              // ==================================================
              // WEATHER LOADING
              // ==================================================

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // ==================================================
              // ERROR
              // ==================================================

              if (errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(
                      alpha: 0.08,
                    ),
                    borderRadius:
                    BorderRadius.circular(16),
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
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                    BorderRadius.circular(26),
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
                          alpha: isDark ? 0.25 : 0.07,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Weather icon
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(
                            alpha: 0.08,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://openweathermap.org/img/wn/'
                              '${weatherData!.icon}@4x.png',
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Icon(
                              Icons.wb_sunny_rounded,
                              size: 50,
                              color: accentColor,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // City
                      Text(
                        weatherData!.cityName,
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Condition
                      Text(
                        weatherData!.description,
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Temperature
                      Text(
                        '${weatherData!.temperature.round()}°C',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Feels like '
                            '${weatherData!.feelsLike.round()}°C',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Details
                      Row(
                        children: [
                          Expanded(
                            child: _DetailBox(
                              icon: Icons.water_drop_outlined,
                              value:
                              '${weatherData!.humidity}%',
                              title: 'Humidity',
                              color: accentColor,
                              primaryText: primaryText,
                              secondaryText:
                              secondaryText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _DetailBox(
                              icon: Icons.air,
                              value:
                              '${(weatherData!.windSpeed * 3.6).toStringAsFixed(1)} km/h',
                              title: 'Wind',
                              color: accentColor,
                              primaryText: primaryText,
                              secondaryText:
                              secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DETAIL BOX
// ============================================================

class _DetailBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;
  final Color color;
  final Color primaryText;
  final Color secondaryText;

  const _DetailBox({
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