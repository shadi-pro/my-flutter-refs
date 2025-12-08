import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import '../services/city_service.dart';
import 'weather_page.dart';

class CountryPage extends StatefulWidget {
  final String countryName;

  const CountryPage({super.key, required this.countryName});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final CountryService _countryService = CountryService();
  final CityService _cityService = CityService();

  Country? country;
  List<String> cities = [];
  String? selectedCity;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCountryAndCities();
  }

  Future<void> _fetchCountryAndCities() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedCountry = await _countryService.fetchCountry(
        widget.countryName,
      );
      final fetchedCities = await _cityService.fetchCities(
        fetchedCountry.isoCode,
      );

      setState(() {
        country = fetchedCountry;
        cities = fetchedCities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Could not load data for ${widget.countryName}";
        isLoading = false;
      });
    }
  }

  void _goToWeatherPage() {
    if (selectedCity != null && country != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WeatherPage(city: selectedCity!, countryCode: country!.isoCode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Country card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (country?.flagUrl.isNotEmpty ?? false)
                            Image.network(
                              country!.flagUrl,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 12),
                          Text(
                            country?.name ?? "Unknown",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (country?.capital != null)
                            Text("Capital: ${country!.capital}"),
                          Text("Region: ${country?.region ?? "Unknown"}"),
                          Text("Population: ${country?.population ?? 0}"),
                          Text("ISO Code: ${country?.isoCode ?? "--"}"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // City dropdown
                  if (cities.isNotEmpty)
                    DropdownButton<String>(
                      value: selectedCity,
                      hint: const Text("Select a city"),
                      items: cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    )
                  else
                    const Text(
                      "No cities available for this country",
                      style: TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _goToWeatherPage,
                    child: const Text("Get Weather"),
                  ),
                ],
              ),
            ),
    );
  }
}
