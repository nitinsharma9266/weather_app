import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  // =========================
  // API Key
  // =========================

  String get _apiKey {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenWeather API key not found');
    }

    return apiKey;
  }

  // =========================
  // Weather By City
  // =========================

  Future<WeatherModel> getWeather(String city) async {
    final Uri url = Uri.parse(
      '${ApiConstants.weatherBaseUrl}'
          '${ApiConstants.weatherEndpoint}'
          '?q=${Uri.encodeComponent(city)}'
          '&appid=$_apiKey'
          '&units=metric',
    );

    try {
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> weatherData =
        jsonDecode(response.body);

        return WeatherModel.fromJson(weatherData);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception(
          'Weather request failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // =========================
  // Weather By Coordinates
  // =========================

  Future<WeatherModel> getWeatherByCoordinates(
      double latitude,
      double longitude,
      ) async {
    final Uri url = Uri.parse(
      '${ApiConstants.weatherBaseUrl}'
          '${ApiConstants.weatherEndpoint}'
          '?lat=$latitude'
          '&lon=$longitude'
          '&appid=$_apiKey'
          '&units=metric',
    );

    final response = await http.get(url);

    print(
      'Coordinate Weather Status: ${response.statusCode}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> weatherData =
      jsonDecode(response.body);

      return WeatherModel.fromJson(weatherData);
    } else {
      throw Exception(
        'Weather request failed: ${response.statusCode}',
      );
    }
  }

  // =========================
  // Forecast By Coordinates
  // =========================

  Future<List<ForecastModel>> getForecastByCoordinates(
      double latitude,
      double longitude,
      ) async {
    final Uri url = Uri.parse(
      '${ApiConstants.weatherBaseUrl}'
          '${ApiConstants.forecastEndpoint}'
          '?lat=$latitude'
          '&lon=$longitude'
          '&appid=$_apiKey'
          '&units=metric',
    );

    final response = await http.get(url);

    print(
      'Forecast Status: ${response.statusCode}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body);

      final List<dynamic> forecastList = data['list'];

      return forecastList.map((item) {
        return ForecastModel.fromJson(item);
      }).toList();
    } else {
      throw Exception(
        'Forecast request failed: ${response.statusCode}',
      );
    }
  }
}