import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/location_search_model.dart';

class LocationSearchService {
  Future<List<LocationSearchModel>> searchLocations(
      String query,
      ) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenWeather API key not found');
    }

    if (query.trim().isEmpty) {
      return [];
    }

    final Uri url = Uri.parse(
      '${ApiConstants.geocodingBaseUrl}'
          '${ApiConstants.directGeocodingEndpoint}'
          '?q=${Uri.encodeComponent(query)}'
          '&limit=5'
          '&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) {
        return LocationSearchModel(
          name: item['name'],
          state: item['state'],
          country: item['country'],
          latitude: item['lat'].toDouble(),
          longitude: item['lon'].toDouble(),
        );
      }).toList();
    }

    throw Exception(
      'Location search failed: ${response.statusCode}',
    );
  }
}