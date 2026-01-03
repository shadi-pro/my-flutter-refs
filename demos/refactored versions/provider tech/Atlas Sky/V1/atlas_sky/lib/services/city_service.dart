import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/cache_manager.dart';

class CityService {
  final CacheManager _cache = CacheManager();

  Future<List<String>> fetchCities(String countryCode) async {
    final cacheKey = 'cities_$countryCode';

    // Try cache first
    final cached = await _cache.getCachedData(cacheKey);
    if (cached != null && cached is List) {
      return List<String>.from(cached);
    }

    final url =
        "${AppConstants.geoDbApi}/cities?countryIds=$countryCode&limit=10&sort=-population";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "X-RapidAPI-Key": AppConstants.geoDbApiKey,
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["data"] != null && data["data"] is List) {
        final List cities = data["data"];
        final cityNames = cities.map((c) => c["name"] as String).toList();

        // Cache the result
        await _cache.cacheData(
          cacheKey,
          cityNames,
          Duration(seconds: AppConstants.cityCacheDuration),
        );

        return cityNames;
      } else {
        throw Exception("Unexpected response format from GeoDB Cities API");
      }
    } else {
      throw Exception("Failed to load cities (code: ${response.statusCode})");
    }
  }
}
