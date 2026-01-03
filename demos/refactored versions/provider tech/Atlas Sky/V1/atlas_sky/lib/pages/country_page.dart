import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../providers/country_provider.dart';
import '../providers/city_provider.dart';
import '../providers/navigation_provider.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'country_info_page.dart';
import 'weather_page.dart';

class CountryPage extends StatefulWidget {
  final String countryName;

  const CountryPage({super.key, required this.countryName});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  void initState() {
    super.initState();
    // Load country data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final countryProvider = Provider.of<CountryProvider>(
        context,
        listen: false,
      );
      countryProvider.searchCountry(widget.countryName);
    });
  }

  void _fetchCities() {
    final countryProvider = Provider.of<CountryProvider>(
      context,
      listen: false,
    );
    final cityProvider = Provider.of<CityProvider>(context, listen: false);

    if (countryProvider.selectedCountry != null) {
      cityProvider.fetchCitiesForCountry(
        countryProvider.selectedCountry!.isoCode,
      );
    }
  }

  void _goToWeatherPage() {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final countryProvider = Provider.of<CountryProvider>(
      context,
      listen: false,
    );
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    if (cityProvider.selectedCity != null &&
        countryProvider.selectedCountry != null) {
      navProvider.navigateTo(
        '/weather',
        arguments: {
          'city': cityProvider.selectedCity!,
          'countryCode': countryProvider.selectedCountry!.isoCode,
        },
      );
    }
  }

  void _goToCountryInfoPage() {
    final countryProvider = Provider.of<CountryProvider>(
      context,
      listen: false,
    );
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    if (countryProvider.selectedCountry != null) {
      navProvider.navigateTo(
        '/country-info',
        arguments: countryProvider.selectedCountry,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No country selected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    // Fetch cities when country is loaded
    if (countryProvider.selectedCountry != null &&
        countryProvider.error == null &&
        !cityProvider.isLoading &&
        cityProvider.cities.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchCities();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              countryProvider.searchCountry(widget.countryName);
              cityProvider.clearCities();
            },
          ),
        ],
      ),
      body: countryProvider.isLoading
          ? const LoadingWidget(message: "Loading country data...")
          : countryProvider.error != null
          ? ErrorDisplayWidget(
              error: countryProvider.error!,
              onRetry: () => countryProvider.searchCountry(widget.countryName),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Country Card
                  if (countryProvider.selectedCountry != null)
                    _buildCountryCard(countryProvider.selectedCountry!),

                  const SizedBox(height: 20),

                  // Cities Section - FIXED HERE
                  cityProvider.isLoading
                      ? const LoadingWidget(message: "Loading cities...")
                      : cityProvider.error != null
                      ? ErrorDisplayWidget(
                          error: cityProvider.error!,
                          onRetry: _fetchCities,
                        )
                      : _buildCitiesSection(cityProvider),

                  const SizedBox(height: 20),

                  // Buttons Section
                  if (countryProvider.selectedCountry != null)
                    _buildButtonsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildCountryCard(Country country) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (country.flagUrl.isNotEmpty)
              Image.network(country.flagUrl, height: 80, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(
              country.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (country.capital != null) Text("Capital: ${country.capital}"),
            Text("Region: ${country.region}"),
            Text("Population: ${country.population}"),
            Text("ISO Code: ${country.isoCode}"),
          ],
        ),
      ),
    );
  }

  Widget _buildCitiesSection(CityProvider cityProvider) {
    return Column(
      children: [
        if (cityProvider.cities.isNotEmpty)
          DropdownButton<String>(
            value: cityProvider.selectedCity,
            hint: const Text("Select a city"),
            isExpanded: true,
            items: cityProvider.cities
                .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                cityProvider.selectCity(value);
              }
            },
          )
        else
          const Text(
            "No cities available for this country",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildButtonsSection() {
    final cityProvider = Provider.of<CityProvider>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: cityProvider.selectedCity != null
              ? _goToWeatherPage
              : null,
          child: const Text("Get Weather"),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _goToCountryInfoPage,
          child: const Text("Get Country Info"),
        ),
      ],
    );
  }
}
