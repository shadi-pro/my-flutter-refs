import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';
import '../utils/cache_manager.dart';

class WeatherService {
  final CacheManager _cache = CacheManager();

  Future<Weather> fetchWeather(String city, {String? countryCode}) async {
    final query = (countryCode != null && countryCode.isNotEmpty)
        ? "$city,$countryCode"
        : city;

    final cacheKey = 'weather_${query.toLowerCase()}';

    // Try cache first
    final cached = await _cache.getCachedData(cacheKey);
    if (cached != null) {
      return Weather.fromJson(Map<String, dynamic>.from(cached));
    }

    final url =
        "${AppConstants.weatherApi}/weather?q=$query&appid=${AppConstants.weatherApiKey}&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["main"] == null ||
          data["weather"] == null ||
          data["wind"] == null) {
        throw Exception("Unexpected response format from OpenWeatherMap");
      }

      final weather = Weather.fromJson(data);

      // Cache the result
      await _cache.cacheData(
        cacheKey,
        data,
        Duration(seconds: AppConstants.weatherCacheDuration),
      );

      return weather;
    } else if (response.statusCode == 404) {
      throw Exception("City '$query' not found in OpenWeatherMap");
    } else if (response.statusCode == 401) {
      throw Exception("Invalid API key — please check your key");
    } else {
      throw Exception(
        "Failed to load weather data (code: ${response.statusCode})",
      );
    }
  }
}
