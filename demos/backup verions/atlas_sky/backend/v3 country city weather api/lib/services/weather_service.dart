import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = "6a92ead34ea06ce955603a0af83f5155";
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<Weather> fetchWeather(String city, {String? countryCode}) async {
    // Build query: "City,ISO" if countryCode is provided
    final query = (countryCode != null && countryCode.isNotEmpty)
        ? "$city,$countryCode"
        : city;

    final url = "$baseUrl/weather?q=$query&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Defensive checks
      if (data["main"] == null ||
          data["weather"] == null ||
          data["wind"] == null) {
        throw Exception("Unexpected response format from OpenWeatherMap");
      }

      return Weather.fromJson(data);
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
