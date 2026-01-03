import 'package:flutter/material.dart';
import '../services/city_service.dart';

class CityProvider with ChangeNotifier {
  final CityService _service = CityService();

  List<String> _cities = [];
  String? _selectedCity;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<String> get cities => _cities;
  String? get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Actions
  Future<void> fetchCitiesForCountry(String countryCode) async {
    _setLoading(true);
    _error = null;
    _cities.clear();

    try {
      _cities = await _service.fetchCities(countryCode);
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void selectCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void clearCities() {
    _cities.clear();
    _selectedCity = null;
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
