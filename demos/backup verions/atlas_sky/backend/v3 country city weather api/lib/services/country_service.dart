import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  final String baseUrl = "https://restcountries.com/v3.1";

  Future<Country> fetchCountry(String name) async {
    final query = name.trim();

    try {
      // Step 1: Try exact match with fullText=true
      final response = await http.get(
        Uri.parse("$baseUrl/name/$query?fullText=true"),
      );
      print("Exact match response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return Country.fromJson(data[0]);
        }
      }

      // Step 2: Fallback to partial match
      final fallbackResponse = await http.get(
        Uri.parse("$baseUrl/name/$query"),
      );
      print("Fallback response: ${fallbackResponse.statusCode}");

      if (fallbackResponse.statusCode == 200) {
        final List data = jsonDecode(fallbackResponse.body);
        if (data.isNotEmpty) {
          return Country.fromJson(data[0]);
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
      // Defensive catch for network/JSON errors
      throw Exception("Error fetching country data: $e");
    }
  }
}
