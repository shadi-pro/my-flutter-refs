import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryProvider with ChangeNotifier {
  final CountryService _service = CountryService();

  Country? _selectedCountry;
  List<Country> _countries = [];
  bool _isLoading = false;
  String? _error;
  List<String> _recentSearches = [];

  // Getters
  Country? get selectedCountry => _selectedCountry;
  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get recentSearches => _recentSearches;

  // Actions
  Future<void> searchCountry(String name) async {
    _setLoading(true);
    _error = null;

    try {
      final country = await _service.fetchCountry(name);
      _selectedCountry = country;

      // Add to recent searches
      if (!_recentSearches.contains(name)) {
        _recentSearches.insert(0, name);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
        notifyListeners(); // For recent searches update
      }

      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  Future<void> loadAllCountries() async {
    _setLoading(true);

    try {
      _countries = await _service.fetchAllCountries();
      _setLoading(false);
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
    }
  }

  void selectCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
