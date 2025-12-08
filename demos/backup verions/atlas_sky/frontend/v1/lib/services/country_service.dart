import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  final String baseUrl = "https://restcountries.com/v3.1";

  Future<Country> fetchCountry(String name) async {
    final response = await http.get(Uri.parse("$baseUrl/name/$name"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return Country.fromJson(data[0]); // convert JSON → Country model
    } else {
      throw Exception("Failed to load country data");
    }
  }
}
