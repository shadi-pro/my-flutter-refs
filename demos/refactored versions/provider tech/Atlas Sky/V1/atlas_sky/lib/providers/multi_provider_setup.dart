import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'country_provider.dart';
import 'city_provider.dart';
import 'weather_provider.dart';
import 'navigation_provider.dart';
import 'theme_provider.dart';
import '../main.dart';

class AppProviders {
  static Future<MultiProvider> init() async {
    final prefs = await SharedPreferences.getInstance();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const AtlasSkyApp(),
    );
  }
}
