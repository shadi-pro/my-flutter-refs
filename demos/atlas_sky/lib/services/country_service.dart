import 'dart:convert';
import 'package:http/http.dart' as http;

class CountryService {
  final String baseUrl = "https://restcountries.com/v3.1";

  /// Fetch country details by name
  Future<Map<String, dynamic>> fetchCountry(String name) async {
    final response = await http.get(Uri.parse("$baseUrl/name/$name"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0]; // first match
    } else {
      throw Exception("Failed to load country info");
    }
  }
}
