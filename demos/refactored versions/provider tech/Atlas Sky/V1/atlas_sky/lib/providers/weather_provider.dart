import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();

  Weather? _currentWeather;
  bool _isLoading = false;
  String? _error;

  // Getters
  Weather? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Actions
  Future<void> fetchWeather(String city, {String? countryCode}) async {
    _setLoading(true);
    _error = null;

    try {
      _currentWeather = await _service.fetchWeather(
        city,
        countryCode: countryCode,
      );
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void clearWeather() {
    _currentWeather = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
