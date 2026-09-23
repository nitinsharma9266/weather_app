import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather(String city) async {
    final String? apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenWeather API key not found');
    }

    final Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather'
          '?q=$city'
          '&appid=$apiKey'
          '&units=metric',
    );

    try {
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> weatherData =
        jsonDecode(response.body);

        return weatherData;
      } else {
        throw Exception(
          'Weather request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}