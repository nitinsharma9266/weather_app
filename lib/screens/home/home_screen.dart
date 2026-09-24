import 'package:flutter/material.dart';

import '../../../models/weather_model.dart';
import '../../../services/weather_service.dart';
import '../../../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Weather API service
  final WeatherService weatherService = WeatherService();
  final LocationService locationService = LocationService();

  // API se aane wala weather data
  WeatherModel? weatherData;

  bool isLoading = false;
  String? errorMessage;
  String lastSearchedCity = "";

  Future<void> _searchWeather(String city) async {

    lastSearchedCity = city;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await weatherService.getWeather(city);

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
  Future<void> _getCurrentLocation() async {
    print("📍 Location button tapped");

    try {
      final position = await locationService.getCurrentLocation();

      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");
    } catch (e) {
      print("Location Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(12.0),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  // Search Section
                  // =========================

                  Row(
                    children: [
                      const SizedBox(width: 10),

                      const Icon(
                        Icons.search,
                        color: Colors.blue,
                        size: 20,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: SearchBar(
                          hintText: "Search for city",
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                          WidgetStateProperty.all(Colors.white),

                          onSubmitted: (value) {
                            _searchWeather(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  if (errorMessage != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: () {
                            _searchWeather(lastSearchedCity);
                          },
                          child: const Text("Try Again"),
                        ),
                      ],
                    ),


                  const SizedBox(height: 20),

                  // =========================
                  // Current Weather
                  // =========================

                  Center(
                    child: const Icon(
                      Icons.sunny,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),


                  const SizedBox(height: 20),

                  // Temperature
                  Center(
                    child: Text(
                      weatherData == null
                          ? "--°C"
                          : "${weatherData!.temperature.round()}°C",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Weather Condition
                  Center(
                    child: Text(
                      weatherData == null
                          ? "--"
                          : weatherData!.condition,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Feels Like
                  Center(
                    child: Text(
                      weatherData == null
                          ? "Feels like --°C"
                          : "Feels like "
                          "${weatherData!.feelsLike.round()}°C",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Weather Information Cards
                  // =========================

                  Row(
                    children: [

                      // =========================
                      // Humidity Card
                      // =========================

                      Expanded(
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Column(
                              children: [

                                const Icon(
                                  Icons.water_drop,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  "Humidity",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  weatherData == null
                                      ? "--%"
                                      : "${weatherData!.humidity}%",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // =========================
                      // Wind Card
                      // =========================

                      Expanded(
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),

                            child: Column(
                              children: [

                                const Icon(
                                  Icons.wind_power,
                                  color: Colors.blue,
                                  size: 20,
                                ),

                                const SizedBox(height: 8),

                                const Text(
                                  "Wind",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  weatherData == null
                                      ? "-- km/h"
                                      : "${(weatherData!.windSpeed * 3.6).toStringAsFixed(1)} km/h",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // Hourly Forecast Heading
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

                  // =========================
                  // Hourly Forecast Cards
                  // =========================

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: [

                        // Card 1
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  const Text(
                                    "10:00 AM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "28°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 2
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  const Text(
                                    "11:00 AM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "29°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 3
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  const Text(
                                    "12:00 PM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "30°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Card 4
                        SizedBox(
                          width: 95,
                          height: 140,

                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              child: Column(
                                children: [

                                  const Text(
                                    "1:00 PM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  const Icon(
                                    Icons.sunny,
                                    color: Colors.red,
                                    size: 14,
                                  ),

                                  const SizedBox(height: 8),

                                  const Text(
                                    "31°C",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    " 5 Day Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}