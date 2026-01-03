import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../utils/constants.dart';
import '../utils/cache_manager.dart';

class CountryService {
  final CacheManager _cache = CacheManager();

  Future<Country> fetchCountry(String name) async {
    final cacheKey = 'country_${name.toLowerCase()}';

    // Try cache first
    final cached = await _cache.getCachedData(cacheKey);
    if (cached != null) {
      return Country.fromJson(Map<String, dynamic>.from(cached));
    }

    final query = name.trim();

    try {
      // Step 1: Try exact match with fullText=true
      final response = await http.get(
        Uri.parse("${AppConstants.countriesApi}/name/$query?fullText=true"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final country = Country.fromJson(data[0]);
          // Cache the result
          await _cache.cacheData(
            cacheKey,
            data[0],
            Duration(seconds: AppConstants.countryCacheDuration),
          );
          return country;
        }
      }

      // Step 2: Fallback to partial match
      final fallbackResponse = await http.get(
        Uri.parse("${AppConstants.countriesApi}/name/$query"),
      );

      if (fallbackResponse.statusCode == 200) {
        final List data = jsonDecode(fallbackResponse.body);
        if (data.isNotEmpty) {
          final country = Country.fromJson(data[0]);
          // Cache the result
          await _cache.cacheData(
            cacheKey,
            data[0],
            Duration(seconds: AppConstants.countryCacheDuration),
          );
          return country;
        } else {
          throw Exception("No country data found for $query");
        }
      } else if (fallbackResponse.statusCode == 404) {
        throw Exception("Country $query not found");
      } else {
        throw Exception(
          "Failed to load country data (code: ${fallbackResponse.statusCode})",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Country>> fetchAllCountries() async {
    const cacheKey = 'all_countries';

    // Try cache first
    final cached = await _cache.getCachedData(cacheKey);
    if (cached != null && cached is List) {
      return cached.map((json) => Country.fromJson(json)).toList();
    }

    final response = await http.get(
      Uri.parse("${AppConstants.countriesApi}/all"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final countries = data.map((json) => Country.fromJson(json)).toList();

      // Cache the result
      await _cache.cacheData(
        cacheKey,
        data,
        Duration(seconds: AppConstants.countryCacheDuration * 24), // 24 hours
      );

      return countries;
    } else {
      throw Exception("Failed to load countries: ${response.statusCode}");
    }
  }
}
