// Updated main.dart with separated routes
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Providers
import 'providers/country_provider.dart';
import 'providers/city_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';

// Routes
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const AtlasSkyApp(),
    ),
  );
}

class AtlasSkyApp extends StatelessWidget {
  const AtlasSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'AtlasSky',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.themeMode,
          navigatorKey: navProvider.navigatorKey,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: Routes.home,
        );
      },
    );
  }
}
