import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  // 👉 Replace this with your actual key from https://openweathermap.org/api
  final String apiKey = "6a92ead34ea06ce955603a0af83f5155";
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse("$baseUrl/weather?q=$city&appid=$apiKey&units=metric"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("City not found in OpenWeatherMap");
    } else if (response.statusCode == 401) {
      throw Exception("Invalid API key — please check your key");
    } else {
      throw Exception(
        "Failed to load weather data (code: ${response.statusCode})",
      );
    }
  }
}
