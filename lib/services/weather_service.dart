// weather_service.dart
// Real API integration using Open-Meteo (free, no API key required).
// This is the file to link for the "API integration" checklist item.

import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherResult {
  final double temperatureC;
  final double windSpeedKmh;
  final String condition;

  WeatherResult({
    required this.temperatureC,
    required this.windSpeedKmh,
    required this.condition,
  });
}

class WeatherService {
  // Default coordinates: Rawalpindi, Pakistan. Change these to your city.
  static const double _latitude = 33.5651;
  static const double _longitude = 73.0169;

  /// Fetches current weather. Throws an Exception on failure so the UI
  /// layer can show a real error/fallback state.
  static Future<WeatherResult> fetchCurrentWeather() async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$_latitude&longitude=$_longitude&current_weather=true',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Weather API returned status ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current_weather'] as Map<String, dynamic>?;

    if (current == null) {
      throw Exception('Unexpected API response format');
    }

    return WeatherResult(
      temperatureC: (current['temperature'] as num).toDouble(),
      windSpeedKmh: (current['windspeed'] as num).toDouble(),
      condition: _describeWeatherCode(current['weathercode'] as int),
    );
  }

  // Maps Open-Meteo's numeric weather codes to short human-readable text.
  static String _describeWeatherCode(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Fog';
    if (code <= 67) return 'Rain';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Rain showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }
}
