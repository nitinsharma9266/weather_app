import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/daily_forecast_model.dart';
import '../../models/forecast_model.dart';
import '../../models/location_search_model.dart';
import '../../models/weather_model.dart';
import '../../services/forecast_service.dart';
import '../../services/location_search_service.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';
import '../../widgets/common/app_error.dart';
import '../../widgets/common/app_loading.dart';
import '../../widgets/search/location_search_results.dart';
import '../../widgets/search/weather_search_bar.dart';
import '../../widgets/weather/daily_forecast.dart';
import '../../widgets/weather/hourly_forecast.dart';
import '../../widgets/weather/weather_header.dart';
import '../../widgets/weather/weather_info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // =========================
  // Services
  // =========================

  final WeatherService weatherService = WeatherService();

  final LocationService locationService = LocationService();

  final LocationSearchService locationSearchService =
  LocationSearchService();

  final ForecastService forecastService = ForecastService();

  // =========================
  // Controllers
  // =========================

  final TextEditingController searchController =
  TextEditingController();

  Timer? _searchDebounce;

  // =========================
  // Weather State
  // =========================

  WeatherModel? weatherData;

  List<ForecastModel> forecastData = [];

  List<DailyForecastModel> dailyForecastData = [];

  // =========================
  // Search State
  // =========================

  List<LocationSearchModel> searchResults = [];

  bool isSearchingLocations = false;

  String lastSearchedCity = "";

  // =========================
  // Loading / Error State
  // =========================

  bool isLoading = false;

  bool isGettingLocation = false;

  String? errorMessage;

  // =========================
  // Search Weather
  // =========================

  Future<void> _searchWeather(String city) async {
    lastSearchedCity = city;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await weatherService.getWeather(city);

      if (!mounted) return;

      setState(() {
        weatherData = data;
        isLoading = false;
        errorMessage = null;
      });

      print("City: ${data.cityName}");
      print("Temperature: ${data.temperature}");
      print("Feels Like: ${data.feelsLike}");
      print("Humidity: ${data.humidity}");
      print("Condition: ${data.condition}");
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceFirst(
          "Exception: ",
          "",
        );
        weatherData = null;
      });
    }
  }

  // =========================
  // Current Location
  // =========================

  Future<void> _getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
      isLoading = true;
      errorMessage = null;
    });

    try {
      final position =
      await locationService.getCurrentLocation();

      final data =
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
      forecastService.getDailyForecast(forecast);

      final nextFiveDays = dailyForecast
          .skip(1)
          .take(5)
          .toList();

      print(
        "Daily Forecast Count: ${dailyForecast.length}",
      );

      for (final day in dailyForecast) {
        print(
          "Daily Date: "
              "${day.date.day}/${day.date.month}/${day.date.year} | "
              "Temp: ${day.temperature}°C | "
              "Condition: ${day.condition} | "
              "Rain: ${day.minRainProbability}% - "
              "${day.maxRainProbability}%",
        );
      }

      for (final item in forecast) {
        print(
          'Time: ${item.time} | '
              'Temp: ${item.temperature}°C | '
              'Condition: ${item.condition} | '
              'Rain: ${item.rainProbability}%',
        );
      }

      if (!mounted) return;

      setState(() {
        weatherData = data;
        forecastData = forecast;
        dailyForecastData = nextFiveDays;
        errorMessage = null;
        isLoading = false;
      });

      searchController.text = data.cityName;

      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");
      print("City: ${data.cityName}");
      print("Temperature: ${data.temperature}");
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString().replaceFirst(
          "Exception: ",
          "",
        );
        isLoading = false;
      });

      print("Location Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  // =========================
  // Search Locations
  // =========================

  Future<void> _searchLocations(String query) async {
    _searchDebounce?.cancel();

    if (query.trim().length < 2) {
      setState(() {
        searchResults = [];
        isSearchingLocations = false;
      });

      return;
    }

    _searchDebounce = Timer(
      const Duration(milliseconds: 500),
          () async {
        if (!mounted) return;

        setState(() {
          isSearchingLocations = true;
        });

        try {
          final results =
          await locationSearchService.searchLocations(
            query,
          );

          if (!mounted) return;

          setState(() {
            searchResults = results;
            isSearchingLocations = false;
          });

          print(
            "Found locations: ${results.length}",
          );
        } catch (e) {
          if (!mounted) return;

          setState(() {
            searchResults = [];
            isSearchingLocations = false;
          });

          print("Location Search Error: $e");
        }
      },
    );
  }

  // =========================
  // Select Search Location
  // =========================

  Future<void> _selectLocation(
      LocationSearchModel location,
      ) async {
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

      final forecast =
      await weatherService.getForecastByCoordinates(
        location.latitude,
        location.longitude,
      );

      final dailyForecast =
      forecastService.getDailyForecast(forecast);

      final nextFiveDays = dailyForecast
          .skip(1)
          .take(5)
          .toList();

      if (!mounted) return;

      setState(() {
        weatherData = data;
        forecastData = forecast;
        dailyForecastData = nextFiveDays;
        isLoading = false;
        errorMessage = null;
      });

      print(
        'Selected Location: ${location.name}',
      );

      print(
        'Latitude: ${location.latitude}',
      );

      print(
        'Longitude: ${location.longitude}',
      );

      print(
        'Weather City: ${data.cityName}',
      );

      print(
        'Temperature: ${data.temperature}',
      );
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

  // =========================
  // Dispose
  // =========================

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  // =========================
  // Build UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed:
            isGettingLocation ? null : _getCurrentLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================
                // Location Section
                // =========================

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 16,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      weatherData == null
                          ? "Delhi India"
                          : weatherData!.cityName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.settings,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =========================
                // Search Bar
                // =========================

                WeatherSearchBar(
                  controller: searchController,
                  onChanged: _searchLocations,
                  onSubmitted: _searchWeather,
                ),

                // =========================
                // Search Loading
                // =========================

                if (isSearchingLocations)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: AppLoading(),
                  ),

                // =========================
                // Search Results
                // =========================

                if (!isSearchingLocations &&
                    searchResults.isNotEmpty)
                  LocationSearchResults(
                    locations: searchResults,
                    onLocationSelected: _selectLocation,
                  ),

                const SizedBox(height: 10),

                // =========================
                // Error
                // =========================

                if (errorMessage != null)
                  AppError(
                    message: errorMessage!,
                    onRetry: () {
                      _searchWeather(lastSearchedCity);
                    },
                  ),

                const SizedBox(height: 20),

                // =========================
                // Main Loading
                // =========================

                if (isLoading)
                  const AppLoading(),

                const SizedBox(height: 20),

                // =========================
                // Current Weather
                // =========================

                WeatherHeader(
                  weather: weatherData,
                ),

                const SizedBox(height: 20),

                // =========================
                // Weather Information
                // =========================

                Row(
                  children: [
                    WeatherInfoCard(
                      icon: Icons.water_drop,
                      title: "Humidity",
                      value: weatherData == null
                          ? "--%"
                          : "${weatherData!.humidity}%",
                    ),

                    const SizedBox(width: 12),

                    WeatherInfoCard(
                      icon: Icons.wind_power,
                      title: "Wind",
                      value: weatherData == null
                          ? "-- km/h"
                          : "${(weatherData!.windSpeed * 3.6).toStringAsFixed(1)} km/h",
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =========================
                // Hourly Forecast
                // =========================

                const Center(
                  child: Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                HourlyForecast(
                  forecasts: forecastData,
                ),

                const SizedBox(height: 20),

                // =========================
                // Daily Forecast
                // =========================

                DailyForecast(
                  forecasts: dailyForecastData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}