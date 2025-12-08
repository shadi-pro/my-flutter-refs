import 'package:flutter/material.dart';
import 'country_page.dart';
import '../services/country_service.dart';
import '../services/city_service.dart';
import '../models/country.dart';
import 'weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _countryController = TextEditingController();
  final CountryService _countryService = CountryService();
  final CityService _cityService = CityService();

  Country? selectedCountry;
  List<String> cities = [];
  String? selectedCity;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _loadCountryAndCities() async {
    final query = _countryController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      cities = [];
      selectedCity = null;
    });

    try {
      final country = await _countryService.fetchCountry(query);
      final fetchedCities = await _cityService.fetchCities(country.isoCode);

      setState(() {
        selectedCountry = country;
        cities = fetchedCities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Could not load data for $query";
        isLoading = false;
      });
    }
  }

  void _goToWeatherPage() {
    if (selectedCountry != null && selectedCity != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherPage(
            city: selectedCity!,
            countryCode: selectedCountry!.isoCode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "AtlasSky",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    hintText: "Enter country name",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.blue),
                      onPressed: _loadCountryAndCities,
                    ),
                  ),
                  onSubmitted: (_) => _loadCountryAndCities(),
                ),
                const SizedBox(height: 20),
                if (isLoading) const CircularProgressIndicator(),
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (cities.isNotEmpty)
                  DropdownButton<String>(
                    value: selectedCity,
                    hint: const Text("Select a city"),
                    items: cities
                        .map(
                          (city) =>
                              DropdownMenuItem(value: city, child: Text(city)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _goToWeatherPage,
                  child: const Text("Get Weather"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
