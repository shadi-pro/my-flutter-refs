import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_background.dart';
import '../providers/country_provider.dart';
import '../providers/navigation_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load all countries on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).loadAllCountries();
    });
  }

  void _goToCountryPage() {
    final query = _countryController.text.trim();
    if (query.isNotEmpty) {
      final countryProvider = Provider.of<CountryProvider>(
        context,
        listen: false,
      );
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );

      countryProvider.searchCountry(query).then((_) {
        if (countryProvider.selectedCountry != null &&
            countryProvider.error == null) {
          navProvider.navigateTo('/country', arguments: query);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a country name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "AtlasSky",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Search Section
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Search Input
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
                            onPressed: _goToCountryPage,
                          ),
                        ),
                        onSubmitted: (_) => _goToCountryPage(),
                      ),

                      const SizedBox(height: 20),

                      // Search Button
                      ElevatedButton(
                        onPressed: _goToCountryPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          "Search Country",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      // Recent Searches
                      if (countryProvider.recentSearches.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          "Recent Searches:",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: countryProvider.recentSearches
                              .map(
                                (search) => Chip(
                                  label: Text(search),
                                  onDeleted: () {
                                    // Could add functionality to remove from recent searches
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
