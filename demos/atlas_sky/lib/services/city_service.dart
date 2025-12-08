import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  final String baseUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo";
  final String apiKey =
      "507860880bmshedb57401613ce29p179e98jsnbc8e4958e779"; // replace with your RapidAPI key

  Future<List<String>> fetchCities(String countryCode) async {
    final url =
        "$baseUrl/cities?countryIds=$countryCode&limit=10&sort=-population";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "X-RapidAPI-Key": apiKey,
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
      },
    );

    print("CityService response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["data"] != null && data["data"] is List) {
        final List cities = data["data"];
        return cities.map((c) => c["name"] as String).toList();
      } else {
        throw Exception("Unexpected response format from GeoDB Cities API");
      }
    } else {
      throw Exception("Failed to load cities (code: ${response.statusCode})");
    }
  }
}
