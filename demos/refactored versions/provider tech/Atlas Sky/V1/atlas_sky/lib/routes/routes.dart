// lib/routes/routes.dart
import 'package:flutter/material.dart';

// Pages
import '../pages/home_page.dart';
import '../pages/country_page.dart';
import '../pages/country_info_page.dart';
import '../pages/weather_page.dart';

// Models
import '../models/country.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: settings,
        );

      case Routes.country:
        final countryName = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (context) => CountryPage(countryName: countryName),
          settings: settings,
        );

      case Routes.countryInfo:
        final country = settings.arguments as Country?;
        if (country == null) {
          return _errorRoute('Country data not available');
        }
        return MaterialPageRoute(
          builder: (context) => CountryInfoPage(country: country),
          settings: settings,
        );

      case Routes.weather:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args == null || args['city'] == null) {
          return _errorRoute('City data not available');
        }
        return MaterialPageRoute(
          builder: (context) => WeatherPage(
            city: args['city'] as String,
            countryCode: args['countryCode'] as String?,
          ),
          settings: settings,
        );

      default:
        return _errorRoute('Route "${settings.name}" not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(Routes.home, (route) => false);
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Routes {
  static const String home = '/';
  static const String country = '/country';
  static const String countryInfo = '/country-info';
  static const String weather = '/weather';
}
